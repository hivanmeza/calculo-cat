using System;
using System.Collections.Generic;

/// <summary>
/// Cálculo del CAT para Créditos Revolventes según Circular 9/2015
/// 
/// Este módulo implementa el algoritmo para calcular el Costo Anual Total (CAT)
/// para créditos revolventes (incluyendo tarjetas de crédito) siguiendo la
/// metodología establecida en la Circular 9/2015 del Banco de México.
/// </summary>
namespace CalculoCAT
{
    public static class CreditoRevolvente
    {
        /// <summary>
        /// Calcula el CAT para un crédito revolvente según la Circular 9/2015.
        /// </summary>
        /// <param name="montoLineaCredito">Monto de la línea de crédito en pesos</param>
        /// <param name="tasaInteresAnual">Tasa de interés anual (en decimal, ej: 0.36 para 36%)</param>
        /// <param name="comisionAnual">Comisión anual (en pesos)</param>
        /// <param name="pagoMinimoProcentaje">Porcentaje del saldo para pago mínimo (decimal)</param>
        /// <param name="otrosCargosMensuales">Otros cargos mensuales fijos (en pesos)</param>
        /// <returns>CAT expresado como porcentaje anual (ej: 45.2 para 45.2%)</returns>
        public static double CalcularCATRevolvente(
            double montoLineaCredito, 
            double tasaInteresAnual, 
            double comisionAnual = 0,
            double pagoMinimoProcentaje = 0.05, 
            double otrosCargosMensuales = 0)
        {
            // Convertir tasa anual a mensual
            double tasaMensual = tasaInteresAnual / 12;
            
            // Plazo fijo de 36 meses según Circular 9/2015
            int plazoMeses = 36;
            
            // Supuestos según Circular 9/2015:
            // 1. Cliente dispone del monto total de la línea al inicio
            // 2. Cliente cubre solo el pago mínimo en cada periodo
            // 3. Cliente vuelve a disponer del monto disponible después de cada pago
            // 4. Intereses, pago mínimo y nuevas disposiciones se generan al final del periodo
            
            // Flujos de efectivo (valor negativo para salidas, positivo para entradas)
            List<double> flujos = new List<double> { montoLineaCredito };  // Flujo inicial (dinero recibido)
            
            // Saldo inicial = monto total de la línea
            double saldo = montoLineaCredito;
            
            // Calcular pagos mensuales y nuevas disposiciones para los 36 meses
            for (int mes = 1; mes <= plazoMeses; mes++)
            {
                // Calcular intereses del periodo
                double intereses = saldo * tasaMensual;
                
                // Calcular pago mínimo (mayor entre porcentaje del saldo y un monto fijo mínimo)
                double pagoMinimo = Math.Max(saldo * pagoMinimoProcentaje, 100);  // Asumimos $100 como mínimo
                
                // Agregar comisión anual al final de cada 12 meses
                double comisionPeriodo = mes % 12 == 0 ? comisionAnual : 0;
                
                // Pago total del periodo (pago mínimo + otros cargos + comisión anual si aplica)
                double pagoTotal = pagoMinimo + otrosCargosMensuales + comisionPeriodo;
                
                // Actualizar saldo: saldo anterior + intereses - pago mínimo
                saldo = saldo + intereses - pagoMinimo;
                
                // Nueva disposición: lo que se pagó del principal (no los intereses)
                double nuevaDisposicion = pagoMinimo > intereses ? pagoMinimo - intereses : 0;
                
                // Si es el último mes, se amortiza todo el saldo restante
                if (mes == plazoMeses)
                {
                    pagoTotal += saldo;
                    saldo = 0;
                    nuevaDisposicion = 0;
                }
                else
                {
                    // Actualizar saldo con nueva disposición
                    saldo += nuevaDisposicion;
                }
                
                // Agregar flujo negativo (pago) y flujo positivo (nueva disposición)
                flujos.Add(-pagoTotal);
                if (nuevaDisposicion > 0)
                {
                    flujos.Add(nuevaDisposicion);
                }
            }
            
            // Calcular el CAT usando el método de Newton-Raphson
            double cat = CalcularTIR(flujos) * 12 * 100;  // Convertir a porcentaje anual
            
            return cat;
        }

        /// <summary>
        /// Calcula la Tasa Interna de Retorno (TIR) mensual usando el método de Newton-Raphson.
        /// </summary>
        /// <param name="flujos">Lista de flujos de efectivo (positivo para entradas, negativo para salidas)</param>
        /// <param name="tolerancia">Tolerancia para convergencia</param>
        /// <param name="maxIteraciones">Número máximo de iteraciones</param>
        /// <returns>TIR mensual (en decimal)</returns>
        public static double CalcularTIR(List<double> flujos, double tolerancia = 1e-10, int maxIteraciones = 1000)
        {
            // Estimación inicial
            double tasa = 0.1;  // 10% mensual como punto de partida
            
            for (int iter = 0; iter < maxIteraciones; iter++)
            {
                // Calcular VPN con la tasa actual
                double vpn = 0;
                double dvpn = 0;  // Derivada del VPN respecto a la tasa
                
                for (int i = 0; i < flujos.Count; i++)
                {
                    double factor = Math.Pow(1 + tasa, i);
                    vpn += flujos[i] / factor;
                    if (i > 0)  // La derivada del primer término es cero
                    {
                        dvpn -= i * flujos[i] / Math.Pow(1 + tasa, i + 1);
                    }
                }
                
                // Si VPN está cerca de cero, hemos encontrado la TIR
                if (Math.Abs(vpn) < tolerancia)
                {
                    return tasa;
                }
                
                // Actualizar tasa usando el método de Newton-Raphson
                double nuevaTasa = dvpn != 0 ? tasa - vpn / dvpn : tasa * 1.1;
                
                // Si la tasa no cambia significativamente, hemos convergido
                if (Math.Abs(nuevaTasa - tasa) < tolerancia)
                {
                    return nuevaTasa;
                }
                
                // Actualizar para la siguiente iteración
                tasa = nuevaTasa;
                
                // Si la tasa se vuelve negativa o muy grande, ajustar
                if (tasa <= 0)
                {
                    tasa = 0.001;  // 0.1% mensual
                }
                else if (tasa > 1)
                {
                    tasa = 0.9;  // 90% mensual (extremadamente alto)
                }
            }
            
            // Si no converge, devolver la mejor aproximación
            return tasa;
        }

        /// <summary>
        /// Calcula el CAT para una tarjeta de crédito según la Circular 9/2015,
        /// utilizando los montos de línea de crédito establecidos en UDIS.
        /// </summary>
        /// <param name="tipoTarjeta">Tipo de tarjeta: "clasica", "oro" o "platino"</param>
        /// <param name="tasaInteresAnual">Tasa de interés anual (en decimal)</param>
        /// <param name="comisionAnual">Comisión anual (en pesos)</param>
        /// <param name="pagoMinimoProcentaje">Porcentaje del saldo para pago mínimo (decimal)</param>
        /// <returns>CAT expresado como porcentaje anual</returns>
        public static double CalcularCATTarjetaCredito(
            string tipoTarjeta = "clasica", 
            double tasaInteresAnual = 0.36, 
            double comisionAnual = 0, 
            double pagoMinimoProcentaje = 0.05)
        {
            // Valor de la UDI (ejemplo, debe actualizarse con el valor real)
            double valorUDI = 7.5;  // Valor aproximado, debe obtenerse de fuentes oficiales
            
            // Montos en UDIS según Circular 9/2015
            Dictionary<string, double> montosUDIS = new Dictionary<string, double>
            {
                { "clasica", 3000 },
                { "oro", 7000 },
                { "platino", 13000 }
            };
            
            // Convertir UDIS a pesos
            double montoLineaCredito;
            if (montosUDIS.ContainsKey(tipoTarjeta.ToLower()))
            {
                montoLineaCredito = montosUDIS[tipoTarjeta.ToLower()] * valorUDI;
            }
            else
            {
                // Valor predeterminado si el tipo no está definido
                montoLineaCredito = montosUDIS["clasica"] * valorUDI;
            }
            
            // Calcular el CAT
            double cat = CalcularCATRevolvente(
                montoLineaCredito,
                tasaInteresAnual,
                comisionAnual,
                pagoMinimoProcentaje
            );
            
            return cat;
        }

        /// <summary>
        /// Ejemplo de uso de las funciones de cálculo del CAT para tarjetas de crédito
        /// </summary>
        public static void EjemploCalculoCATTarjetas()
        {
            // Ejemplo 1: Tarjeta de crédito clásica
            double catClasica = CalcularCATTarjetaCredito(
                "clasica",
                0.36,  // 36% anual
                700,   // $700 de anualidad
                0.05   // 5% del saldo
            );
            
            Console.WriteLine($"CAT para tarjeta clásica: {catClasica:F2}%");
            
            // Ejemplo 2: Tarjeta de crédito oro
            double catOro = CalcularCATTarjetaCredito(
                "oro",
                0.30,  // 30% anual
                1200,  // $1,200 de anualidad
                0.08   // 8% del saldo
            );
            
            Console.WriteLine($"CAT para tarjeta oro: {catOro:F2}%");
            
            // Ejemplo 3: Tarjeta de crédito platino
            double catPlatino = CalcularCATTarjetaCredito(
                "platino",
                0.25,  // 25% anual
                2000,  // $2,000 de anualidad
                0.10   // 10% del saldo
            );
            
            Console.WriteLine($"CAT para tarjeta platino: {catPlatino:F2}%");
        }
    }

    // Clase para ejecutar ejemplos
    class Program
    {
        static void Main(string[] args)
        {
            CreditoRevolvente.EjemploCalculoCATTarjetas();
            Console.WriteLine("Presione cualquier tecla para salir...");
            Console.ReadKey();
        }
    }
}