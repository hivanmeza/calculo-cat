/*
Cálculo del CAT para Préstamos Personales Básicos en SQL Server

Este script implementa el algoritmo para calcular el Costo Anual Total (CAT)
para préstamos personales con pagos fijos mensuales utilizando T-SQL.
*/

-- Crear una base de datos para el ejemplo (opcional)
-- USE master;
-- GO
-- IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'CalculoCAT')
-- BEGIN
--     CREATE DATABASE CalculoCAT;
-- END
-- GO
-- USE CalculoCAT;
-- GO

-- Crear tabla para almacenar información de préstamos
IF OBJECT_ID('dbo.Prestamos', 'U') IS NOT NULL
    DROP TABLE dbo.Prestamos;
GO

CREATE TABLE dbo.Prestamos (
    PrestamoID INT IDENTITY(1,1) PRIMARY KEY,
    MontoCredito DECIMAL(18, 2) NOT NULL,
    PlazoMeses INT NOT NULL,
    TasaInteresAnual DECIMAL(9, 6) NOT NULL,
    ComisionApertura DECIMAL(18, 2) NOT NULL DEFAULT 0,
    ComisionesMensuales DECIMAL(18, 2) NOT NULL DEFAULT 0,
    Seguro DECIMAL(18, 2) NOT NULL DEFAULT 0,
    OtrosCostos DECIMAL(18, 2) NOT NULL DEFAULT 0,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CAT DECIMAL(9, 6) NULL
);
GO

-- Crear tabla para almacenar flujos de efectivo
IF OBJECT_ID('dbo.FlujosEfectivo', 'U') IS NOT NULL
    DROP TABLE dbo.FlujosEfectivo;
GO

CREATE TABLE dbo.FlujosEfectivo (
    FlujoID INT IDENTITY(1,1) PRIMARY KEY,
    PrestamoID INT NOT NULL,
    Periodo INT NOT NULL,
    Monto DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_FlujosEfectivo_Prestamos FOREIGN KEY (PrestamoID) REFERENCES dbo.Prestamos (PrestamoID)
);
GO

-- Función para calcular el Valor Presente Neto (VPN)
IF OBJECT_ID('dbo.CalcularVPN', 'FN') IS NOT NULL
    DROP FUNCTION dbo.CalcularVPN;
GO

CREATE FUNCTION dbo.CalcularVPN
(
    @PrestamoID INT,
    @Tasa DECIMAL(18, 10)
)
RETURNS DECIMAL(18, 10)
AS
BEGIN
    DECLARE @VPN DECIMAL(18, 10) = 0;
    
    SELECT @VPN = SUM(Monto / POWER(1 + @Tasa, Periodo))
    FROM dbo.FlujosEfectivo
    WHERE PrestamoID = @PrestamoID;
    
    RETURN @VPN;
END;
GO

-- Función para calcular la derivada del VPN respecto a la tasa
IF OBJECT_ID('dbo.CalcularDerivadaVPN', 'FN') IS NOT NULL
    DROP FUNCTION dbo.CalcularDerivadaVPN;
GO

CREATE FUNCTION dbo.CalcularDerivadaVPN
(
    @PrestamoID INT,
    @Tasa DECIMAL(18, 10)
)
RETURNS DECIMAL(18, 10)
AS
BEGIN
    DECLARE @Derivada DECIMAL(18, 10) = 0;
    
    SELECT @Derivada = SUM(CASE WHEN Periodo > 0 THEN -Periodo * Monto / POWER(1 + @Tasa, Periodo + 1) ELSE 0 END)
    FROM dbo.FlujosEfectivo
    WHERE PrestamoID = @PrestamoID;
    
    RETURN @Derivada;
END;
GO

-- Procedimiento almacenado para calcular la TIR usando el método de Newton-Raphson
IF OBJECT_ID('dbo.CalcularTIR', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CalcularTIR;
GO

CREATE PROCEDURE dbo.CalcularTIR
    @PrestamoID INT,
    @TIR DECIMAL(18, 10) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Tolerancia DECIMAL(18, 10) = 1E-10;
    DECLARE @MaxIteraciones INT = 1000;
    DECLARE @Tasa DECIMAL(18, 10) = 0.1; -- Estimación inicial
    DECLARE @NuevaTasa DECIMAL(18, 10);
    DECLARE @VPN DECIMAL(18, 10);
    DECLARE @Derivada DECIMAL(18, 10);
    DECLARE @Iteracion INT = 0;
    
    WHILE @Iteracion < @MaxIteraciones
    BEGIN
        -- Calcular VPN con la tasa actual
        SET @VPN = dbo.CalcularVPN(@PrestamoID, @Tasa);
        
        -- Si el VPN está dentro de la tolerancia, hemos encontrado la TIR
        IF ABS(@VPN) < @Tolerancia
        BEGIN
            SET @TIR = @Tasa;
            RETURN;
        END;
        
        -- Calcular la derivada del VPN respecto a la tasa
        SET @Derivada = dbo.CalcularDerivadaVPN(@PrestamoID, @Tasa);
        
        -- Evitar división por cero
        IF @Derivada = 0
        BEGIN
            SET @TIR = @Tasa;
            RETURN;
        END;
        
        -- Actualizar la tasa usando el método de Newton-Raphson
        SET @NuevaTasa = @Tasa - @VPN / @Derivada;
        
        -- Si la tasa no cambia significativamente, hemos convergido
        IF ABS(@NuevaTasa - @Tasa) < @Tolerancia
        BEGIN
            SET @TIR = @NuevaTasa;
            RETURN;
        END;
        
        SET @Tasa = @NuevaTasa;
        SET @Iteracion = @Iteracion + 1;
    END;
    
    -- Si no converge, devolver la mejor aproximación
    SET @TIR = @Tasa;
END;
GO

-- Procedimiento almacenado para calcular el CAT
IF OBJECT_ID('dbo.CalcularCAT', 'P') IS NOT NULL
    DROP PROCEDURE dbo.CalcularCAT;
GO

CREATE PROCEDURE dbo.CalcularCAT
    @PrestamoID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MontoCredito DECIMAL(18, 2);
    DECLARE @PlazoMeses INT;
    DECLARE @TasaInteresAnual DECIMAL(9, 6);
    DECLARE @ComisionApertura DECIMAL(18, 2);
    DECLARE @ComisionesMensuales DECIMAL(18, 2);
    DECLARE @Seguro DECIMAL(18, 2);
    DECLARE @OtrosCostos DECIMAL(18, 2);
    
    -- Obtener información del préstamo
    SELECT 
        @MontoCredito = MontoCredito,
        @PlazoMeses = PlazoMeses,
        @TasaInteresAnual = TasaInteresAnual,
        @ComisionApertura = ComisionApertura,
        @ComisionesMensuales = ComisionesMensuales,
        @Seguro = Seguro,
        @OtrosCostos = OtrosCostos
    FROM dbo.Prestamos
    WHERE PrestamoID = @PrestamoID;
    
    -- Convertir tasa anual a mensual
    DECLARE @TasaMensual DECIMAL(18, 10) = @TasaInteresAnual / 12;
    
    -- Calcular pago mensual (amortización + intereses)
    DECLARE @PagoMensual DECIMAL(18, 2) = @MontoCredito * (@TasaMensual * POWER(1 + @TasaMensual, @PlazoMeses)) / 
                                         (POWER(1 + @TasaMensual, @PlazoMeses) - 1);
    
    -- Monto neto recibido (descontando comisiones y otros costos iniciales)
    DECLARE @MontoNeto DECIMAL(18, 2) = @MontoCredito - @ComisionApertura - @OtrosCostos;
    
    -- Limpiar flujos de efectivo anteriores
    DELETE FROM dbo.FlujosEfectivo WHERE PrestamoID = @PrestamoID;
    
    -- Insertar flujo inicial (dinero recibido)
    INSERT INTO dbo.FlujosEfectivo (PrestamoID, Periodo, Monto)
    VALUES (@PrestamoID, 0, @MontoNeto);
    
    -- Insertar pagos mensuales (salidas de dinero)
    DECLARE @i INT = 1;
    WHILE @i <= @PlazoMeses
    BEGIN
        INSERT INTO dbo.FlujosEfectivo (PrestamoID, Periodo, Monto)
        VALUES (@PrestamoID, @i, -(@PagoMensual + @ComisionesMensuales + @Seguro));
        
        SET @i = @i + 1;
    END;
    
    -- Calcular la TIR
    DECLARE @TIR DECIMAL(18, 10);
    EXEC dbo.CalcularTIR @PrestamoID, @TIR OUTPUT;
    
    -- Calcular el CAT (convertir a porcentaje anual)
    DECLARE @CAT DECIMAL(9, 6) = @TIR * 12 * 100;
    
    -- Actualizar el CAT en la tabla de préstamos
    UPDATE dbo.Prestamos
    SET CAT = @CAT
    WHERE PrestamoID = @PrestamoID;
    
    -- Mostrar resultados
    SELECT 
        MontoCredito AS 'Monto del crédito',
        PlazoMeses AS 'Plazo (meses)',
        CAST(TasaInteresAnual * 100 AS DECIMAL(9, 2)) AS 'Tasa de interés anual (%)',
        ComisionApertura AS 'Comisión por apertura',
        ComisionesMensuales AS 'Comisiones mensuales',
        Seguro AS 'Seguro mensual',
        OtrosCostos AS 'Otros costos',
        CAST(CAT AS DECIMAL(9, 2)) AS 'CAT (%)'
    FROM dbo.Prestamos
    WHERE PrestamoID = @PrestamoID;
END;
GO

-- Ejemplo de uso para un préstamo personal básico
IF OBJECT_ID('dbo.EjemploPrestamoPersonal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.EjemploPrestamoPersonal;
GO

CREATE PROCEDURE dbo.EjemploPrestamoPersonal
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Parámetros del préstamo
    DECLARE @MontoCredito DECIMAL(18, 2) = 50000.00;  -- $50,000 pesos
    DECLARE @PlazoMeses INT = 24;                     -- 2 años
    DECLARE @TasaInteresAnual DECIMAL(9, 6) = 0.24;   -- 24% anual
    DECLARE @ComisionApertura DECIMAL(18, 2) = 1000.00; -- $1,000 pesos
    DECLARE @ComisionesMensuales DECIMAL(18, 2) = 50.00; -- $50 pesos mensuales
    DECLARE @Seguro DECIMAL(18, 2) = 100.00;          -- $100 pesos mensuales
    DECLARE @OtrosCostos DECIMAL(18, 2) = 500.00;     -- $500 pesos
    
    -- Insertar el préstamo
    INSERT INTO dbo.Prestamos (
        MontoCredito,
        PlazoMeses,
        TasaInteresAnual,
        ComisionApertura,
        ComisionesMensuales,
        Seguro,
        OtrosCostos
    ) VALUES (
        @MontoCredito,
        @PlazoMeses,
        @TasaInteresAnual,
        @ComisionApertura,
        @ComisionesMensuales,
        @Seguro,
        @OtrosCostos
    );
    
    -- Obtener el ID del préstamo insertado
    DECLARE @PrestamoID INT = SCOPE_IDENTITY();
    
    -- Calcular el CAT
    EXEC dbo.CalcularCAT @PrestamoID;
END;
GO

-- Ejecutar el ejemplo
EXEC dbo.EjemploPrestamoPersonal;
GO

-- Limpiar (opcional)
-- DROP PROCEDURE dbo.EjemploPrestamoPersonal;
-- DROP PROCEDURE dbo.CalcularCAT;
-- DROP PROCEDURE dbo.CalcularTIR;
-- DROP FUNCTION dbo.CalcularDerivadaVPN;
-- DROP FUNCTION dbo.CalcularVPN;
-- DROP TABLE dbo.FlujosEfectivo;
-- DROP TABLE dbo.Prestamos;
-- GO