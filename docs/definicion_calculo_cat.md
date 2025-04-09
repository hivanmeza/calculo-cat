# Definición del Cálculo del CAT (Costo Anual Total)

Este documento define la metodología para calcular el CAT en diferentes escenarios financieros, estableciendo las bases conceptuales antes de la implementación en código.

## 1. Componentes Principales del CAT

### 1.1 Tipos de Pago

> **Nota importante sobre los signos**: La convención de signos debe reflejar la perspectiva de la institución financiera que otorga el crédito. Esto significa que los desembolsos (dinero que sale de la institución) deben tener signo negativo, mientras que los ingresos (dinero que entra a la institución) deben tener signo positivo.

#### Pago Único
- **Descripción**: Un solo pago al final del plazo del crédito.
- **Consideraciones**: El monto total incluye capital e intereses acumulados.
- **Fórmula Base**: 
  ```
  CAT = ((Monto Total / Monto del Crédito)^(1/Plazo en años) - 1) × 100
  ```

#### Pagos Periódicos Regulares
- **Descripción**: Pagos iguales a intervalos regulares (semanal, quincenal, mensual, etc.).
- **Consideraciones**: Amortización gradual del capital más intereses.
- **Fórmula Base**: Se utiliza la ecuación de valor presente de una anualidad:
  ```
  0 = -Monto del Crédito + Σ[Pago_i / (1 + CAT/100)^(i/Periodos por año)]
  ```
  Donde i va desde 1 hasta el número total de pagos.

#### Pagos Irregulares
- **Descripción**: Pagos de diferentes montos o en intervalos variables.
- **Consideraciones**: Requiere un análisis de flujo de efectivo detallado.
- **Fórmula Base**: Se utiliza la ecuación general de valor presente:
  ```
  0 = -Monto del Crédito + Σ[Pago_i / (1 + CAT/100)^(t_i)]
  ```
  Donde t_i es el tiempo en años desde el inicio hasta el pago i.

### 1.2 Plazos

#### Corto Plazo (hasta 1 año)
- **Consideraciones Especiales**: 
  - Mayor impacto de las comisiones iniciales
  - Menor efecto de la capitalización de intereses
  - Posible uso de tasa simple en lugar de compuesta

#### Mediano Plazo (1-5 años)
- **Consideraciones Especiales**:
  - Balance entre comisiones iniciales y costo financiero
  - Importante considerar la periodicidad de pagos

#### Largo Plazo (más de 5 años)
- **Consideraciones Especiales**:
  - Mayor efecto de la capitalización de intereses
  - Impacto significativo de pequeñas variaciones en la tasa
  - Relevancia de las condiciones de prepago

### 1.3 Comisiones y Cargos

#### Comisiones Iniciales
- **Tipos Comunes**:
  - Comisión por apertura
  - Gastos de investigación
  - Avalúos (en créditos hipotecarios)
  - Gastos notariales
- **Impacto en el CAT**: Alto, especialmente en créditos de corto plazo

#### Comisiones Periódicas
- **Tipos Comunes**:
  - Comisión por administración
  - Comisión por disposición
  - Comisión por anualidad
- **Impacto en el CAT**: Moderado, depende de la frecuencia y monto

#### Seguros y Garantías
- **Tipos Comunes**:
  - Seguro de vida
  - Seguro de daños
  - Seguro de desempleo
  - Comisiones por garantía extendida
- **Impacto en el CAT**: Variable, puede ser significativo en créditos de largo plazo

### 1.4 Tipos de Interés

#### Tasa Fija
- **Descripción**: La tasa de interés permanece constante durante toda la vida del crédito
- **Consideraciones para el CAT**: 
  - Cálculo directo y predecible
  - El CAT también permanece constante

#### Tasa Variable
- **Descripción**: La tasa de interés cambia según un índice de referencia
- **Consideraciones para el CAT**:
  - Se calcula con la tasa inicial
  - Debe incluirse un escenario de comportamiento futuro
  - Posible presentación de rangos de CAT

#### Tasa Mixta
- **Descripción**: Combinación de periodos con tasa fija y periodos con tasa variable
- **Consideraciones para el CAT**:
  - Cálculo por tramos
  - Presentación de CAT para el periodo inicial y escenarios futuros

## 2. Metodología de Cálculo

> **Nota**: Para la metodología específica del cálculo del CAT en créditos revolventes (tarjetas de crédito), consulte el documento [Cálculo del CAT para Créditos Revolventes](./creditos_revolventes_cat.md).
### 2.1 Enfoque General

1. **Identificar todos los flujos de efectivo**:
   - Desembolso inicial (monto del crédito menos comisiones iniciales)
   - Pagos periódicos (incluyendo amortización, intereses y comisiones)
   - Pagos finales o globales

2. **Establecer la ecuación de valor presente**:
   - Igualar el valor presente de todos los flujos a cero
   - Utilizar el CAT como la tasa de descuento

3. **Resolver para el CAT**:
   - Utilizar métodos numéricos (Newton-Raphson, bisección, etc.)
   - Iterar hasta alcanzar la precisión requerida

### 2.2 Algoritmo Básico

1. Inicializar con una estimación del CAT (por ejemplo, la tasa de interés nominal)
2. Calcular el valor presente neto (VPN) de todos los flujos usando esta estimación
3. Si el VPN está suficientemente cerca de cero, terminar
4. De lo contrario, ajustar la estimación del CAT y volver al paso 2

### 2.3 Consideraciones Especiales

#### Periodicidad de Pagos
- Convertir el CAT a la periodicidad correspondiente para cálculos intermedios
- Anualizar el resultado final

#### Redondeo
- Aplicar reglas de redondeo según normativas (típicamente a un decimal)
- Mantener precisión en cálculos intermedios

#### Días Exactos vs. Periodos
- Considerar el uso de días exactos para mayor precisión
- Ajustar fórmulas para reflejar fechas reales de pago

## 3. Aplicación a Diferentes Tipos de Crédito

### 3.1 Créditos Personales

#### Características Típicas
- Plazo: 12-60 meses
- Pagos: Mensuales fijos
- Comisiones: Por apertura (1-5%)

#### Consideraciones para el CAT
- Impacto significativo de la comisión por apertura
- Posibles seguros opcionales u obligatorios
- Generalmente estructura simple de flujos

### 3.2 Créditos Automotrices

#### Características Típicas
- Plazo: 12-60 meses
- Pagos: Mensuales fijos
- Comisiones: Por apertura (1-3%)
- Seguros: De daños, de vida (obligatorios)

#### Consideraciones para el CAT
- Incluir costo de seguros obligatorios
- Considerar valor del enganche
- Posible valor residual (en arrendamientos)

### 3.3 Créditos Hipotecarios

#### Características Típicas
- Plazo: 5-30 años
- Pagos: Mensuales (fijos o variables)
- Comisiones: Por apertura, avalúo, notariales
- Seguros: De daños, de vida, de desempleo

#### Consideraciones para el CAT
- Incluir todos los gastos iniciales (incluso los pagados a terceros)
- Tratamiento especial para tasas promocionales
- Escenarios para tasas variables
- Impacto de los seguros a lo largo del plazo

### 3.4 Tarjetas de Crédito

#### Características Típicas
- Plazo: Indefinido (revolving)
- Pagos: Mensuales variables (pago mínimo o mayor)
- Comisiones: Anualidad, disposición de efectivo

#### Consideraciones para el CAT
- Calcular con base en un ejemplo representativo
- Asumir un saldo y plazo específico
- Incluir anualidad prorrateada
- Considerar diferentes patrones de pago

### 3.5 Microcréditos

#### Características Típicas
- Plazo: 4-24 semanas
- Pagos: Semanales o quincenales
- Comisiones: Por apertura (altas)

#### Consideraciones para el CAT
- Valores típicamente muy altos
- Impacto crucial de la frecuencia de pagos
- Efecto significativo de comisiones iniciales

## 4. Retos y Limitaciones

### 4.1 Créditos con Condiciones Variables
- Tasas de interés que cambian según comportamiento de pago
- Comisiones condicionales
- Solución: Presentar escenarios múltiples

### 4.2 Productos Complejos
- Líneas de crédito con diferentes subusos
- Productos híbridos
- Solución: Desglosar por componentes

### 4.3 Comparabilidad
- Diferentes estructuras de comisiones
- Diferentes periodicidades
- Solución: Estandarización metodológica

## 5. Mejores Prácticas

### 5.1 Transparencia
- Desglosar todos los componentes incluidos en el cálculo
- Explicar supuestos utilizados
- Presentar ejemplos representativos

### 5.2 Precisión
- Utilizar suficientes decimales en cálculos intermedios
- Verificar resultados con casos de prueba
- Documentar el método numérico utilizado

### 5.3 Cumplimiento Regulatorio
- Seguir las disposiciones específicas de cada jurisdicción
- Actualizar cálculos según cambios normativos
- Mantener registros de la metodología aplicada