package main

import (
	"fmt"
	"math"
)

/*
Cálculo del CAT para Préstamos Personales Básicos

Este módulo implementa el algoritmo para calcular el Costo Anual Total (CAT)
para préstamos personales con pagos fijos mensuales.
*/

// CalcularCAT calcula el CAT para un préstamo personal con pagos fijos mensuales.
//
// Parámetros:
//   montoCredito: Monto del crédito en pesos
//   plazoMeses: Plazo del crédito en meses
//   tasaInteresAnual: Tasa de interés anual (en decimal, ej: 0.12 para 12%)
//   comisionApertura: Comisión por apertura (en pesos)
//   comisionesMensuales: Comisiones mensuales fijas (en pesos)
//   seguro: Costo del seguro mensual (en pesos)
//   otrosCostos: Otros costos iniciales (en pesos)
//
// Retorna:
//   CAT expresado como porcentaje anual (ej: 16.5 para 16.5%)
func CalcularCAT(montoCredito, plazoMeses, tasaInteresAnual, comisionApertura, comisionesMensuales, seguro, otrosCostos float64) float64 {
	// Convertir tasa anual a mensual
	tasaMensual := tasaInteresAnual / 12

	// Calcular pago mensual (amortización + intereses)
	pagoMensual := montoCredito * (tasaMensual * math.Pow(1+tasaMensual, plazoMeses)) / (math.Pow(1+tasaMensual, plazoMeses) - 1)

	// Monto neto recibido (descontando comisiones y otros costos iniciales)
	montoNeto := montoCredito - comisionApertura - otrosCostos

	// Flujos de efectivo (valor negativo para salidas, positivo para entradas)
	flujos := []float64{montoNeto} // Flujo inicial (dinero recibido)

	// Agregar pagos mensuales (salidas de dinero)
	for i := 0; i < int(plazoMeses); i++ {
		flujos = append(flujos, -(pagoMensual + comisionesMensuales + seguro))
	}

	// Calcular el CAT usando el método de Newton-Raphson
	cat := CalcularTIR(flujos) * 12 * 100 // Convertir a porcentaje anual

	return cat
}

// CalcularTIR calcula la Tasa Interna de Retorno (TIR) mensual para una serie de flujos de efectivo.
//
// Parámetros:
//   flujos: Lista de flujos de efectivo, donde el primer elemento es el monto neto recibido
//           y los siguientes son los pagos (negativos)
//   tolerancia: Tolerancia para la convergencia del método
//   maxIteraciones: Número máximo de iteraciones
//
// Retorna:
//   TIR mensual expresada como decimal
func CalcularTIR(flujos []float64) float64 {
	tolerancia := 1e-10
	maxIteraciones := 1000

	// Estimación inicial
	tasa := 0.1

	for i := 0; i < maxIteraciones; i++ {
		// Calcular el valor presente neto con la tasa actual
		vpn := CalcularVPN(flujos, tasa)

		// Si el VPN está dentro de la tolerancia, hemos encontrado la TIR
		if math.Abs(vpn) < tolerancia {
			return tasa
		}

		// Calcular la derivada del VPN respecto a la tasa
		derivada := CalcularDerivadaVPN(flujos, tasa)

		// Actualizar la tasa usando el método de Newton-Raphson
		nuevaTasa := tasa - vpn/derivada

		// Si la tasa no cambia significativamente, hemos convergido
		if math.Abs(nuevaTasa-tasa) < tolerancia {
			return nuevaTasa
		}

		tasa = nuevaTasa
	}

	// Si no converge, devolver la mejor aproximación
	return tasa
}

// CalcularVPN calcula el Valor Presente Neto (VPN) para una serie de flujos de efectivo y una tasa dada.
//
// Parámetros:
//   flujos: Lista de flujos de efectivo
//   tasa: Tasa de descuento mensual
//
// Retorna:
//   VPN calculado
func CalcularVPN(flujos []float64, tasa float64) float64 {
	vpn := 0.0
	for i, flujo := range flujos {
		vpn += flujo / math.Pow(1+tasa, float64(i))
	}
	return vpn
}

// CalcularDerivadaVPN calcula la derivada del VPN respecto a la tasa para una serie de flujos de efectivo.
//
// Parámetros:
//   flujos: Lista de flujos de efectivo
//   tasa: Tasa de descuento mensual
//
// Retorna:
//   Derivada del VPN respecto a la tasa
func CalcularDerivadaVPN(flujos []float64, tasa float64) float64 {
	derivada := 0.0
	for i, flujo := range flujos {
		if i > 0 { // La derivada del primer flujo es cero
			derivada -= float64(i) * flujo / math.Pow(1+tasa, float64(i+1))
		}
	}
	return derivada
}

// EjemploPrestamoPersonal muestra un ejemplo de uso para un préstamo personal básico.
func EjemploPrestamoPersonal() {
	// Parámetros del préstamo
	montoCredito := 50000.0       // $50,000 pesos
	plazoMeses := 24.0            // 2 años
	tasaInteresAnual := 0.24      // 24% anual
	comisionApertura := 1000.0    // $1,000 pesos
	comisionesMensuales := 50.0   // $50 pesos mensuales
	seguro := 100.0               // $100 pesos mensuales
	otrosCostos := 500.0          // $500 pesos

	// Calcular el CAT
	cat := CalcularCAT(
		montoCredito,
		plazoMeses,
		tasaInteresAnual,
		comisionApertura,
		comisionesMensuales,
		seguro,
		otrosCostos,
	)

	// Imprimir resultados
	fmt.Printf("Monto del crédito: $%.2f\n", montoCredito)
	fmt.Printf("Plazo: %.0f meses\n", plazoMeses)
	fmt.Printf("Tasa de interés anual: %.2f%%\n", tasaInteresAnual*100)
	fmt.Printf("Comisión por apertura: $%.2f\n", comisionApertura)
	fmt.Printf("Comisiones mensuales: $%.2f\n", comisionesMensuales)
	fmt.Printf("Seguro mensual: $%.2f\n", seguro)
	fmt.Printf("Otros costos: $%.2f\n", otrosCostos)
	fmt.Printf("CAT: %.2f%%\n", cat)
}

func main() {
	EjemploPrestamoPersonal()
}