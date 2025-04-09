# Actualización de la Metodología del CAT según Circular 9/2015

Este documento resume los cambios principales introducidos por la Circular 9/2015 del Banco de México, que modifica las "Disposiciones de carácter general que establecen la metodología de cálculo, fórmula, componentes y supuestos del Costo Anual Total (CAT)" contenidas en la Circular 21/2009.

## Fecha de Publicación y Entrada en Vigor

- **Fecha de publicación en el DOF**: 27 de abril de 2015
- **Entrada en vigor**: 26 de octubre de 2015

## 1. Nuevas Definiciones

### 1.1 Crédito Revolvente

Se define como "el Crédito que da derecho al Cliente, en su carácter de acreditado, a disponer de montos correspondientes a una línea de crédito pactada, así como a realizar pagos, parciales o totales, de las disposiciones que previamente hubiere hecho, quedando facultado, mientras el Contrato no concluya, para disponer en la forma pactada del saldo que resulte a su favor".

### 1.2 Pago Mínimo

Se define como "el monto que la Entidad requiere al acreditado de un Crédito Revolvente en cada periodo de pago, conforme al Contrato respectivo, para que, una vez cubierto, dicho Crédito Revolvente se considere al corriente y que, en su caso, se determine conforme a lo previsto en el numeral 4.1 de la Circular 34/2010, o bien, en el numeral 2 de la Circular 13/2011, ambas emitidas por el Banco de México".

### 1.3 Actualización de la Definición de Entidades

Se actualiza la lista de entidades que deben calcular el CAT, incluyendo ahora:
1. Instituciones de crédito
2. Sociedades financieras de objeto múltiple reguladas y no reguladas
3. Sociedades financieras populares
4. Sociedades financieras comunitarias
5. Sociedades cooperativas de ahorro y préstamo
6. Uniones de crédito
7. Entidades financieras que actúen como fiduciarias en fideicomisos que otorguen Crédito al público
8. Sociedades que de manera habitual otorguen Créditos al público

## 2. Cambios en la Fórmula y Componentes del CAT

### 2.1 Soluciones Múltiples o Valores Negativos

Se establece que cuando la ecuación matemática para el cálculo de la variable i tenga como resultado:
- Más de una solución, o
- Un valor negativo o indeterminado (dependiendo del valor de la garantía)

El CAT será el valor positivo más cercano a cero. En el segundo caso, se deberá reducir el valor de la garantía en la proporción necesaria para obtener el primer valor positivo de la variable i.

### 2.2 Nuevos Componentes a Considerar

#### 2.2.1 Garantías en Efectivo

Se incluyen las garantías en efectivo que el Cliente esté obligado a constituir o mantener como condición para el otorgamiento o administración del Crédito. Se deben considerar:
- Los flujos en la fecha de constitución de la garantía
- Los flujos en la fecha de liberación
- Los intereses generados en ese periodo

Para el cálculo, el monto total de la garantía se incluirá en la variable (Bk) al momento de su constitución, y al liberarse, se incluirá con signo negativo en la misma variable.

> **Nota**: Para una implementación detallada de esta metodología, consulte el documento [Garantías en Efectivo y su Impacto en el Cálculo del CAT](./garantias_efectivo_cat.md).

#### 2.2.2 Comisiones Opcionales para Tasas Preferenciales

Se incluyen las Comisiones cuyos pagos sean opcionales para los Clientes pero que las Entidades requieran como condición para acceder a tasas de interés preferenciales.

## 3. Cambios en los Supuestos para el Cálculo del CAT

### 3.1 Supuestos para Créditos Revolventes

Se establecen nuevos supuestos específicos para Créditos Revolventes:

1. El Cliente:
   - Dispone del monto total de la línea de crédito al inicio de la vigencia del Crédito
   - Cubre en cada periodo únicamente el Pago Mínimo
   - Dispone de la parte del monto de la línea de crédito que resulte inmediatamente después de cada pago del período

2. Los intereses, el Pago Mínimo y las nuevas disposiciones de la línea de crédito se generan o realizan al final del período al que correspondan

3. El Pago Mínimo y los intereses son constantes para todos los períodos

4. El monto de la Comisión anual que se cobra al final del primer periodo de cada año se mantiene constante durante un plazo de 3 años

### 3.2 Plazo para Créditos Revolventes

Independientemente del plazo de vencimiento del Crédito Revolvente o su renovación automática, se debe aplicar al cálculo del CAT un plazo de 36 meses de 30 días cada uno, asumiendo que el saldo insoluto se amortiza al finalizar el último período del tercer año.

### 3.3 Montos de Línea de Crédito para Publicidad

Se actualizan los montos de línea de crédito a utilizar en el cálculo del CAT para publicidad, ahora expresados en UDIS:

- Tarjeta de crédito tipo clásica o Crédito Revolvente equivalente: 3,000 UDIS
- Tarjeta de crédito tipo oro o Crédito Revolvente equivalente: 7,000 UDIS
- Tarjeta de crédito tipo platino o Crédito Revolvente equivalente: 13,000 UDIS

Estos montos deben actualizarse a partir del primer día hábil bancario de enero de cada año, con base en el valor de la UDI del 31 de diciembre del año anterior.

## 4. Implicaciones Prácticas

### 4.1 Para el Cálculo del CAT en Créditos Revolventes

- Se debe excluir del cálculo los descuentos, bonificaciones o cualquier otra cantidad que el Cliente tenga derecho a recibir en caso de cumplir con las condiciones de pago establecidas
- Se debe considerar un plazo fijo de 36 meses para todos los Créditos Revolventes
- Se debe asumir que el cliente solo realiza el Pago Mínimo en cada período

> **Nota**: Para una implementación detallada de esta metodología, consulte el documento [Cálculo del CAT para Créditos Revolventes](./creditos_revolventes_cat.md).

### 4.2 Para la Publicidad y Propaganda

- Los montos de línea de crédito ahora se expresan en UDIS y deben actualizarse anualmente
- Para productos nuevos (primer año de comercialización), se debe usar la estimación de las características que la Entidad pretenda establecer
- Para productos con más de un año en el mercado, se debe usar el promedio ponderado de los CAT de los Créditos otorgados del producto específico

## 5. Conclusiones

La Circular 9/2015 introduce cambios significativos en la metodología de cálculo del CAT, especialmente para Créditos Revolventes, con el objetivo de mejorar la transparencia y comparabilidad entre productos financieros. Las entidades financieras deben adaptar sus sistemas y procedimientos para cumplir con estos nuevos requisitos antes de la fecha de entrada en vigor (26 de octubre de 2015).