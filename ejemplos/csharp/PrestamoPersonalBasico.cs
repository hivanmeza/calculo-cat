using System;

/// <summary>
/// Cálculo del CAT para Préstamos Personales Básicos
/// 
/// Este módulo implementa el algoritmo para calcular el Costo Anual Total (CAT)
/// para préstamos personales con pagos fijos mensuales.
/// </summary>
namespace CalculoCAT
{
    public class PrestamoPersonalBasico
    {
        /// <summary>
        /// Calcula el CAT para un préstamo personal con pagos fijos mensuales.
        /// </summary>
        /// <param name="montoCredito">Monto del crédito en pesos</param>
        /// <param name="plazoMeses">Plazo del crédito en meses</param>
        /// <param name="tasaInteresAnual">Tasa de interés anual (en decimal, ej: 0.12 para 12%)</param>
        /// <param name="comisionApertura">Comisión por apertura (en pesos)</param>
        /// <param name="comisionesMensuales">Comisiones mensuales fijas (en pesos)</param>
        /// <param name="seguro">Costo del seguro mensual (en pesos)</param>
        /// <param name="otrosCostos">Otros costos iniciales (en pesos)</param>
        /// <returns>CAT expresado como porcentaje anual (ej: 16.5 para 16.5%)</returns>
        public static double CalcularCAT(
            double montoCredito, 
            int plazoMeses, 
            double tasaInteresAnual, 
            double comisionApertura = 0, 
            double comisionesMensuales = 0, 
            double seguro = 0, 
            double otrosCostos = 0)
        {
            // Convertir tasa anual a mensual
            double tasaMensual = tasaInteresAnual / 12;
            
            // Calcular pago mensual (amortización + intereses)
            double pagoMensual = montoCredito * (tasaMensual * Math.Pow(1 + tasaMensual, plazoMeses)) / 
                              (Math.Pow(1 + tasaMensual, plazoMeses) - 1);
            
            // Monto neto recibido (descontando comisiones y otros costos iniciales)
            double montoNeto = montoCredito - comisionApertura - otrosCostos;
            
            // Flujos de efectivo (valor negativo para salidas, positivo para entradas)
            double[] flujos = new double[plazoMeses + 1];
            flujos[0] = montoNeto;  // Flujo inicial (dinero recibido)
            
            // Agregar pagos mensuales (salidas de dinero)
            for (int i = 1; i <= plazoMeses; i++)
            {
                flujos[i] = -(pagoMensual + comisionesMensuales + seguro);
            }
            
            // Calcular el CAT usando el método de Newton-Raphson
            double cat = CalcularTIR(flujos) * 12 * 100;  // Convertir a porcentaje anual
            
            return cat;
        }

        /// <summary>
        /// Calcula la Tasa Interna de Retorno (TIR) mensual para una serie de flujos de efectivo.
        /// </summary>
        /// <param name="flujos">Lista de flujos de efectivo, donde el primer elemento es el monto neto recibido
        /// y los siguientes son los pagos (negativos)</param>
        /// <param name="tolerancia">Tolerancia para la convergencia del método</param>
        /// <param name="maxIteraciones">Número máximo de iteraciones</param>
        /// <returns>TIR mensual expresada como decimal</returns>
        public static double CalcularTIR(double[] flujos, double tolerancia = 1e-10, int maxIteraciones = 1000)
        {
            // Estimación inicial
            double tasa = 0.1;
            
            for (int i = 0; i < maxIteraciones; i++)
            {
                // Calcular el valor presente neto con la tasa actual
                double vpn = CalcularVPN(flujos, tasa);
                
                // Si el VPN está dentro de la tolerancia, hemos encontrado la TIR
                if (Math.Abs(vpn) < tolerancia)
                {
                    return tasa;
                }
                
                // Calcular la derivada del VPN respecto a la tasa
                double derivada = CalcularDerivadaVPN(flujos, tasa);
                
                // Actualizar la tasa usando el método de Newton-Raphson
                double nuevaTasa = tasa - vpn / derivada;
                
                // Si la tasa no cambia significativamente, hemos convergido
                if (Math.Abs(nuevaTasa - tasa) < tolerancia)
                {
                    return nuevaTasa;
                }
                
                tasa = nuevaTasa;
            }
            
            // Si no converge, devolver la mejor aproximación
            return tasa;
        }

        /// <summary>
        /// Calcula el Valor Presente Neto (VPN) para una serie de flujos de efectivo y una tasa dada.
        /// </summary>
        /// <param name="flujos">Lista de flujos de efectivo</param>
        /// <param name="tasa">Tasa de descuento mensual</param>
        /// <returns>VPN calculado</returns>
        public static double CalcularVPN(double[] flujos, double tasa)
        {
            double vpn = 0;
            for (int i = 0; i < flujos.Length; i++)
            {
                vpn += flujos[i] / Math.Pow(1 + tasa, i);
            }
            return vpn;
        }

        /// <summary>
        /// Calcula la derivada del VPN respecto a la tasa para una serie de flujos de efectivo.
        /// </summary>
        /// <param name="flujos">Lista de flujos de efectivo</param>
        /// <param name="tasa">Tasa de descuento mensual</param>
        /// <returns>Derivada del VPN respecto a la tasa</returns>
        public static double CalcularDerivadaVPN(double[] flujos, double tasa)
        {
            double derivada = 0;
            for (int i = 0; i < flujos.Length; i++)
            {
                if (i > 0)  // La derivada del primer flujo es cero
                {
                    derivada -= i * flujos[i] / Math.Pow(1 + tasa, i + 1);
                }
            }
            return derivada;
        }

        /// <summary>
        /// Ejemplo de uso para un préstamo personal básico.
        /// </summary>
        public static void EjemploPrestamoPersonal()
        {
            // Parámetros del préstamo
            double montoCredito = 50000;  // $50,000 pesos
            int plazoMeses = 24;  // 2 años
            double tasaInteresAnual = 0.24;  // 24% anual
            double comisionApertura = 1000;  // $1,000 pesos
            double comisionesMensuales = 50;  // $50 pesos mensuales
            double seguro = 100;  // $100 pesos mensuales
            double otrosCostos = 500;  // $500 pesos
            
            // Calcular el CAT
            double cat = CalcularCAT(
                montoCredito,
                plazoMeses,
                tasaInteresAnual,
                comisionApertura,
                comisionesMensuales,
                seguro,
                otrosCostos
            );
            
            // Imprimir resultados
            Console.WriteLine($"Monto del crédito: ${montoCredito:N2}");
            Console.WriteLine($"Plazo: {plazoMeses} meses");
            Console.WriteLine($"Tasa de interés anual: {tasaInteresAnual*100:F2}%");
            Console.WriteLine($"Comisión por apertura: ${comisionApertura:N2}");
            Console.WriteLine($"Comisiones mensuales: ${comisionesMensuales:N2}");
            Console.WriteLine($"Seguro mensual: ${seguro:N2}");
            Console.WriteLine($"Otros costos: ${otrosCostos:N2}");
            Console.WriteLine($"CAT: {cat:F2}%");
        }

        /// <summary>
        /// Punto de entrada principal para ejecutar el ejemplo.
        /// </summary>
        public static void Main(string[] args)
        {
            EjemploPrestamoPersonal();
        }
    }
}