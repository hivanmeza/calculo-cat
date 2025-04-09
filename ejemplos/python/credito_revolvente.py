#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Cálculo del CAT para Créditos Revolventes según Circular 9/2015

Este módulo implementa el algoritmo para calcular el Costo Anual Total (CAT)
para créditos revolventes (incluyendo tarjetas de crédito) siguiendo la
metodología establecida en la Circular 9/2015 del Banco de México.
"""

import numpy as np
from datetime import datetime, timedelta


def calcular_cat_revolvente(monto_linea_credito, tasa_interes_anual, comision_anual=0,
                          pago_minimo_porcentaje=0.05, otros_cargos_mensuales=0):
    """
    Calcula el CAT para un crédito revolvente según la Circular 9/2015.
    
    Args:
        monto_linea_credito (float): Monto de la línea de crédito en pesos
        tasa_interes_anual (float): Tasa de interés anual (en decimal, ej: 0.36 para 36%)
        comision_anual (float, opcional): Comisión anual (en pesos)
        pago_minimo_porcentaje (float, opcional): Porcentaje del saldo para pago mínimo (decimal)
        otros_cargos_mensuales (float, opcional): Otros cargos mensuales fijos (en pesos)
    
    Returns:
        float: CAT expresado como porcentaje anual (ej: 45.2 para 45.2%)
    """
    # Convertir tasa anual a mensual
    tasa_mensual = tasa_interes_anual / 12
    
    # Plazo fijo de 36 meses según Circular 9/2015
    plazo_meses = 36
    
    # Supuestos según Circular 9/2015:
    # 1. Cliente dispone del monto total de la línea al inicio
    # 2. Cliente cubre solo el pago mínimo en cada periodo
    # 3. Cliente vuelve a disponer del monto disponible después de cada pago
    # 4. Intereses, pago mínimo y nuevas disposiciones se generan al final del periodo
    
    # Flujos de efectivo (valor negativo para salidas, positivo para entradas)
    flujos = [monto_linea_credito]  # Flujo inicial (dinero recibido)
    
    # Saldo inicial = monto total de la línea
    saldo = monto_linea_credito
    
    # Calcular pagos mensuales y nuevas disposiciones para los 36 meses
    for mes in range(1, plazo_meses + 1):
        # Calcular intereses del periodo
        intereses = saldo * tasa_mensual
        
        # Calcular pago mínimo (mayor entre porcentaje del saldo y un monto fijo mínimo)
        pago_minimo = max(saldo * pago_minimo_porcentaje, 100)  # Asumimos $100 como mínimo
        
        # Agregar comisión anual al final de cada 12 meses
        comision_periodo = comision_anual if mes % 12 == 0 else 0
        
        # Pago total del periodo (pago mínimo + otros cargos + comisión anual si aplica)
        pago_total = pago_minimo + otros_cargos_mensuales + comision_periodo
        
        # Actualizar saldo: saldo anterior + intereses - pago mínimo
        saldo = saldo + intereses - pago_minimo
        
        # Nueva disposición: lo que se pagó del principal (no los intereses)
        nueva_disposicion = pago_minimo - intereses if pago_minimo > intereses else 0
        
        # Si es el último mes, se amortiza todo el saldo restante
        if mes == plazo_meses:
            pago_total += saldo
            saldo = 0
            nueva_disposicion = 0
        else:
            # Actualizar saldo con nueva disposición
            saldo += nueva_disposicion
        
        # Agregar flujo negativo (pago) y flujo positivo (nueva disposición)
        flujos.append(-pago_total)
        if nueva_disposicion > 0:
            flujos.append(nueva_disposicion)
    
    # Calcular el CAT usando el método de Newton-Raphson
    cat = calcular_tir(flujos) * 12 * 100  # Convertir a porcentaje anual
    
    return cat


def calcular_tir(flujos, tolerancia=1e-10, max_iteraciones=1000):
    """
    Calcula la Tasa Interna de Retorno (TIR) mensual usando el método de Newton-Raphson.
    
    Args:
        flujos (list): Lista de flujos de efectivo (positivo para entradas, negativo para salidas)
        tolerancia (float, opcional): Tolerancia para convergencia
        max_iteraciones (int, opcional): Número máximo de iteraciones
    
    Returns:
        float: TIR mensual (en decimal)
    """
    # Estimación inicial
    tasa = 0.1  # 10% mensual como punto de partida
    
    for _ in range(max_iteraciones):
        # Calcular VPN con la tasa actual
        vpn = 0
        dvpn = 0  # Derivada del VPN respecto a la tasa
        
        for i, flujo in enumerate(flujos):
            factor = (1 + tasa) ** i
            vpn += flujo / factor
            if i > 0:  # La derivada del primer término es cero
                dvpn -= i * flujo / ((1 + tasa) ** (i + 1))
        
        # Si VPN está cerca de cero, hemos encontrado la TIR
        if abs(vpn) < tolerancia:
            return tasa
        
        # Actualizar tasa usando el método de Newton-Raphson
        nueva_tasa = tasa - vpn / dvpn if dvpn != 0 else tasa * 1.1
        
        # Si la tasa no cambia significativamente, hemos convergido
        if abs(nueva_tasa - tasa) < tolerancia:
            return nueva_tasa
        
        # Actualizar para la siguiente iteración
        tasa = nueva_tasa
        
        # Si la tasa se vuelve negativa o muy grande, ajustar
        if tasa <= 0:
            tasa = 0.001  # 0.1% mensual
        elif tasa > 1:
            tasa = 0.9  # 90% mensual (extremadamente alto)
    
    # Si no converge, devolver la mejor aproximación
    return tasa


def calcular_cat_tarjeta_credito(tipo_tarjeta="clasica", tasa_interes_anual=0.36, 
                               comision_anual=0, pago_minimo_porcentaje=0.05):
    """
    Calcula el CAT para una tarjeta de crédito según la Circular 9/2015,
    utilizando los montos de línea de crédito establecidos en UDIS.
    
    Args:
        tipo_tarjeta (str): Tipo de tarjeta: "clasica", "oro" o "platino"
        tasa_interes_anual (float): Tasa de interés anual (en decimal)
        comision_anual (float): Comisión anual (en pesos)
        pago_minimo_porcentaje (float): Porcentaje del saldo para pago mínimo (decimal)
    
    Returns:
        float: CAT expresado como porcentaje anual
    """
    # Valor de la UDI (ejemplo, debe actualizarse con el valor real)
    valor_udi = 7.5  # Valor aproximado, debe obtenerse de fuentes oficiales
    
    # Montos en UDIS según Circular 9/2015
    montos_udis = {
        "clasica": 3000,
        "oro": 7000,
        "platino": 13000
    }
    
    # Convertir UDIS a pesos
    if tipo_tarjeta.lower() in montos_udis:
        monto_linea_credito = montos_udis[tipo_tarjeta.lower()] * valor_udi
    else:
        # Valor predeterminado si el tipo no está definido
        monto_linea_credito = montos_udis["clasica"] * valor_udi
    
    # Calcular el CAT
    cat = calcular_cat_revolvente(
        monto_linea_credito=monto_linea_credito,
        tasa_interes_anual=tasa_interes_anual,
        comision_anual=comision_anual,
        pago_minimo_porcentaje=pago_minimo_porcentaje
    )
    
    return cat


# Ejemplo de uso
if __name__ == "__main__":
    # Ejemplo 1: Tarjeta de crédito clásica
    cat_clasica = calcular_cat_tarjeta_credito(
        tipo_tarjeta="clasica",
        tasa_interes_anual=0.36,  # 36% anual
        comision_anual=700,       # $700 de anualidad
        pago_minimo_porcentaje=0.05  # 5% del saldo
    )
    
    print(f"CAT para tarjeta clásica: {cat_clasica:.2f}%")
    
    # Ejemplo 2: Tarjeta de crédito oro
    cat_oro = calcular_cat_tarjeta_credito(
        tipo_tarjeta="oro",
        tasa_interes_anual=0.30,  # 30% anual
        comision_anual=1200,      # $1,200 de anualidad
        pago_minimo_porcentaje=0.08  # 8% del saldo
    )
    
    print(f"CAT para tarjeta oro: {cat_oro:.2f}%")
    
    # Ejemplo 3: Tarjeta de crédito platino
    cat_platino = calcular_cat_tarjeta_credito(
        tipo_tarjeta="platino",
        tasa_interes_anual=0.25,  # 25% anual
        comision_anual=2000,      # $2,000 de anualidad
        pago_minimo_porcentaje=0.10  # 10% del saldo
    )
    
    print(f"CAT para tarjeta platino: {cat_platino:.2f}%")