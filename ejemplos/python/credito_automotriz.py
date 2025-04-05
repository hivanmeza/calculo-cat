#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Cálculo del CAT para Créditos Automotrices

Este módulo implementa el algoritmo para calcular el Costo Anual Total (CAT)
para créditos automotrices con pagos fijos mensuales, considerando el enganche
y otros costos específicos de este tipo de crédito.
"""

import numpy as np
from datetime import datetime, timedelta


def calcular_cat(precio_vehiculo, enganche, plazo_meses, tasa_interes_anual, 
                comision_apertura=0, comisiones_mensuales=0, seguro_auto=0, 
                seguro_vida=0, gps=0, otros_costos=0):
    """
    Calcula el CAT para un crédito automotriz con pagos fijos mensuales.
    
    Args:
        precio_vehiculo (float): Precio total del vehículo en pesos
        enganche (float): Monto del enganche en pesos
        plazo_meses (int): Plazo del crédito en meses
        tasa_interes_anual (float): Tasa de interés anual (en decimal, ej: 0.12 para 12%)
        comision_apertura (float, opcional): Comisión por apertura (en pesos)
        comisiones_mensuales (float, opcional): Comisiones mensuales fijas (en pesos)
        seguro_auto (float, opcional): Costo del seguro de auto mensual (en pesos)
        seguro_vida (float, opcional): Costo del seguro de vida mensual (en pesos)
        gps (float, opcional): Costo mensual del dispositivo GPS (en pesos)
        otros_costos (float, opcional): Otros costos iniciales (en pesos)
    
    Returns:
        float: CAT expresado como porcentaje anual (ej: 16.5 para 16.5%)
    """
    # Calcular monto del crédito
    monto_credito = precio_vehiculo - enganche
    
    # Convertir tasa anual a mensual
    tasa_mensual = tasa_interes_anual / 12
    
    # Calcular pago mensual (amortización + intereses)
    pago_mensual = monto_credito * (tasa_mensual * (1 + tasa_mensual) ** plazo_meses) / \
                  ((1 + tasa_mensual) ** plazo_meses - 1)
    
    # Monto neto recibido (descontando comisiones y otros costos iniciales)
    # En un crédito automotriz, el monto neto es el valor del vehículo menos el enganche
    monto_neto = monto_credito - comision_apertura - otros_costos
    
    # Flujos de efectivo (valor negativo para salidas, positivo para entradas)
    flujos = [monto_neto]  # Flujo inicial (dinero recibido)
    
    # Agregar pagos mensuales (salidas de dinero)
    for _ in range(plazo_meses):
        flujos.append(-(pago_mensual + comisiones_mensuales + seguro_auto + seguro_vida + gps))
    
    # Calcular el CAT usando el método de Newton-Raphson
    cat = calcular_tir(flujos) * 12 * 100  # Convertir a porcentaje anual
    
    return cat


def calcular_tir(flujos, tolerancia=1e-10, max_iteraciones=1000):
    """
    Calcula la Tasa Interna de Retorno (TIR) mensual para una serie de flujos de efectivo.
    
    Args:
        flujos (list): Lista de flujos de efectivo, donde el primer elemento es el monto neto recibido
                      y los siguientes son los pagos (negativos)
        tolerancia (float, opcional): Tolerancia para la convergencia del método
        max_iteraciones (int, opcional): Número máximo de iteraciones
    
    Returns:
        float: TIR mensual expresada como decimal
    """
    # Estimación inicial
    tasa = 0.1
    
    for i in range(max_iteraciones):
        # Calcular el valor presente neto con la tasa actual
        vpn = calcular_vpn(flujos, tasa)
        
        # Si el VPN está dentro de la tolerancia, hemos encontrado la TIR
        if abs(vpn) < tolerancia:
            return tasa
        
        # Calcular la derivada del VPN respecto a la tasa
        derivada = calcular_derivada_vpn(flujos, tasa)
        
        # Actualizar la tasa usando el método de Newton-Raphson
        nueva_tasa = tasa - vpn / derivada
        
        # Si la tasa no cambia significativamente, hemos convergido
        if abs(nueva_tasa - tasa) < tolerancia:
            return nueva_tasa
        
        tasa = nueva_tasa
    
    # Si no converge, devolver la mejor aproximación
    return tasa


def calcular_vpn(flujos, tasa):
    """
    Calcula el Valor Presente Neto (VPN) para una serie de flujos de efectivo y una tasa dada.
    
    Args:
        flujos (list): Lista de flujos de efectivo
        tasa (float): Tasa de descuento mensual
    
    Returns:
        float: VPN calculado
    """
    vpn = 0
    for i, flujo in enumerate(flujos):
        vpn += flujo / ((1 + tasa) ** i)
    return vpn


def calcular_derivada_vpn(flujos, tasa):
    """
    Calcula la derivada del VPN respecto a la tasa para una serie de flujos de efectivo.
    
    Args:
        flujos (list): Lista de flujos de efectivo
        tasa (float): Tasa de descuento mensual
    
    Returns:
        float: Derivada del VPN respecto a la tasa
    """
    derivada = 0
    for i, flujo in enumerate(flujos):
        if i > 0:  # La derivada del primer flujo es cero
            derivada -= i * flujo / ((1 + tasa) ** (i + 1))
    return derivada


def ejemplo_credito_automotriz():
    """
    Ejemplo de uso para un crédito automotriz.
    """
    # Parámetros del crédito
    precio_vehiculo = 350000  # $350,000 pesos
    enganche = 70000  # $70,000 pesos (20% del valor del vehículo)
    plazo_meses = 48  # 4 años
    tasa_interes_anual = 0.16  # 16% anual
    comision_apertura = 3500  # $3,500 pesos (1% del valor del vehículo)
    comisiones_mensuales = 0  # Sin comisiones mensuales
    seguro_auto = 1200  # $1,200 pesos mensuales
    seguro_vida = 300  # $300 pesos mensuales
    gps = 150  # $150 pesos mensuales
    otros_costos = 2000  # $2,000 pesos (placas, verificación, etc.)
    
    # Calcular el CAT
    cat = calcular_cat(
        precio_vehiculo=precio_vehiculo,
        enganche=enganche,
        plazo_meses=plazo_meses,
        tasa_interes_anual=tasa_interes_anual,
        comision_apertura=comision_apertura,
        comisiones_mensuales=comisiones_mensuales,
        seguro_auto=seguro_auto,
        seguro_vida=seguro_vida,
        gps=gps,
        otros_costos=otros_costos
    )
    
    # Imprimir resultados
    print(f"Precio del vehículo: ${precio_vehiculo:,.2f}")
    print(f"Enganche: ${enganche:,.2f} ({enganche/precio_vehiculo*100:.2f}%)")
    print(f"Monto del crédito: ${precio_vehiculo-enganche:,.2f}")
    print(f"Plazo: {plazo_meses} meses ({plazo_meses/12:.1f} años)")
    print(f"Tasa de interés anual: {tasa_interes_anual*100:.2f}%")
    print(f"Comisión por apertura: ${comision_apertura:,.2f}")
    print(f"Seguro de auto mensual: ${seguro_auto:,.2f}")
    print(f"Seguro de vida mensual: ${seguro_vida:,.2f}")
    print(f"GPS mensual: ${gps:,.2f}")
    print(f"Otros costos: ${otros_costos:,.2f}")
    print(f"CAT: {cat:.2f}%")


if __name__ == "__main__":
    ejemplo_credito_automotriz()