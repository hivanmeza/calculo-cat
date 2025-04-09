# Garantías en Efectivo y su Impacto en el Cálculo del CAT

Este documento detalla cómo se deben considerar las garantías en efectivo en el cálculo del Costo Anual Total (CAT) según lo establecido en la Circular 9/2015 del Banco de México.

## 1. Definición y Alcance

La Circular 9/2015 introduce un nuevo componente a considerar en el cálculo del CAT: las garantías en efectivo que el Cliente está obligado a constituir o mantener como condición para el otorgamiento o administración del Crédito.

### 1.1 Tipos de Garantías Incluidas

- **Depósitos en garantía**: Montos que el cliente debe depositar como condición para el otorgamiento del crédito.
- **Garantías líquidas**: Inversiones o instrumentos financieros que el cliente debe mantener como respaldo.
- **Fondos de reserva**: Montos apartados para garantizar pagos futuros.

## 2. Metodología de Inclusión en el Cálculo

Según el inciso d Bis) del numeral 4.2 de la Circular 9/2015, las garantías en efectivo deben considerarse de la siguiente manera:

### 2.1 Flujos a Considerar

> **Nota importante sobre los signos**: La convención de signos debe reflejar la perspectiva de la institución financiera que otorga el crédito. Esto significa que los desembolsos (dinero que sale de la institución) deben tener signo negativo, mientras que los ingresos (dinero que entra a la institución) deben tener signo positivo.

1. **Flujo en la fecha de constitución**: El monto total de la garantía se incluirá en la variable (Bk) en el orden que corresponda al momento de su constitución. Desde la perspectiva de la institución financiera, este es un ingreso (valor positivo) ya que recibe la garantía del cliente.

2. **Flujo en la fecha de liberación**: Al liberar dicha garantía, se incluirá, con signo negativo desde la perspectiva de la institución financiera, el monto de la garantía en la variable (Bk), ya que representa un desembolso para la institución.

3. **Intereses generados**: Se deben incluir, en su caso, los intereses generados durante el periodo que la garantía estuvo constituida. Estos intereses representan un desembolso para la institución financiera (valor negativo).

### 2.2 Ejemplo de Aplicación

**Escenario**:
- Crédito de $100,000 a 24 meses
- Garantía en efectivo requerida: $10,000 (10% del monto del crédito)
- La garantía se libera al final del plazo del crédito
- La garantía genera intereses del 2% anual

**Aplicación en el cálculo desde la perspectiva de la institución financiera**:
1. En el flujo inicial (t=0):
   - Disposición del crédito: -$100,000 (variable Aj) - La institución desembolsa el crédito
   - Constitución de la garantía: +$10,000 (variable Bk) - La institución recibe la garantía
   - Flujo neto inicial: -$90,000 - Desembolso neto de la institución

2. Durante los 24 meses: Pagos regulares del crédito (variable Bk) - Ingresos para la institución (valores positivos)

3. En el flujo final (t=24):
   - Último pago del crédito (variable Bk) - Ingreso para la institución (valor positivo)
   - Liberación de la garantía: -$10,000 - intereses acumulados (variable Bk con signo negativo) - La institución devuelve la garantía y los intereses generados

## 3. Casos Especiales

### 3.1 Garantías que Generan Rendimientos Variables

Cuando la garantía genera rendimientos variables (no conocidos de antemano), la entidad debe estimar estos rendimientos basándose en información histórica o de mercado, y documentar los elementos utilizados para dicha estimación.

### 3.2 Garantías Liberadas Parcialmente

Si la garantía se libera en partes durante la vida del crédito, cada liberación parcial debe registrarse como un flujo negativo en la variable Bk en el momento correspondiente.

### 3.3 Solución para Valores Negativos o Indeterminados

Según el inciso b) del numeral 4.1 de la Circular 9/2015, cuando la ecuación matemática para el cálculo de la variable i tenga como resultado un valor negativo o indeterminado debido al valor de la garantía, se deberá reducir el valor de la garantía en la proporción necesaria para obtener el primer valor positivo de la variable i.

## 4. Impacto en el CAT

La inclusión de garantías en efectivo en el cálculo del CAT puede tener un impacto significativo:

1. **Reducción del monto efectivamente recibido**: Al constituir la garantía, el cliente recibe menos dinero del monto del crédito, lo que aumenta el CAT.

2. **Compensación parcial por rendimientos**: Si la garantía genera intereses, estos compensan parcialmente el costo, reduciendo el impacto en el CAT.

3. **Efecto temporal**: El impacto en el CAT depende del momento de liberación de la garantía; cuanto más tarde se libere, mayor será el impacto.

## 5. Implementación en Código

A continuación se muestra un ejemplo simplificado de cómo implementar la consideración de garantías en efectivo en el cálculo del CAT:

```python
def calcular_cat_con_garantia(monto_credito, plazo_meses, tasa_interes_anual, 
                             monto_garantia, tasa_rendimiento_garantia=0, 
                             mes_liberacion_garantia=None):
    # Si no se especifica, la garantía se libera al final del plazo
    if mes_liberacion_garantia is None:
        mes_liberacion_garantia = plazo_meses
    
    # Convertir tasas anuales a mensuales
    tasa_mensual = tasa_interes_anual / 12
    tasa_rendimiento_mensual = tasa_rendimiento_garantia / 12
    
    # Calcular pago mensual del crédito
    pago_mensual = monto_credito * (tasa_mensual * (1 + tasa_mensual) ** plazo_meses) / \
                  ((1 + tasa_mensual) ** plazo_meses - 1)
    
    # Flujos de efectivo
    flujos = [monto_credito - monto_garantia]  # Flujo inicial neto
    
    # Pagos mensuales
    for mes in range(1, plazo_meses + 1):
        flujo_mes = -pago_mensual
        
        # Si es el mes de liberación, agregar el monto de la garantía más rendimientos
        if mes == mes_liberacion_garantia:
            # Calcular el valor acumulado de la garantía con rendimientos
            valor_garantia = monto_garantia * (1 + tasa_rendimiento_mensual) ** mes
            flujo_mes += valor_garantia
        
        flujos.append(flujo_mes)
    
    # Calcular el CAT
    cat = calcular_tir(flujos) * 12 * 100  # Convertir a porcentaje anual
    
    return cat
```

## 6. Conclusiones

La inclusión de las garantías en efectivo en el cálculo del CAT, según lo establecido en la Circular 9/2015, representa un avance importante en la transparencia de los costos reales de los créditos para los consumidores. Las entidades financieras deben asegurarse de implementar correctamente esta metodología para cumplir con la normativa y proporcionar información precisa a sus clientes.