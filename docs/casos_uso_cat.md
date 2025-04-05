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
- La comisión inicial tiene un impacto menor en préstamos de mayor plazo

## 2. Créditos Automotrices

### Caso 2.1: Crédito Automotriz Estándar

**Características:**
- Precio del vehículo: $300,000
- Enganche: 20% ($60,000)
- Monto a financiar: $240,000
- Plazo: 48 meses
- Tasa de interés nominal anual: 12%
- Comisión por apertura: 2% ($4,800)
- Seguro de auto: $12,000 anual (pagado anualmente)
- Pagos: Mensuales fijos

**Flujos de Efectivo:**
- Inicial: +$235,200 (monto - comisión)
- Mensual: -$6,351.93 (pago de capital e intereses)
- Anual: -$12,000 (seguro, en meses 12, 24, 36 y 48)

**Cálculo del CAT:**
1. Establecer la ecuación con todos los flujos
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 18.7%

**Análisis:**
- El seguro representa una parte significativa del costo total
- El CAT es considerablemente mayor que la tasa nominal debido a comisiones y seguros

### Caso 2.2: Crédito Automotriz con Valor Residual

**Características:**
- Precio del vehículo: $400,000
- Enganche: 15% ($60,000)
- Monto a financiar: $340,000
- Plazo: 36 meses
- Valor residual: 30% ($120,000, pago global al final)
- Tasa de interés nominal anual: 10%
- Comisión por apertura: 2% ($6,800)
- Seguro de auto: $15,000 anual (pagado anualmente)

**Flujos de Efectivo:**
- Inicial: +$333,200 (monto - comisión)
- Mensual: -$7,212.65 (pago de capital e intereses, excluyendo valor residual)
- Anual: -$15,000 (seguro, en meses 12, 24 y 36)
- Final: -$120,000 (valor residual, en mes 36)

**Cálculo del CAT:**
1. Establecer la ecuación con todos los flujos, incluyendo el pago final
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 16.4%

**Análisis:**
- El valor residual reduce los pagos mensuales pero genera un pago final significativo
- El CAT es menor que en un crédito tradicional debido al diferimiento de parte del capital

## 3. Créditos Hipotecarios

### Caso 3.1: Hipoteca a Tasa Fija

**Características:**
- Valor del inmueble: $2,000,000
- Enganche: 20% ($400,000)
- Monto a financiar: $1,600,000
- Plazo: 20 años (240 meses)
- Tasa de interés nominal anual: 10%
- Comisión por apertura: 1% ($16,000)
- Avalúo: $8,000
- Gastos notariales: $30,000
- Seguro de daños: $4,000 anual
- Seguro de vida: $6,000 anual (decreciente)

**Flujos de Efectivo:**
- Inicial: +$1,546,000 (monto - comisión - avalúo - gastos notariales)
- Mensual: -$15,448.78 (pago de capital e intereses)
- Mensual adicional: -$333.33 (seguro de daños, prorrateado)
- Mensual adicional: -$500 (seguro de vida inicial, prorrateado y decreciente)

**Cálculo del CAT:**
1. Establecer la ecuación considerando la disminución gradual del seguro de vida
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 11.8%

**Análisis:**
- Los gastos iniciales tienen un impacto relativamente bajo debido al largo plazo
- Los seguros incrementan el CAT en aproximadamente 1 punto porcentual

### Caso 3.2: Hipoteca a Tasa Variable

**Características:**
- Valor del inmueble: $3,000,000
- Enganche: 30% ($900,000)
- Monto a financiar: $2,100,000
- Plazo: 15 años (180 meses)
- Tasa de interés inicial: 8% (primeros 3 años)
- Tasa de interés posterior: TIIE + 4% (estimada en 12%)
- Comisión por apertura: 1% ($21,000)
- Avalúo: $10,000
- Gastos notariales: $40,000
- Seguros: Similar al caso anterior

**Flujos de Efectivo:**
- Complejos debido al cambio de tasa

**Cálculo del CAT:**
1. Calcular CAT para los primeros 3 años: 9.5%
2. Calcular CAT considerando el cambio de tasa (escenario esperado): 13.2%
3. Presentar rango: CAT inicial 9.5%, CAT esperado a largo plazo 13.2%

**Análisis:**
- La tasa promocional inicial reduce significativamente el CAT de corto plazo
- Es crucial presentar escenarios para que el cliente comprenda el impacto del cambio de tasa

## 4. Tarjetas de Crédito

### Caso 4.1: Tarjeta Clásica

**Características:**
- Línea de crédito: $50,000
- Saldo para cálculo: $20,000
- Tasa de interés nominal anual: 45%
- Anualidad: $800
- Comisión por disposición de efectivo: 5%
- Pago mínimo: 5% del saldo

**Escenario para Cálculo del CAT:**
- Disposición inicial: $20,000
- Pagos: Solo el mínimo requerido
- Plazo de referencia: 12 meses

**Flujos de Efectivo:**
- Inicial: +$20,000
- Mensual: Variable (pago mínimo decreciente)
- Anualidad: -$800 (al inicio)

**Cálculo del CAT:**
1. Simular la evolución del saldo con pagos mínimos
2. Establecer la ecuación con los flujos resultantes
3. Resultado: CAT = 61.8%

**Análisis:**
- El CAT es significativamente mayor que la tasa nominal debido a la anualidad
- El esquema de pagos mínimos extiende considerablemente el plazo real de pago

### Caso 4.2: Tarjeta Premium

**Características:**
- Línea de crédito: $200,000
- Saldo para cálculo: $50,000
- Tasa de interés nominal anual: 36%
- Anualidad: $3,000
- Comisiones adicionales: Diversas
- Beneficios: Puntos, seguros, acceso a salas VIP

**Escenario para Cálculo del CAT:**
- Disposición inicial: $50,000
- Pagos: 10% del saldo mensual
- Plazo de referencia: 12 meses

**Flujos de Efectivo:**
- Inicial: +$50,000 - $3,000 (anualidad)
- Mensual: Variable (10% del saldo)

**Cálculo del CAT:**
1. Simular la evolución del saldo con los pagos establecidos
2. Establecer la ecuación con los flujos resultantes
3. Resultado: CAT = 45.2%

**Análisis:**
- La anualidad alta impacta significativamente el CAT
- El valor de los beneficios no se refleja en el CAT

## 5. Microcréditos

### Caso 5.1: Microcrédito Grupal

**Características:**
- Monto: $5,000
- Plazo: 16 semanas
- Tasa de interés nominal: 5% mensual (60% anual)
- Comisión por apertura: 5% ($250)
- Pagos: Semanales iguales

**Flujos de Efectivo:**
- Inicial: +$4,750 (monto - comisión)
- Semanal: -$343.75 (calculado con función de pago)

**Cálculo del CAT:**
1. Establecer la ecuación: $4,750 = Σ[$343.75 / (1 + CAT/100)^(i/52)] para i de 1 a 16
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 94.7%

**Análisis:**
- El CAT es extremadamente alto debido a la combinación de tasa alta y plazo corto
- La frecuencia semanal de pagos incrementa significativamente el CAT

### Caso 5.2: Microcrédito Individual

**Características:**
- Monto: $10,000
- Plazo: 6 meses (24 semanas)
- Tasa de interés nominal: 4% mensual (48% anual)
- Comisión por apertura: 3% ($300)
- Pagos: Semanales iguales

**Flujos de Efectivo:**
- Inicial: +$9,700 (monto - comisión)
- Semanal: -$455.83 (calculado con función de pago)

**Cálculo del CAT:**
1. Establecer la ecuación con los flujos semanales
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 65.3%

**Análisis:**
- El CAT es menor que en el caso grupal debido a la menor tasa y mayor plazo
- Sigue siendo muy alto comparado con productos financieros tradicionales

## 6. Créditos con Pagos Irregulares

### Caso 6.1: Crédito Agrícola

**Características:**
- Monto: $100,000
- Plazo: 1 año
- Tasa de interés nominal anual: 15%
- Comisión por apertura: 2% ($2,000)
- Pagos: Irregular, adaptado al ciclo de cosecha

**Flujos de Efectivo:**
- Inicial: +$98,000 (monto - comisión)
- Mes 3: -$5,000 (pago parcial)
- Mes 6: -$10,000 (pago parcial)
- Mes 9: -$15,000 (pago parcial)
- Mes 12: -$85,000 (pago final, incluye capital restante e intereses)

**Cálculo del CAT:**
1. Establecer la ecuación con los flujos irregulares
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 19.8%

**Análisis:**
- El CAT es mayor que la tasa nominal debido a la comisión y la estructura de pagos
- La concentración de pagos hacia el final incrementa el costo efectivo

### Caso 6.2: Crédito para Negocio Estacional

**Características:**
- Monto: $200,000
- Plazo: 18 meses
- Tasa de interés nominal anual: 18%
- Comisión por apertura: 2.5% ($5,000)
- Pagos: Variables según temporada alta/baja

**Flujos de Efectivo:**
- Inicial: +$195,000 (monto - comisión)
- Meses de temporada baja (1-3, 7-9, 13-15): -$5,000 por mes
- Meses de temporada alta (4-6, 10-12, 16-18): -$25,000 por mes

**Cálculo del CAT:**
1. Establecer la ecuación con los flujos variables
2. Resolver para CAT mediante iteración
3. Resultado: CAT = 22.3%

**Análisis:**
- La estructura de pagos adaptada al flujo de ingresos del negocio
- El CAT refleja tanto el costo financiero como la flexibilidad de pagos