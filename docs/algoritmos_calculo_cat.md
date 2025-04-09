# Algoritmos para el Cálculo del CAT

Este documento detalla los algoritmos y fórmulas matemáticas específicas para implementar el cálculo del CAT (Costo Anual Total) en diferentes escenarios financieros.

> **Nota**: Para los algoritmos específicos del cálculo del CAT en créditos revolventes (tarjetas de crédito), consulte el documento [Cálculo del CAT para Créditos Revolventes](./creditos_revolventes_cat.md).

## 1. Fundamentos Matemáticos

### 1.1 Ecuación Básica del CAT

La ecuación fundamental para el cálculo del CAT se basa en el concepto de valor presente neto (VPN) igualado a cero:

```
VPN = F₀ + Σ[Fᵢ / (1 + CAT)^(tᵢ)] = 0
```

Donde:
- F₀ es el flujo inicial (generalmente el monto del crédito con signo positivo menos comisiones con signo negativo)
- Fᵢ son los flujos posteriores (pagos, con signo negativo)
- tᵢ es el tiempo en años desde el inicio hasta el flujo i
- CAT es la tasa efectiva anual que estamos buscando (expresada en forma decimal)

### 1.2 Conversión a Tasa Anual

Si los pagos son periódicos con una frecuencia diferente a la anual, la fórmula se ajusta:

```
VPN = F₀ + Σ[Fᵢ / (1 + CAT)^(i/k)] = 0
```

Donde:
- k es el número de periodos por año (12 para pagos mensuales, 52 para semanales, etc.)
- i es el número del periodo

## 2. Métodos Numéricos para Resolver la Ecuación

La ecuación del CAT generalmente no puede resolverse de forma analítica, por lo que se utilizan métodos numéricos.

### 2.1 Método de Bisección

**Algoritmo:**

1. Definir un intervalo inicial [a, b] donde f(a) y f(b) tienen signos opuestos
   - f(x) es la función VPN evaluada con CAT = x
   - Típicamente, a = 0 y b = 2 (o 200% como CAT)
2. Calcular el punto medio c = (a + b) / 2
3. Evaluar f(c)
4. Si |f(c)| < ε (tolerancia) o (b - a) < δ (precisión requerida), terminar y devolver c como el CAT
5. Si f(c) tiene el mismo signo que f(a), actualizar a = c; de lo contrario, actualizar b = c
6. Volver al paso 2

**Ventajas:**
- Simple de implementar
- Garantiza convergencia si existe solución en el intervalo inicial

**Desventajas:**
- Convergencia relativamente lenta
- Requiere un intervalo inicial adecuado

### 2.2 Método de Newton-Raphson

**Algoritmo:**

1. Elegir un valor inicial x₀ (típicamente la tasa de interés nominal)
2. Calcular la siguiente aproximación: xₙ₊₁ = xₙ - f(xₙ) / f'(xₙ)
   - f(x) es la función VPN evaluada con CAT = x
   - f'(x) es la derivada de f(x) respecto a x
3. Si |xₙ₊₁ - xₙ| < ε o |f(xₙ₊₁)| < δ, terminar y devolver xₙ₊₁ como el CAT
4. De lo contrario, actualizar xₙ = xₙ₊₁ y volver al paso 2

**Derivada Analítica:**

La derivada de la función VPN respecto al CAT es:

```
f'(CAT) = -Σ[tᵢ × Fᵢ / (1 + CAT)^(tᵢ+1)]
```

**Ventajas:**
- Convergencia cuadrática (muy rápida cerca de la solución)
- Menor número de iteraciones que la bisección

**Desventajas:**
- Requiere el cálculo de la derivada
- Puede diverger si el valor inicial está lejos de la solución

### 2.3 Método de la Secante

**Algoritmo:**

1. Elegir dos valores iniciales x₀ y x₁ (cercanos a la solución esperada)
2. Calcular la siguiente aproximación: xₙ₊₁ = xₙ - f(xₙ) × (xₙ - xₙ₋₁) / (f(xₙ) - f(xₙ₋₁))
3. Si |xₙ₊₁ - xₙ| < ε o |f(xₙ₊₁)| < δ, terminar y devolver xₙ₊₁ como el CAT
4. De lo contrario, actualizar xₙ₋₁ = xₙ, xₙ = xₙ₊₁ y volver al paso 2

**Ventajas:**
- No requiere el cálculo de la derivada
- Convergencia superlineal (más rápida que la bisección)

**Desventajas:**
- Menos robusta que la bisección
- Requiere dos valores iniciales

## 3. Implementación para Diferentes Tipos de Crédito

### 3.1 Crédito con Pagos Iguales

**Algoritmo:**

1. Calcular el pago periódico usando la fórmula de anualidad:
   ```
   Pago = Monto × [r × (1 + r)^n] / [(1 + r)^n - 1]
   ```
   Donde:
   - r es la tasa de interés por periodo
   - n es el número total de periodos

2. Construir el flujo de efectivo:
   - F₀ = Monto - Comisiones iniciales
   - Fᵢ = -Pago - Comisiones periódicas (para i de 1 a n)

3. Aplicar uno de los métodos numéricos para encontrar el CAT

### 3.2 Crédito con Pagos Irregulares

**Algoritmo:**

1. Definir cada flujo de efectivo Fᵢ y su tiempo correspondiente tᵢ
2. Aplicar uno de los métodos numéricos para encontrar el CAT

### 3.3 Crédito con Tasa Variable

**Algoritmo:**

1. Calcular el CAT para el periodo inicial con tasa conocida
2. Para proyecciones futuras:
   - Utilizar escenarios (mejor caso, caso esperado, peor caso)
   - Calcular el CAT para cada escenario
   - Reportar el rango de posibles valores del CAT

## 4. Pseudocódigo para la Implementación

### 4.1 Función Principal para Calcular el CAT

```
función calcularCAT(flujos, tiempos, estimacionInicial, tolerancia):
    // flujos: array de flujos de efectivo (F₀, F₁, ..., Fₙ)
    // tiempos: array de tiempos en años (0, t₁, ..., tₙ)
    // estimacionInicial: valor inicial para el CAT
    // tolerancia: precisión requerida
    
    // Método de Newton-Raphson
    cat = estimacionInicial
    maxIteraciones = 100
    iteracion = 0
    
    mientras (iteracion < maxIteraciones):
        vpn = calcularVPN(flujos, tiempos, cat)
        derivada = calcularDerivadaVPN(flujos, tiempos, cat)
        
        si (abs(derivada) < 1e-10):
            // Evitar división por cero
            retornar null  // No se encontró solución
        
        nuevoCAT = cat - vpn / derivada
        
        si (abs(nuevoCAT - cat) < tolerancia):
            retornar nuevoCAT
        
        cat = nuevoCAT
        iteracion = iteracion + 1
    
    // Si llegamos aquí, no hubo convergencia
    retornar null

función calcularVPN(flujos, tiempos, cat):
    vpn = 0
    para i desde 0 hasta longitud(flujos)-1:
        vpn = vpn + flujos[i] / pow(1 + cat, tiempos[i])
    retornar vpn

función calcularDerivadaVPN(flujos, tiempos, cat):
    derivada = 0
    para i desde 1 hasta longitud(flujos)-1:  // Empezar desde 1 para omitir F₀
        derivada = derivada - tiempos[i] * flujos[i] / pow(1 + cat, tiempos[i] + 1)
    retornar derivada
```

### 4.2 Función para Crédito con Pagos Iguales

```
función calcularCATConPagosIguales(monto, comisionInicial, pagoMensual, comisionMensual, plazoMeses):
    // Construir arrays de flujos y tiempos
    flujos = [monto - comisionInicial]
    tiempos = [0]
    
    para i desde 1 hasta plazoMeses:
        flujos.agregar(-(pagoMensual + comisionMensual))
        tiempos.agregar(i / 12)  // Convertir meses a años
    
    // Estimar CAT inicial (usar tasa nominal como aproximación)
    tasaNominalMensual = pagoMensual / monto  // Simplificación
    estimacionInicial = tasaNominalMensual * 12
    
    // Calcular CAT
    cat = calcularCAT(flujos, tiempos, estimacionInicial, 0.0000001)
    
    // Convertir a porcentaje con 1 decimal
    retornar redondear(cat * 100, 1)
```

### 4.3 Función para Crédito Hipotecario

```
función calcularCATHipotecario(monto, comisionInicial, otrosCostosIniciales, 
                             pagoMensual, seguroDaños, seguroVida, 
                             plazoMeses):
    // Flujo inicial
    flujoInicial = monto - comisionInicial - otrosCostosIniciales
    flujos = [flujoInicial]
    tiempos = [0]
    
    // Pagos mensuales (capital, intereses y seguros)
    para i desde 1 hasta plazoMeses:
        // El seguro de vida disminuye con el tiempo (simplificación)
        factorSeguroVida = 1 - (i / plazoMeses) * 0.5
        seguroVidaActual = seguroVida * factorSeguroVida
        
        flujoMensual = -(pagoMensual + seguroDaños + seguroVidaActual)
        flujos.agregar(flujoMensual)
        tiempos.agregar(i / 12)  // Convertir meses a años
    
    // Estimar CAT inicial
    estimacionInicial = 0.10  // 10% como punto de partida
    
    // Calcular CAT
    cat = calcularCAT(flujos, tiempos, estimacionInicial, 0.0000001)
    
    // Convertir a porcentaje con 1 decimal
    retornar redondear(cat * 100, 1)
```

## 5. Optimizaciones y Consideraciones Prácticas

### 5.1 Manejo de Errores

- Verificar que exista al menos un flujo positivo y uno negativo
- Establecer límites para el número de iteraciones
- Implementar detección de divergencia
- Manejar casos especiales (como préstamos sin interés)

### 5.2 Optimización de Rendimiento

- Utilizar técnicas de memorización para evitar recálculos
- Implementar cálculos incrementales para la función VPN
- Utilizar aproximaciones iniciales inteligentes basadas en la tasa nominal

### 5.3 Precisión Numérica

- Utilizar aritmética de doble precisión para todos los cálculos
- Implementar técnicas de suma compensada para evitar errores de redondeo
- Validar resultados con casos de prueba conocidos

## 6. Validación y Pruebas

### 6.1 Casos de Prueba

1. **Caso Simple**: Préstamo sin comisiones ni cargos adicionales
   - El CAT debe ser igual a la tasa de interés efectiva anual

2. **Caso con Comisión Inicial**: Préstamo con comisión por apertura
   - Verificar el incremento en el CAT debido a la comisión

3. **Caso Extremo**: Microcrédito con alta tasa y corto plazo
   - Validar que el algoritmo converja incluso con CAT muy alto

4. **Caso Complejo**: Hipoteca con múltiples componentes
   - Comparar con calculadoras oficiales o regulatorias

### 6.2 Metodología de Validación

1. Calcular manualmente el VPN con el CAT obtenido
   - Debe ser aproximadamente cero

2. Comparar con resultados de calculadoras oficiales
   - La diferencia no debe exceder 0.1 puntos porcentuales

3. Realizar análisis de sensibilidad
   - Pequeños cambios en los flujos deben resultar en cambios proporcionales en el CAT

## 7. Implementación en Diferentes Lenguajes

### 7.1 Consideraciones para JavaScript

- Utilizar la biblioteca `math.js` para cálculos de alta precisión
- Implementar funciones asíncronas para cálculos complejos
- Considerar Web Workers para cálculos intensivos

### 7.2 Consideraciones para Python

- Utilizar NumPy para operaciones vectoriales eficientes
- Aprovechar SciPy para métodos numéricos optimizados
- Implementar paralelismo para múltiples escenarios

### 7.3 Consideraciones para Java/C#

- Utilizar tipos BigDecimal para alta precisión
- Implementar interfaces para diferentes estrategias de cálculo
- Considerar multithreading para cálculos complejos

## 8. Próximos Pasos

1. Implementar las funciones básicas en el lenguaje seleccionado
2. Desarrollar pruebas unitarias para cada tipo de crédito
3. Crear una interfaz para entrada de datos y visualización de resultados
4. Implementar validaciones y manejo de errores
5. Optimizar el rendimiento para cálculos complejos
6. Documentar la API y crear ejemplos de uso