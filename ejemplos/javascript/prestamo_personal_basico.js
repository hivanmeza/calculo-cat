/**
 * Cálculo del CAT para Préstamos Personales Básicos
 *
 * Este módulo implementa el algoritmo para calcular el Costo Anual Total (CAT)
 * para préstamos personales con pagos fijos mensuales.
 */

/**
 * Calcula el CAT para un préstamo personal con pagos fijos mensuales.
 * 
 * @param {number} montoCredito - Monto del crédito en pesos
 * @param {number} plazoMeses - Plazo del crédito en meses
 * @param {number} tasaInteresAnual - Tasa de interés anual (en decimal, ej: 0.12 para 12%)
 * @param {number} comisionApertura - Comisión por apertura (en pesos)
 * @param {number} comisionesMensuales - Comisiones mensuales fijas (en pesos)
 * @param {number} seguro - Costo del seguro mensual (en pesos)
 * @param {number} otrosCostos - Otros costos iniciales (en pesos)
 * @returns {number} CAT expresado como porcentaje anual (ej: 16.5 para 16.5%)
 */
function calcularCAT(montoCredito, plazoMeses, tasaInteresAnual, comisionApertura = 0, 
                    comisionesMensuales = 0, seguro = 0, otrosCostos = 0) {
    // Convertir tasa anual a mensual
    const tasaMensual = tasaInteresAnual / 12;
    
    // Calcular pago mensual (amortización + intereses)
    const pagoMensual = montoCredito * (tasaMensual * Math.pow(1 + tasaMensual, plazoMeses)) / 
                      (Math.pow(1 + tasaMensual, plazoMeses) - 1);
    
    // Monto neto recibido (descontando comisiones y otros costos iniciales)
    const montoNeto = montoCredito - comisionApertura - otrosCostos;
    
    // Flujos de efectivo (valor negativo para salidas, positivo para entradas)
    const flujos = [montoNeto];  // Flujo inicial (dinero recibido)
    
    // Agregar pagos mensuales (salidas de dinero)
    for (let i = 0; i < plazoMeses; i++) {
        flujos.push(-(pagoMensual + comisionesMensuales + seguro));
    }
    
    // Calcular el CAT usando el método de Newton-Raphson
    const cat = calcularTIR(flujos) * 12 * 100;  // Convertir a porcentaje anual
    
    return cat;
}

/**
 * Calcula la Tasa Interna de Retorno (TIR) mensual para una serie de flujos de efectivo.
 * 
 * @param {Array<number>} flujos - Lista de flujos de efectivo, donde el primer elemento es el monto neto recibido
 *                                y los siguientes son los pagos (negativos)
 * @param {number} tolerancia - Tolerancia para la convergencia del método
 * @param {number} maxIteraciones - Número máximo de iteraciones
 * @returns {number} TIR mensual expresada como decimal
 */
function calcularTIR(flujos, tolerancia = 1e-10, maxIteraciones = 1000) {
    // Estimación inicial
    let tasa = 0.1;
    
    for (let i = 0; i < maxIteraciones; i++) {
        // Calcular el valor presente neto con la tasa actual
        const vpn = calcularVPN(flujos, tasa);
        
        // Si el VPN está dentro de la tolerancia, hemos encontrado la TIR
        if (Math.abs(vpn) < tolerancia) {
            return tasa;
        }
        
        // Calcular la derivada del VPN respecto a la tasa
        const derivada = calcularDerivadaVPN(flujos, tasa);
        
        // Actualizar la tasa usando el método de Newton-Raphson
        const nuevaTasa = tasa - vpn / derivada;
        
        // Si la tasa no cambia significativamente, hemos convergido
        if (Math.abs(nuevaTasa - tasa) < tolerancia) {
            return nuevaTasa;
        }
        
        tasa = nuevaTasa;
    }
    
    // Si no converge, devolver la mejor aproximación
    return tasa;
}

/**
 * Calcula el Valor Presente Neto (VPN) para una serie de flujos de efectivo y una tasa dada.
 * 
 * @param {Array<number>} flujos - Lista de flujos de efectivo
 * @param {number} tasa - Tasa de descuento mensual
 * @returns {number} VPN calculado
 */
function calcularVPN(flujos, tasa) {
    let vpn = 0;
    for (let i = 0; i < flujos.length; i++) {
        vpn += flujos[i] / Math.pow(1 + tasa, i);
    }
    return vpn;
}

/**
 * Calcula la derivada del VPN respecto a la tasa para una serie de flujos de efectivo.
 * 
 * @param {Array<number>} flujos - Lista de flujos de efectivo
 * @param {number} tasa - Tasa de descuento mensual
 * @returns {number} Derivada del VPN respecto a la tasa
 */
function calcularDerivadaVPN(flujos, tasa) {
    let derivada = 0;
    for (let i = 0; i < flujos.length; i++) {
        if (i > 0) {  // La derivada del primer flujo es cero
            derivada -= i * flujos[i] / Math.pow(1 + tasa, i + 1);
        }
    }
    return derivada;
}

/**
 * Ejemplo de uso para un préstamo personal básico.
 */
function ejemploPrestamoPersonal() {
    // Parámetros del préstamo
    const montoCredito = 50000;  // $50,000 pesos
    const plazoMeses = 24;  // 2 años
    const tasaInteresAnual = 0.24;  // 24% anual
    const comisionApertura = 1000;  // $1,000 pesos
    const comisionesMensuales = 50;  // $50 pesos mensuales
    const seguro = 100;  // $100 pesos mensuales
    const otrosCostos = 500;  // $500 pesos
    
    // Calcular el CAT
    const cat = calcularCAT(
        montoCredito,
        plazoMeses,
        tasaInteresAnual,
        comisionApertura,
        comisionesMensuales,
        seguro,
        otrosCostos
    );
    
    // Imprimir resultados
    console.log(`Monto del crédito: $${montoCredito.toLocaleString('es-MX', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`);
    console.log(`Plazo: ${plazoMeses} meses`);
    console.log(`Tasa de interés anual: ${(tasaInteresAnual*100).toFixed(2)}%`);
    console.log(`Comisión por apertura: $${comisionApertura.toLocaleString('es-MX', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`);
    console.log(`Comisiones mensuales: $${comisionesMensuales.toLocaleString('es-MX', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`);
    console.log(`Seguro mensual: $${seguro.toLocaleString('es-MX', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`);
    console.log(`Otros costos: $${otrosCostos.toLocaleString('es-MX', {minimumFractionDigits: 2, maximumFractionDigits: 2})}`);
    console.log(`CAT: ${cat.toFixed(2)}%`);
}

// Ejecutar el ejemplo si este archivo se ejecuta directamente
if (require.main === module) {
    ejemploPrestamoPersonal();
}

module.exports = {
    calcularCAT,
    calcularTIR,
    calcularVPN,
    calcularDerivadaVPN
};