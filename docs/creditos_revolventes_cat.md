# Cálculo del CAT para Créditos Revolventes

Este documento detalla la metodología específica para calcular el Costo Anual Total (CAT) en créditos revolventes, incluyendo tarjetas de crédito, según lo establecido en la Circular 9/2015 del Banco de México.

## 1. Definición de Crédito Revolvente

Según la Circular 9/2015, un Crédito Revolvente se define como:

> "El Crédito que da derecho al Cliente, en su carácter de acreditado, a disponer de montos correspondientes a una línea de crédito pactada, así como a realizar pagos, parciales o totales, de las disposiciones que previamente hubiere hecho, quedando facultado, mientras el Contrato no concluya, para disponer en la forma pactada del saldo que resulte a su favor."

Ejemplos típicos incluyen:
- Tarjetas de crédito
- Líneas de crédito personales revolventes
- Líneas de sobregiro

## 2. Metodología de Cálculo según Circular 9/2015

### 2.1 Supuestos Específicos

Para el cálculo del CAT en créditos revolventes, se deben aplicar los siguientes supuestos específicos:

1. **Comportamiento del Cliente**:
   - Dispone del monto total de la línea de crédito al inicio de la vigencia
   - Cubre en cada periodo únicamente el Pago Mínimo
   - Dispone de la parte del monto de la línea de crédito que resulte inmediatamente después de cada pago del período

2. **Generación de Flujos**:
   - Los intereses, el Pago Mínimo y las nuevas disposiciones se generan o realizan al final del período al que correspondan
   - El Pago Mínimo y los intereses son constantes para todos los períodos

3. **Comisiones**:
   - El monto de la Comisión anual que se cobra al final del primer periodo de cada año se mantiene constante durante un plazo de 3 años

4. **Exclusiones**:
   - Se deben excluir los descuentos, bonificaciones o cualquier otra cantidad que el Cliente tenga derecho a recibir en caso de cumplir con las condiciones de pago establecidas en el Contrato

### 2.2 Plazo Estandarizado

Independientemente del plazo de vencimiento del Crédito Revolvente o su renovación automática, se debe aplicar al cálculo del CAT un plazo de 36 meses de 30 días cada uno, asumiendo que el saldo insoluto se amortiza al finalizar el último período del tercer año.

### 2.3 Montos Estandarizados para Publicidad

Para el cálculo del CAT que se utilizará en publicidad y propaganda, se deben utilizar los siguientes montos de línea de crédito, expresados en UDIS:

| Tipo de Tarjeta/Crédito | Monto en UDIS |
|-------------------------|---------------|
| Clásica o equivalente   | 3,000 UDIS    |
| Oro o equivalente       | 7,000 UDIS    |
| Platino o equivalente   | 13,000 UDIS   |

Estos montos deben actualizarse a partir del primer día hábil bancario de enero de cada año, con base en el valor de la UDI del 31 de diciembre del año anterior.

## 3. Fórmula y Componentes

### 3.1 Ecuación Básica

La ecuación fundamental para el cálculo del CAT se mantiene igual que para otros tipos de crédito:

```
VPN = F₀ + Σ[Fᵢ / (1 + CAT)^(tᵢ)] = 0
```

Donde:
- F₀ es el flujo inicial (desde la perspectiva de la institución financiera, la disposición total de la línea de crédito con signo negativo)
- Fᵢ son los flujos posteriores (desde la perspectiva de la institución financiera, los pagos mínimos y comisiones recibidos con signo positivo, y las nuevas disposiciones otorgadas con signo negativo)
- tᵢ es el tiempo en años desde el inicio hasta el flujo i
- CAT es la tasa efectiva anual que estamos buscando (expresada en forma decimal)

> **Nota importante sobre los signos**: La convención de signos debe reflejar la perspectiva de la institución financiera que otorga el crédito. Esto significa que los desembolsos (dinero que sale de la institución) deben tener signo negativo, mientras que los ingresos (dinero que entra a la institución) deben tener signo positivo.

### 3.2 Flujos Específicos para Créditos Revolventes

1. **Flujo Inicial (F₀)**:
   - Disposición total de la línea de crédito (valor negativo desde la perspectiva de la institución financiera)

2. **Flujos Posteriores (Fᵢ)**:
   - **Pagos Mínimos**: Valor positivo desde la perspectiva de la institución financiera, calculado según las políticas de la entidad (generalmente un porcentaje del saldo)
   - **Comisión Anual**: Valor positivo desde la perspectiva de la institución financiera, aplicado al final del primer periodo de cada año
   - **Nuevas Disposiciones**: Valor negativo desde la perspectiva de la institución financiera, equivalente a la parte del pago mínimo que amortiza capital (no intereses)
   - **Pago Final**: Valor positivo desde la perspectiva de la institución financiera, incluye la liquidación del saldo restante al final del mes 36

## 4. Implementación Práctica

### 4.1 Algoritmo General

1. Establecer el monto de la línea de crédito según el tipo de tarjeta/crédito
2. Registrar la disposición inicial por el monto total de la línea
3. Para cada uno de los 36 meses:
   - Calcular intereses del periodo (saldo × tasa mensual)
   - Calcular pago mínimo según políticas de la entidad
   - Aplicar comisión anual si corresponde (meses 12, 24 y 36)
   - Actualizar saldo (saldo anterior + intereses - pago mínimo)
   - Calcular nueva disposición (pago mínimo - intereses, si es positivo)
   - Actualizar saldo con nueva disposición
   - En el mes 36, agregar la amortización total del saldo restante
4. Resolver la ecuación para encontrar el CAT

### 4.2 Consideraciones Especiales

- **Pago Mínimo**: Debe calcularse conforme a las disposiciones aplicables (Circular 34/2010 o Circular 13/2011 del Banco de México)
- **Tasa de Interés**: Se debe utilizar la tasa aplicable al producto específico
- **Valor de la UDI**: Debe actualizarse según las publicaciones oficiales del Banco de México

## 5. Ejemplos Prácticos

### 5.1 Tarjeta de Crédito Clásica

**Parámetros**:
- Línea de crédito: 3,000 UDIS (aproximadamente $22,500 con UDI = $7.50)
- Tasa de interés: 36% anual
- Comisión anual: $700
- Pago mínimo: 5% del saldo

**Resultado**: CAT = 65.8%

### 5.2 Tarjeta de Crédito Oro

**Parámetros**:
- Línea de crédito: 7,000 UDIS (aproximadamente $52,500 con UDI = $7.50)
- Tasa de interés: 30% anual
- Comisión anual: $1,200
- Pago mínimo: 8% del saldo

**Resultado**: CAT = 45.2%

### 5.3 Tarjeta de Crédito Platino

**Parámetros**:
- Línea de crédito: 13,000 UDIS (aproximadamente $97,500 con UDI = $7.50)
- Tasa de interés: 25% anual
- Comisión anual: $2,000
- Pago mínimo: 10% del saldo

**Resultado**: CAT = 32.7%

## 6. Diferencias con la Metodología Anterior

La Circular 9/2015 introduce cambios significativos en la metodología de cálculo del CAT para créditos revolventes:

1. **Definición Formal**: Se incluye una definición específica de Crédito Revolvente y Pago Mínimo
2. **Supuestos Estandarizados**: Se establecen supuestos específicos sobre el comportamiento del cliente
3. **Plazo Fijo**: Se establece un plazo fijo de 36 meses para todos los créditos revolventes
4. **Montos en UDIS**: Los montos de línea de crédito ahora se expresan en UDIS y deben actualizarse anualmente
5. **Exclusión de Bonificaciones**: Se excluyen del cálculo los descuentos y bonificaciones

Estos cambios buscan mejorar la comparabilidad entre productos y proporcionar información más precisa a los consumidores sobre el costo real de los créditos revolventes.