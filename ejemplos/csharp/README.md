# Implementaciones en C# para el Cálculo del CAT

Esta carpeta contiene implementaciones en C# de los algoritmos para el cálculo del CAT (Costo Anual Total) en diferentes escenarios financieros.

## Estructura de la Carpeta

Los ejemplos están organizados por tipo de crédito:

### 1. Préstamos Personales
- `PrestamoPersonalBasico.cs`: Implementación básica para préstamos personales con pagos fijos
- `PrestamoPersonalVariable.cs`: Cálculo para préstamos con tasas variables

### 2. Créditos Automotrices
- `CreditoAutomotriz.cs`: Implementación para créditos automotrices con pagos regulares
- `CreditoAutomotrizBalloon.cs`: Ejemplo con pago final globo (balloon payment)

### 3. Créditos Hipotecarios
- `CreditoHipotecarioFijo.cs`: Implementación para hipotecas de tasa fija
- `CreditoHipotecarioVariable.cs`: Cálculo para hipotecas de tasa variable

### 4. Tarjetas de Crédito
- `TarjetaCreditoRevolvente.cs`: Implementación para líneas de crédito revolventes
- `TarjetaCreditoMSI.cs`: Cálculo para compras a meses sin intereses

### 5. Microcréditos
- `MicrocreditoGrupal.cs`: Implementación para microcréditos grupales
- `MicrocreditoIndividual.cs`: Cálculo para microcréditos individuales

### 6. Casos Especiales
- `PagosIrregulares.cs`: Implementación para créditos con pagos irregulares
- `ComisionesVariables.cs`: Cálculo con comisiones variables en el tiempo

## Requisitos

```
.NET 6.0+
```

## Uso de los Ejemplos

Cada archivo de ejemplo incluye:
- Documentación detallada de los parámetros de entrada
- Implementación del algoritmo de cálculo
- Ejemplos de uso con valores de muestra
- Resultados esperados para verificación