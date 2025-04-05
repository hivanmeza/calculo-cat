# Regulaciones y Normativas del CAT en México

Este documento describe el marco regulatorio que rige el cálculo y la divulgación del Costo Anual Total (CAT) en México, elemento fundamental para comprender los requisitos legales que debe cumplir cualquier implementación.

## 1. Marco Regulatorio Principal

### 1.1 Banco de México (Banxico)

**Circular 21/2009 y sus modificaciones**
- Establece la metodología oficial para el cálculo del CAT
- Define los componentes que deben incluirse en el cálculo
- Especifica la fórmula matemática y procedimiento de cálculo
- Determina las reglas de redondeo y presentación

**Disposiciones de carácter general**
- Actualizaciones periódicas a la metodología
- Criterios específicos para diferentes tipos de crédito
- Requisitos de divulgación en publicidad y contratos

### 1.2 Comisión Nacional para la Protección y Defensa de los Usuarios de Servicios Financieros (CONDUSEF)

**Disposiciones de transparencia**
- Requisitos para la presentación del CAT en documentos oficiales
- Formatos estandarizados para comparación de productos
- Sanciones por incumplimiento en la divulgación correcta

**Registro de Comisiones (RECO)**
- Base de datos oficial de comisiones financieras
- Verificación de que las comisiones incluidas en el CAT estén registradas

### 1.3 Ley para la Transparencia y Ordenamiento de los Servicios Financieros

- Establece la obligatoriedad del CAT como indicador del costo de financiamiento
- Define las facultades de Banxico y CONDUSEF en la regulación del CAT
- Establece sanciones por incumplimiento

## 2. Componentes Obligatorios en el Cálculo

### 2.1 Elementos que Deben Incluirse

- **Tasa de interés ordinaria**
  - Expresada en términos anualizados
  - Considerando la periodicidad de capitalización

- **Comisiones y cargos obligatorios**
  - Comisión por apertura
  - Comisiones por administración o mantenimiento
  - Cargos por investigación, análisis o similares

- **Seguros obligatorios**
  - Primas de seguros requeridos para la contratación
  - No incluye seguros opcionales

- **Otros costos y gastos obligatorios**
  - Avalúos requeridos por la institución
  - Gastos notariales a cargo del cliente
  - Impuestos y derechos específicos

### 2.2 Elementos Excluidos

- Impuestos al Valor Agregado (IVA) sobre intereses
- Comisiones por servicios adicionales no obligatorios
- Comisiones por incumplimiento (intereses moratorios)
- Seguros opcionales no requeridos para la contratación
- Gastos a cargo de terceros

## 3. Requisitos de Divulgación

### 3.1 Publicidad y Promoción

- El CAT debe presentarse en términos porcentuales anuales
- Debe mostrarse con al menos el mismo tamaño y prominencia que la tasa de interés
- Debe incluir la leyenda "Para fines informativos y de comparación"
- En medios audiovisuales, debe mencionarse de forma clara y audible

### 3.2 Documentación Contractual

- Debe incluirse en la carátula del contrato
- Debe especificarse la fecha de cálculo
- Para créditos de tasa variable, debe indicarse que el CAT puede variar
- Debe incluirse un desglose de los componentes utilizados en el cálculo

### 3.3 Estados de Cuenta

- Para tarjetas de crédito y créditos revolventes, debe incluirse el CAT promedio ponderado
- Debe actualizarse con cada cambio en las condiciones financieras
- Debe presentarse junto con el saldo insoluto y plazo remanente

## 4. Consideraciones Específicas por Tipo de Crédito

### 4.1 Créditos Hipotecarios

- Deben incluirse todos los gastos iniciales (avalúo, notaría, registro)
- Los seguros obligatorios deben considerarse durante toda la vida del crédito
- Para tasas variables, debe calcularse con la tasa de referencia vigente
- Debe presentarse el CAT con y sin IVA

### 4.2 Créditos Automotrices

- Deben incluirse gastos de registro de garantía prendaria
- Los seguros obligatorios deben considerarse durante toda la vida del crédito
- Comisiones por apertura y administración deben incluirse

### 4.3 Tarjetas de Crédito

- Debe calcularse un CAT promedio ponderado
- Debe considerarse la anualidad
- Para promociones a meses sin intereses, debe calcularse un CAT específico
- Debe distinguirse entre CAT para compras y para disposiciones de efectivo

### 4.4 Microcréditos

- Deben incluirse comisiones por administración de grupo (en créditos grupales)
- El ahorro forzoso debe considerarse como flujo negativo inicial y positivo al final
- Todas las comisiones obligatorias deben incluirse

## 5. Metodología Oficial de Cálculo

### 5.1 Fórmula General

La fórmula establecida por Banxico se basa en la ecuación de valor presente neto igualada a cero:

```
M = Σ[Aj / (1 + i)^tj]
```

Donde:
- M es el monto del crédito (considerando deducciones iniciales)
- Aj son los pagos futuros (amortizaciones, intereses, comisiones y otros gastos)
- tj es el tiempo expresado en años
- i es el CAT (expresado en forma decimal)

### 5.2 Procedimiento de Cálculo

1. Identificar todos los flujos de efectivo relevantes
2. Expresar los tiempos en años (con precisión de al menos 4 decimales)
3. Resolver la ecuación para encontrar el valor de i
4. Multiplicar por 100 para expresar como porcentaje
5. Redondear al primer decimal

### 5.3 Precisión y Redondeo

- Los cálculos intermedios deben realizarse con al menos 6 decimales
- El resultado final debe redondearse a un decimal
- El redondeo debe ser al alza (por ejemplo, 12.34% se redondea a 12.4%)

## 6. Comparación con Estándares Internacionales

### 6.1 Tasa Anual Equivalente (TAE) - Unión Europea

- Metodología similar basada en la ecuación de valor presente
- Diferencias en componentes obligatorios (menos inclusiva que el CAT)
- Requisitos de divulgación similares

### 6.2 Annual Percentage Rate (APR) - Estados Unidos

- Regulada por la Truth in Lending Act (TILA)
- Metodología similar pero con diferencias en componentes incluidos
- Menos inclusiva que el CAT mexicano (excluye algunos costos obligatorios)

### 6.3 Costo Total del Crédito (CTC) - Chile

- Metodología similar al CAT mexicano
- Incluye la mayoría de los costos obligatorios
- Requisitos de divulgación comparables

## 7. Consideraciones para la Implementación

### 7.1 Validación Regulatoria

- Verificar la metodología con la última versión de las circulares de Banxico
- Comparar resultados con calculadoras oficiales (como la de CONDUSEF)
- Documentar el proceso de cálculo para fines de auditoría

### 7.2 Actualizaciones Regulatorias

- Implementar un proceso para monitorear cambios en la normativa
- Establecer procedimientos para actualizar la metodología cuando sea necesario
- Mantener versiones históricas para referencias futuras

### 7.3 Documentación y Evidencia

- Mantener registros detallados de los componentes incluidos en cada cálculo
- Documentar los supuestos utilizados para créditos de tasa variable
- Conservar evidencia de los cálculos para posibles revisiones regulatorias

## 8. Próximos Pasos

1. Revisar las circulares más recientes de Banxico para confirmar la metodología actual
2. Implementar la fórmula oficial en el código, siguiendo estrictamente la normativa
3. Desarrollar pruebas de validación con casos publicados por CONDUSEF
4. Crear documentación detallada del cumplimiento regulatorio
5. Establecer un proceso de revisión periódica para mantener la conformidad