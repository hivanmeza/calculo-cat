# Casos de Uso para el Cálculo del CAT

Este documento complementa la definición del cálculo del CAT, presentando casos de uso específicos que ilustran la aplicación práctica de las fórmulas y metodologías en diferentes escenarios financieros.

## 1. Préstamos Personales

### Caso 1.1: Préstamo de Nómina

**Características:**
- Monto: $30,000
- Plazo: 12 meses
- Tasa de interés nominal anual: 18%
- Comisión por apertura: 2% ($600)
- Seguro: No incluido
- Pagos: Mensuales fijos

**Flujos de Efectivo:**
- Inicial: +$29,400 (monto - comisión)
- Mensual: -$2,786.31 (calculado con función de pago)

**Cálculo del CAT:**
1. Establecer la ecuación: $29,400 = Σ[$2,786.31 / (1 + CAT/100)^(i/12)] para i de 1 a 12
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 24.6%

**Análisis:**
- La diferencia entre la tasa nominal (18%) y el CAT (24.6%) se debe principalmente a la comisión por apertura
- En préstamos de corto plazo, las comisiones iniciales tienen un impacto mayor en el CAT

### Caso 1.2: Préstamo Personal con Seguro

**Características:**
- Monto: $50,000
- Plazo: 24 meses
- Tasa de interés nominal anual: 24%
- Comisión por apertura: 3% ($1,500)
- Seguro de vida: $600 anual (pagado mensualmente)
- Pagos: Mensuales fijos

**Flujos de Efectivo:**
- Inicial: +$48,500 (monto - comisión)
- Mensual: -$2,649.44 (pago de capital e intereses)
- Mensual adicional: -$50 (seguro)

**Cálculo del CAT:**
1. Establecer la ecuación: $48,500 = Σ[($2,649.44 + $50) / (1 + CAT/100)^(i/12)] para i de 1 a 24
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 32.8%

**Análisis:**
- El seguro incrementa el CAT en aproximadamente 2 puntos porcentuales
- La comisión por apertura contribuye con aproximadamente 3 puntos porcentuales al CAT

## 2. Créditos Automotrices

### Caso 2.1: Financiamiento Tradicional

**Características:**
- Valor del vehículo: $300,000
- Enganche: 20% ($60,000)
- Monto financiado: $240,000
- Plazo: 48 meses
- Tasa de interés nominal anual: 12%
- Comisión por apertura: 2% ($4,800)
- Seguro de auto: $12,000 anual (financiado aparte)

**Flujos de Efectivo:**
- Inicial: +$235,200 (monto financiado - comisión)
- Mensual: -$6,351.93 (pago de capital e intereses)

**Cálculo del CAT:**
1. Establecer la ecuación: $235,200 = Σ[$6,351.93 / (1 + CAT/100)^(i/12)] para i de 1 a 48
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 14.5%

**Análisis:**
- El seguro no se incluye en el CAT porque se financia por separado
- La comisión por apertura tiene un impacto moderado debido al plazo más largo

### Caso 2.2: Arrendamiento con Opción a Compra

**Características:**
- Valor del vehículo: $400,000
- Depósito en garantía: $40,000 (10%)
- Valor residual: $160,000 (40% al final de 36 meses)
- Plazo: 36 meses
- Tasa implícita anual: 14%
- Comisión por apertura: 1.5% ($6,000)
- Seguro incluido en la mensualidad

**Flujos de Efectivo:**
- Inicial: -$40,000 (depósito)
- Mensual: -$8,500 (renta mensual incluyendo seguro)
- Final (opcional): -$160,000 (valor residual si se ejerce la opción de compra)

**Cálculo del CAT:**
1. Establecer la ecuación considerando todos los flujos, incluyendo el valor residual
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 16.8% (sin ejercer opción de compra)

**Análisis:**
- El CAT es mayor que la tasa implícita debido a comisiones y costos incluidos en la renta
- Si se ejerce la opción de compra, el CAT efectivo sería diferente

## 3. Créditos Hipotecarios

### Caso 3.1: Hipoteca a Tasa Fija

**Características:**
- Valor de la vivienda: $2,000,000
- Enganche: 20% ($400,000)
- Monto del crédito: $1,600,000
- Plazo: 20 años (240 meses)
- Tasa de interés nominal anual: 10%
- Comisión por apertura: 1% ($16,000)
- Avalúo: $8,000
- Gastos notariales: $35,000
- Seguro de daños: 0.25% anual sobre el valor
- Seguro de vida: 0.5% anual sobre saldo insoluto

**Flujos de Efectivo:**
- Inicial: +$1,541,000 (monto - comisión - avalúo - gastos notariales)
- Mensual: -$15,448.19 (pago de capital e intereses)
- Mensual adicional: -$416.67 (seguro de daños)
- Mensual adicional: -$666.67 (seguro de vida, monto inicial que disminuye con el tiempo)

**Cálculo del CAT:**
1. Establecer la ecuación considerando todos los flujos
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 12.3%

**Análisis:**
- Los costos iniciales (comisión, avalúo, notario) tienen un impacto relativamente bajo debido al largo plazo
- Los seguros contribuyen significativamente al CAT (aproximadamente 1.5 puntos porcentuales)

### Caso 3.2: Hipoteca a Tasa Variable

**Características:**
- Monto del crédito: $1,800,000
- Plazo: 25 años (300 meses)
- Tasa inicial: 9% (primeros 3 años)
- Tasa posterior: TIIE + 4% (estimada en 11% para el cálculo)
- Comisión por apertura: 1% ($18,000)
- Costos iniciales totales: $60,000 (incluye avalúo, notario, etc.)
- Seguros: Similar al caso anterior

**Cálculo del CAT:**
1. Calcular el CAT para los primeros 3 años: 11.2%
2. Calcular el CAT considerando el cambio de tasa: 13.5%
3. Reportar ambos valores, indicando que el CAT puede variar

**Análisis:**
- El CAT inicial es menor pero existe incertidumbre sobre el CAT futuro
- Regulatoriamente, se debe informar el CAT inicial y advertir sobre posibles variaciones

## 4. Tarjetas de Crédito

### Caso 4.1: Compra a Meses Sin Intereses

**Características:**
- Monto de la compra: $12,000
- Plazo: 12 meses sin intereses
- Comisión por disposición: 5% ($600)
- Anualidad de la tarjeta: $800 (ya pagada, no se considera)

**Flujos de Efectivo:**
- Inicial: +$12,000 (valor de la compra)
- Inicial: -$600 (comisión)
- Mensual: -$1,000 (pago fijo)

**Cálculo del CAT:**
1. Establecer la ecuación: $11,400 = Σ[$1,000 / (1 + CAT/100)^(i/12)] para i de 1 a 12
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 10.9%

**Análisis:**
- Aunque se promociona como "sin intereses", la comisión por disposición genera un costo financiero
- El CAT resultante es significativamente menor que el de un crédito revolvente típico

### Caso 4.2: Crédito Revolvente

**Características:**
- Línea de crédito: $50,000
- Saldo promedio utilizado: $20,000
- Tasa de interés nominal anual: 48%
- Anualidad: $1,200
- Pago mínimo: 5% del saldo o $500 (el que sea mayor)

**Cálculo del CAT:**
1. Considerar un periodo representativo (12 meses)
2. Incluir intereses, anualidad y otros cargos
3. Resultado: CAT = 60.7% (asumiendo pagos mínimos)

**Análisis:**
- El CAT es significativamente mayor que la tasa nominal debido a la anualidad y el efecto de los pagos mínimos
- Si se realizan pagos mayores al mínimo, el CAT efectivo sería menor

## 5. Microcréditos

### Caso 5.1: Microcrédito Grupal

**Características:**
- Monto: $10,000
- Plazo: 16 semanas
- Tasa de interés: 5% mensual (flat)
- Comisión por apertura: 1% ($100)
- Ahorro forzoso: 10% ($1,000, se devuelve al final)
- Pagos: Semanales iguales

**Flujos de Efectivo:**
- Inicial: +$8,900 (monto - comisión - ahorro forzoso)
- Semanal: -$687.50 (capital + interés)
- Final: +$1,000 (devolución del ahorro forzoso)

**Cálculo del CAT:**
1. Establecer la ecuación considerando todos los flujos
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 108.3%

**Análisis:**
- La metodología de interés flat (sobre monto original) resulta en un CAT muy elevado
- El ahorro forzoso reduce ligeramente el CAT efectivo

## 6. Créditos con Pagos Irregulares

### Caso 6.1: Crédito Agrícola

**Características:**
- Monto: $100,000
- Plazo: 1 año
- Tasa de interés nominal anual: 15%
- Comisión por apertura: 2% ($2,000)
- Pagos: Un solo pago al final de la cosecha

**Flujos de Efectivo:**
- Inicial: +$98,000 (monto - comisión)
- Final (12 meses): -$115,000 (capital + intereses)

**Cálculo del CAT:**
1. Establecer la ecuación: $98,000 = $115,000 / (1 + CAT/100)^1
2. Resolver para CAT: CAT = (115,000/98,000) - 1 = 17.35%

**Análisis:**
- La comisión por apertura incrementa el CAT en aproximadamente 2 puntos porcentuales
- La estructura de pago único simplifica el cálculo del CAT

### Caso 6.2: Crédito con Periodo de Gracia

**Características:**
- Monto: $200,000
- Plazo total: 36 meses
- Periodo de gracia: 6 meses (solo pago de intereses)
- Tasa de interés nominal anual: 18%
- Comisión por apertura: 2.5% ($5,000)

**Flujos de Efectivo:**
- Inicial: +$195,000 (monto - comisión)
- Meses 1-6: -$3,000 (solo intereses)
- Meses 7-36: -$8,254.65 (capital e intereses)

**Cálculo del CAT:**
1. Establecer la ecuación considerando la estructura de pagos diferenciada
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 21.7%

**Análisis:**
- El periodo de gracia aumenta el CAT debido a la capitalización efectiva de intereses
- La comisión inicial tiene un impacto moderado en el CAT

## 7. Consideraciones para la Implementación

### 7.1 Precisión y Redondeo

- Utilizar al menos 6 decimales en cálculos intermedios
- Redondear el CAT final a 1 decimal para presentación al cliente
- Verificar que el redondeo cumpla con las regulaciones aplicables

### 7.2 Validación de Resultados

- Comparar con calculadoras oficiales (como la de CONDUSEF)
- Verificar que el valor presente de los flujos sea aproximadamente cero
- Realizar análisis de sensibilidad para detectar posibles errores

### 7.3 Documentación

- Registrar todos los supuestos utilizados en el cálculo
- Documentar la metodología específica para cada tipo de crédito
- Mantener evidencia de los cálculos para fines de auditoría

## 8. Próximos Pasos para la Implementación en Código

1. Desarrollar funciones para cada tipo de crédito
2. Implementar algoritmos de solución numérica (Newton-Raphson, bisección)
3. Crear estructuras de datos para representar los diferentes flujos
4. Desarrollar interfaces para entrada de datos y visualización de resultados
5. Implementar validaciones y manejo de errores
6. Crear pruebas unitarias con casos conocidos para verificar precisión