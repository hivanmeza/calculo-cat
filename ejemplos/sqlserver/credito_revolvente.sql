/*
Cálculo del CAT para Créditos Revolventes en SQL Server según Circular 9/2015

Este script implementa el algoritmo para calcular el Costo Anual Total (CAT)
para créditos revolventes (incluyendo tarjetas de crédito) siguiendo la
metodología establecida en la Circular 9/2015 del Banco de México.
*/

-- Crear base de datos si no existe
-- IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'CalculoCAT')
-- BEGIN
--     CREATE DATABASE CalculoCAT;
-- END
-- GO

-- USE CalculoCAT;
-- GO

-- Tabla para almacenar los parámetros de créditos revolventes
IF OBJECT_ID('dbo.CreditosRevolventes', 'U') IS NOT NULL
    DROP TABLE dbo.CreditosRevolventes;
GO

CREATE TABLE dbo.CreditosRevolventes
(
    CreditoID INT IDENTITY(1,1) PRIMARY KEY,
    TipoTarjeta VARCHAR(50) NOT NULL,
    MontoLineaCredito DECIMAL(18, 2) NOT NULL,
    TasaInteresAnual DECIMAL(9, 6) NOT NULL,
    ComisionAnual DECIMAL(18, 2) NOT NULL,
    PagoMinimoProcentaje DECIMAL(9, 6) NOT NULL,
    OtrosCargosMensuales DECIMAL(18, 2) NOT NULL,
    FechaCalculo DATETIME DEFAULT GETDATE(),
    CAT DECIMAL(9, 6) NULL
);
GO

-- Función para calcular la TIR (Tasa Interna de Retorno)
IF OBJECT_ID('dbo.CalcularTIR', 'FN') IS NOT NULL
    DROP FUNCTION dbo.CalcularTIR;
GO

CREATE FUNCTION dbo.CalcularTIR
(
    @Flujos NVARCHAR(MAX),  -- Formato JSON de flujos de efectivo
    @Tolerancia DECIMAL(38, 20) = 0.0000000001,
    @MaxIteraciones INT = 1000
)
RETURNS DECIMAL(38, 20)
AS
BEGIN
    DECLARE @Tasa DECIMAL(38, 20) = 0.1;  -- 10% mensual como punto de partida
    DECLARE @Iter INT = 0;
    DECLARE @VPN DECIMAL(38, 20);
    DECLARE @DVPN DECIMAL(38, 20);
    DECLARE @NuevaTasa DECIMAL(38, 20);
    
    WHILE @Iter < @MaxIteraciones
    BEGIN
        SET @VPN = 0;
        SET @DVPN = 0;
        
        -- Calcular VPN y su derivada usando los flujos en formato JSON
        SELECT 
            @VPN = @VPN + Valor / POWER(1 + @Tasa, Indice),
            @DVPN = CASE 
                      WHEN Indice > 0 THEN @DVPN - Indice * Valor / POWER(1 + @Tasa, Indice + 1)
                      ELSE @DVPN
                    END
        FROM OPENJSON(@Flujos)
        WITH (
            Indice INT '$.Indice',
            Valor DECIMAL(38, 20) '$.Valor'
        );
        
        -- Si VPN está cerca de cero, hemos encontrado la TIR
        IF ABS(@VPN) < @Tolerancia
            RETURN @Tasa;
        
        -- Actualizar tasa usando el método de Newton-Raphson
        SET @NuevaTasa = CASE 
                            WHEN @DVPN <> 0 THEN @Tasa - @VPN / @DVPN 
                            ELSE @Tasa * 1.1
                          END;
        
        -- Si la tasa no cambia significativamente, hemos convergido
        IF ABS(@NuevaTasa - @Tasa) < @Tolerancia
            RETURN @NuevaTasa;
        
        -- Actualizar para la siguiente iteración
        SET @Tasa = @NuevaTasa;
        
        -- Si la tasa se vuelve negativa o muy grande, ajustar
        IF @Tasa <= 0
            SET @Tasa = 0.001;  -- 0.1% mensual
        ELSE IF @Tasa > 1
            SET @Tasa = 0.9;    -- 90% mensual (extremadamente alto)
        
        SET @Iter = @Iter + 1;
    END;
    
    -- Si no converge, devolver la mejor aproximación
    RETURN @Tasa;
END;
GO

-- Procedimiento almacenado para calcular el CAT de un crédito revolvente
IF OBJECT_ID('dbo.CalcularCATRevolvente', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CalcularCATRevolvente;
GO

CREATE PROCEDURE dbo.CalcularCATRevolvente
    @CreditoID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MontoLineaCredito DECIMAL(18, 2);
    DECLARE @TasaInteresAnual DECIMAL(9, 6);
    DECLARE @ComisionAnual DECIMAL(18, 2);
    DECLARE @PagoMinimoProcentaje DECIMAL(9, 6);
    DECLARE @OtrosCargosMensuales DECIMAL(18, 2);
    
    -- Obtener los parámetros del crédito
    SELECT 
        @MontoLineaCredito = MontoLineaCredito,
        @TasaInteresAnual = TasaInteresAnual,
        @ComisionAnual = ComisionAnual,
        @PagoMinimoProcentaje = PagoMinimoProcentaje,
        @OtrosCargosMensuales = OtrosCargosMensuales
    FROM dbo.CreditosRevolventes
    WHERE CreditoID = @CreditoID;
    
    -- Verificar que el crédito existe
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('El crédito especificado no existe.', 16, 1);
        RETURN;
    END;
    
    -- Convertir tasa anual a mensual
    DECLARE @TasaMensual DECIMAL(38, 20) = @TasaInteresAnual / 12;
    
    -- Plazo fijo de 36 meses según Circular 9/2015
    DECLARE @PlazoMeses INT = 36;
    
    -- Tabla temporal para almacenar los flujos de efectivo
    DECLARE @Flujos TABLE (
        Indice INT,
        Valor DECIMAL(38, 20)
    );
    
    -- Flujo inicial (dinero recibido)
    INSERT INTO @Flujos (Indice, Valor) VALUES (0, @MontoLineaCredito);
    
    -- Saldo inicial = monto total de la línea
    DECLARE @Saldo DECIMAL(38, 20) = @MontoLineaCredito;
    DECLARE @Mes INT = 1;
    DECLARE @Intereses DECIMAL(38, 20);
    DECLARE @PagoMinimo DECIMAL(38, 20);
    DECLARE @ComisionPeriodo DECIMAL(38, 20);
    DECLARE @PagoTotal DECIMAL(38, 20);
    DECLARE @NuevaDisposicion DECIMAL(38, 20);
    DECLARE @IndiceActual INT = 1;
    
    -- Calcular pagos mensuales y nuevas disposiciones para los 36 meses
    WHILE @Mes <= @PlazoMeses
    BEGIN
        -- Calcular intereses del periodo
        SET @Intereses = @Saldo * @TasaMensual;
        
        -- Calcular pago mínimo (mayor entre porcentaje del saldo y un monto fijo mínimo)
        SET @PagoMinimo = CASE 
                            WHEN @Saldo * @PagoMinimoProcentaje > 100 THEN @Saldo * @PagoMinimoProcentaje 
                            ELSE 100 -- Asumimos $100 como mínimo
                          END;
        
        -- Agregar comisión anual al final de cada 12 meses
        SET @ComisionPeriodo = CASE WHEN @Mes % 12 = 0 THEN @ComisionAnual ELSE 0 END;
        
        -- Pago total del periodo (pago mínimo + otros cargos + comisión anual si aplica)
        SET @PagoTotal = @PagoMinimo + @OtrosCargosMensuales + @ComisionPeriodo;
        
        -- Actualizar saldo: saldo anterior + intereses - pago mínimo
        SET @Saldo = @Saldo + @Intereses - @PagoMinimo;
        
        -- Nueva disposición: lo que se pagó del principal (no los intereses)
        SET @NuevaDisposicion = CASE 
                                  WHEN @PagoMinimo > @Intereses THEN @PagoMinimo - @Intereses 
                                  ELSE 0
                                END;
        
        -- Si es el último mes, se amortiza todo el saldo restante
        IF @Mes = @PlazoMeses
        BEGIN
            SET @PagoTotal = @PagoTotal + @Saldo;
            SET @Saldo = 0;
            SET @NuevaDisposicion = 0;
        END
        ELSE
        BEGIN
            -- Actualizar saldo con nueva disposición
            SET @Saldo = @Saldo + @NuevaDisposicion;
        END;
        
        -- Agregar flujo negativo (pago)
        INSERT INTO @Flujos (Indice, Valor) VALUES (@IndiceActual, -@PagoTotal);
        SET @IndiceActual = @IndiceActual + 1;
        
        -- Agregar flujo positivo (nueva disposición) si existe
        IF @NuevaDisposicion > 0
        BEGIN
            INSERT INTO @Flujos (Indice, Valor) VALUES (@IndiceActual, @NuevaDisposicion);
            SET @IndiceActual = @IndiceActual + 1;
        END;
        
        SET @Mes = @Mes + 1;
    END;
    
    -- Convertir la tabla de flujos a formato JSON para la función CalcularTIR
    DECLARE @FlujosJSON NVARCHAR(MAX);
    SELECT @FlujosJSON = (SELECT Indice, Valor FROM @Flujos FOR JSON PATH);
    
    -- Calcular el CAT (convertir a porcentaje anual)
    DECLARE @TIR DECIMAL(38, 20) = dbo.CalcularTIR(@FlujosJSON);
    DECLARE @CAT DECIMAL(9, 6) = @TIR * 12 * 100;
    
    -- Actualizar el CAT en la tabla de créditos revolventes
    UPDATE dbo.CreditosRevolventes
    SET CAT = @CAT,
        FechaCalculo = GETDATE()
    WHERE CreditoID = @CreditoID;
    
    -- Mostrar el resultado
    SELECT 
        CreditoID,
        TipoTarjeta,
        MontoLineaCredito,
        TasaInteresAnual * 100 AS 'Tasa de Interés Anual (%)',
        ComisionAnual,
        PagoMinimoProcentaje * 100 AS 'Pago Mínimo (%)',
        CAST(CAT AS DECIMAL(9, 2)) AS 'CAT (%)'
    FROM dbo.CreditosRevolventes
    WHERE CreditoID = @CreditoID;
    
    -- Mostrar los flujos para verificación
    SELECT Indice, Valor FROM @Flujos ORDER BY Indice;
END;
GO

-- Procedimiento para calcular el CAT de una tarjeta de crédito según la Circular 9/2015
IF OBJECT_ID('dbo.CalcularCATTarjetaCredito', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CalcularCATTarjetaCredito;
GO

CREATE PROCEDURE dbo.CalcularCATTarjetaCredito
    @TipoTarjeta VARCHAR(50),
    @TasaInteresAnual DECIMAL(9, 6),
    @ComisionAnual DECIMAL(18, 2),
    @PagoMinimoProcentaje DECIMAL(9, 6) = 0.05,
    @OtrosCargosMensuales DECIMAL(18, 2) = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Valor de la UDI (ejemplo, debe actualizarse con el valor real)
    DECLARE @ValorUDI DECIMAL(18, 6) = 7.5;  -- Valor aproximado, debe obtenerse de fuentes oficiales
    
    -- Montos en UDIS según Circular 9/2015
    DECLARE @MontoLineaCredito DECIMAL(18, 2);
    
    -- Asignar monto según tipo de tarjeta
    IF @TipoTarjeta = 'clasica'
        SET @MontoLineaCredito = 3000 * @ValorUDI;
    ELSE IF @TipoTarjeta = 'oro'
        SET @MontoLineaCredito = 7000 * @ValorUDI;
    ELSE IF @TipoTarjeta = 'platino'
        SET @MontoLineaCredito = 13000 * @ValorUDI;
    ELSE
        SET @MontoLineaCredito = 3000 * @ValorUDI;  -- Valor predeterminado
    
    -- Insertar el crédito en la tabla
    INSERT INTO dbo.CreditosRevolventes
    (
        TipoTarjeta,
        MontoLineaCredito,
        TasaInteresAnual,
        ComisionAnual,
        PagoMinimoProcentaje,
        OtrosCargosMensuales
    )
    VALUES
    (
        @TipoTarjeta,
        @MontoLineaCredito,
        @TasaInteresAnual,
        @ComisionAnual,
        @PagoMinimoProcentaje,
        @OtrosCargosMensuales
    );
    
    -- Obtener el ID del crédito insertado
    DECLARE @CreditoID INT = SCOPE_IDENTITY();
    
    -- Calcular el CAT
    EXEC dbo.CalcularCATRevolvente @CreditoID;
END;
GO

-- Ejemplos de uso

-- Ejemplo 1: Tarjeta de crédito clásica
EXEC dbo.CalcularCATTarjetaCredito 
    @TipoTarjeta = 'clasica',
    @TasaInteresAnual = 0.36,  -- 36% anual
    @ComisionAnual = 700,      -- $700 de anualidad
    @PagoMinimoProcentaje = 0.05;  -- 5% del saldo

-- Ejemplo 2: Tarjeta de crédito oro
EXEC dbo.CalcularCATTarjetaCredito 
    @TipoTarjeta = 'oro',
    @TasaInteresAnual = 0.30,  -- 30% anual
    @ComisionAnual = 1200,     -- $1,200 de anualidad
    @PagoMinimoProcentaje = 0.08;  -- 8% del saldo

-- Ejemplo 3: Tarjeta de crédito platino
EXEC dbo.CalcularCATTarjetaCredito 
    @TipoTarjeta = 'platino',
    @TasaInteresAnual = 0.25,  -- 25% anual
    @ComisionAnual = 2000,     -- $2,000 de anualidad
    @PagoMinimoProcentaje = 0.10;  -- 10% del saldo

-- Limpiar objetos creados (comentar si se desea mantener)
-- DROP PROCEDURE dbo.CalcularCATTarjetaCredito;
-- DROP PROCEDURE dbo.CalcularCATRevolvente;
-- DROP FUNCTION dbo.CalcularTIR;
-- DROP TABLE dbo.CreditosRevolventes;