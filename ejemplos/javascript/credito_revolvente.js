/**
 * Cálculo del CAT para Créditos Revolventes según Circular 9/2015
 *
 * Este módulo implementa el algoritmo para calcular el Costo Anual Total (CAT)
 * para créditos revolventes (incluyendo tarjetas de crédito) siguiendo la
 * metodología establecida en la Circular 9/2015 del Banco de México.
 */

/**
 * Calcula el CAT para un crédito revolvente según la Circular 9/2015.
 *
 * @param {number} montoLineaCredito - Monto de la línea de crédito en pesos
 * @param {number} tasaInteresAnual - Tasa de interés anual (en decimal, ej: 0.36 para 36%)
 * @param {number} comisionAnual - Comisión anual (en pesos)
 * @param {number} pagoMinimoProcentaje - Porcentaje del saldo para pago mínimo (decimal)
 * @param {number} otrosCargosMensuales - Otros cargos mensuales fijos (en pesos)
 * @returns {number} CAT expresado como porcentaje anual (ej: 45.2 para 45.2%)
 */
function calcularCATRevolvente(montoLineaCredito, tasaInteresAnual, comisionAnual = 0,
                             pagoMinimoProcentaje = 0.05, otrosCargosMensuales = 0) {
    // Convertir tasa anual a mensual
    const tasaMensual = tasaInteresAnual / 12;
    
    // Plazo fijo de 36 meses según Circular 9/2015
    const plazoMeses = 36;
    
    // Supuestos según Circular 9/2015:
    // 1. Cliente dispone del monto total de la línea al inicio
    // 2. Cliente cubre solo el pago mínimo en cada periodo
    // 3. Cliente vuelve a disponer del monto disponible después de cada pago
    // 4. Intereses, pago mínimo y nuevas disposiciones se generan al final del periodo
    
    // Flujos de efectivo (valor negativo para salidas, positivo para entradas)
    const flujos = [montoLineaCredito];  // Flujo inicial (dinero recibido)
    
    // Saldo inicial = monto total de la línea
    let saldo = montoLineaCredito;
    
    // Calcular pagos mensuales y nuevas disposiciones para los 36 meses
    for (let mes = 1; mes <= plazoMeses; mes++) {
        // Calcular intereses del periodo
        const intereses = saldo * tasaMensual;
        
        // Calcular pago mínimo (mayor entre porcentaje del saldo y un monto fijo mínimo)
        const pagoMinimo = Math.max(saldo * pagoMinimoProcentaje, 100);  // Asumimos $100 como mínimo
        
        // Agregar comisión anual al final de cada 12 meses
        const comisionPeriodo = mes % 12 === 0 ? comisionAnual : 0;
        
        // Pago total del periodo (pago mínimo + otros cargos + comisión anual si aplica)
        let pagoTotal = pagoMinimo + otrosCargosMensuales + comisionPeriodo;
        
        // Actualizar saldo: saldo anterior + intereses - pago mínimo
        saldo = saldo + intereses - pagoMinimo;
        
        // Nueva disposición: lo que se pagó del principal (no los intereses)
        let nuevaDisposicion = pagoMinimo > intereses ? pagoMinimo - intereses : 0;
        
        // Si es el último mes, se amortiza todo el saldo restante
        if (mes === plazoMeses) {
            pagoTotal += saldo;
            saldo = 0;
            nuevaDisposicion = 0;
        } else {
            // Actualizar saldo con nueva disposición
            saldo += nuevaDisposicion;
        }
        
        // Agregar flujo negativo (pago) y flujo positivo (nueva disposición)
        flujos.push(-pagoTotal);
        if (nuevaDisposicion > 0) {
            flujos.push(nuevaDisposicion);
        }
    }
    
    // Calcular el CAT usando el método de Newton-Raphson
    const cat = calcularTIR(flujos) * 12 * 100;  // Convertir a porcentaje anual
    
    return cat;
}

/**
 * Calcula la Tasa Interna de Retorno (TIR) mensual usando el método de Newton-Raphson.
 *
 * @param {Array<number>} flujos - Lista de flujos de efectivo (positivo para entradas, negativo para salidas)
 * @param {number} tolerancia - Tolerancia para convergencia
 * @param {number} maxIteraciones - Número máximo de iteraciones
 * @returns {number} TIR mensual (en decimal)
 */
function calcularTIR(flujos, tolerancia = 1e-10, maxIteraciones = 1000) {
    // Estimación inicial
    let tasa = 0.1;  // 10% mensual como punto de partida
    
    for (let iter = 0; iter < maxIteraciones; iter++) {
        // Calcular VPN con la tasa actual
        let vpn = 0;
        let dvpn = 0;  // Derivada del VPN respecto a la tasa
        
        for (let i = 0; i < flujos.length; i++) {
            const factor = Math.pow(1 + tasa, i);
            vpn += flujos[i] / factor;
            if (i > 0) {  // La derivada del primer término es cero
                dvpn -= i * flujos[i] / Math.pow(1 + tasa, i + 1);
            }
        }
        
        // Si VPN está cerca de cero, hemos encontrado la TIR
        if (Math.abs(vpn) < tolerancia) {
            return tasa;
        }
        
        // Actualizar tasa usando el método de Newton-Raphson
        const nuevaTasa = dvpn !== 0 ? tasa - vpn / dvpn : tasa * 1.1;
        
        // Si la tasa no cambia significativamente, hemos convergido
        if (Math.abs(nuevaTasa - tasa) < tolerancia) {
            return nuevaTasa;
        }
        
        // Actualizar para la siguiente iteración
        tasa = nuevaTasa;
        
        // Si la tasa se vuelve negativa o muy grande, ajustar
        if (tasa <= 0) {
            tasa = 0.001;  // 0.1% mensual
        } else if (tasa > 1) {
            tasa = 0.9;  // 90% mensual (extremadamente alto)
        }
    }
    
    // Si no converge, devolver la mejor aproximación
    return tasa;
}

/**
 * Calcula el CAT para una tarjeta de crédito según la Circular 9/2015,
 * utilizando los montos de línea de crédito establecidos en UDIS.
 *
 * @param {string} tipoTarjeta - Tipo de tarjeta: "clasica", "oro" o "platino"
 * @param {number} tasaInteresAnual - Tasa de interés anual (en decimal)
 * @param {number} comisionAnual - Comisión anual (en pesos)
 * @param {number} pagoMinimoProcentaje - Porcentaje del saldo para pago mínimo (decimal)
 * @returns {number} CAT expresado como porcentaje anual
 */
function calcularCATTarjetaCredito(tipoTarjeta = "clasica", tasaInteresAnual = 0.36, 
                                  comisionAnual = 0, pagoMinimoProcentaje = 0.05) {
    // Valor de la UDI (ejemplo, debe actualizarse con el valor real)
    const valorUDI = 7.5;  // Valor aproximado, debe obtenerse de fuentes oficiales
    
    // Montos en UDIS según Circular 9/2015
    const montosUDIS = {
        "clasica": 3000,
        "oro": 7000,
        "platino": 13000
    };
    
    // Convertir UDIS a pesos
    let montoLineaCredito;
    if (montosUDIS[tipoTarjeta.toLowerCase()]) {
        montoLineaCredito = montosUDIS[tipoTarjeta.toLowerCase()] * valorUDI;
    } else {
        // Valor predeterminado si el tipo no está definido
        montoLineaCredito = montosUDIS["clasica"] * valorUDI;
    }
    
    // Calcular el CAT
    const cat = calcularCATRevolvente(
        montoLineaCredito,
        tasaInteresAnual,
        comisionAnual,
        pagoMinimoProcentaje
    );
    
    return cat;
}

// Ejemplo de uso
function ejemploCalculoCATTarjetas() {
    // Ejemplo 1: Tarjeta de crédito clásica
    const catClasica = calcularCATTarjetaCredito(
        "clasica",
        0.36,  // 36% anual
        700,   // $700 de anualidad
        0.05   // 5% del saldo
    );
    
    console.log(`CAT para tarjeta clásica: ${catClasica.toFixed(2)}%`);
    
    // Ejemplo 2: Tarjeta de crédito oro
    const catOro = calcularCATTarjetaCredito(
        "oro",
        0.30,  // 30% anual
        1200,  // $1,200 de anualidad
        0.08   // 8% del saldo
    );
    
    console.log(`CAT para tarjeta oro: ${catOro.toFixed(2)}%`);
    
    // Ejemplo 3: Tarjeta de crédito platino
    const catPlatino = calcularCATTarjetaCredito(
        "platino",
        0.25,  // 25% anual
        2000,  // $2,000 de anualidad
        0.10   // 10% del saldo
    );
    
    console.log(`CAT para tarjeta platino: ${catPlatino.toFixed(2)}%`);
}

// Ejecutar ejemplo si se ejecuta directamente el script
if (typeof require !== 'undefined' && require.main === module) {
    ejemploCalculoCATTarjetas();
}

// Exportar funciones para uso en otros módulos
module.exports = {
    calcularCATRevolvente,
    calcularCATTarjetaCredito,
    calcularTIR
};