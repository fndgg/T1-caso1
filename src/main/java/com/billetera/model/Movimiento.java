package com.billetera.model;

import java.io.Serializable;
import java.util.Locale;

/**
 * JavaBean que representa un movimiento financiero en la Billetera Digital.
 */
public class Movimiento implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String fecha;
    private String tipo; // "Recarga" o "Gasto"
    private double monto;

    public Movimiento() {
    }

    public Movimiento(int id, String fecha, String tipo, double monto) {
        this.id = id;
        this.fecha = fecha;
        this.tipo = tipo;
        this.monto = monto;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    /**
     * Función auxiliar para formatear el monto con signo (+S/ o -S/).
     *
     * @return Cadena formateada, p. ej. "+S/ 50.00" o "-S/ 20.00".
     */
    public String getMontoFormateado() {
        if ("Recarga".equalsIgnoreCase(this.tipo)) {
            return String.format(Locale.US, "+S/ %.2f", this.monto);
        } else if ("Gasto".equalsIgnoreCase(this.tipo)) {
            return String.format(Locale.US, "-S/ %.2f", this.monto);
        }
        return String.format(Locale.US, "S/ %.2f", this.monto);
    }

    /**
     * Función auxiliar para saber si es recarga.
     */
    public boolean isRecarga() {
        return "Recarga".equalsIgnoreCase(this.tipo);
    }

    @Override
    public String toString() {
        return "Movimiento{" +
                "id=" + id +
                ", fecha='" + fecha + '\'' +
                ", tipo='" + tipo + '\'' +
                ", monto=" + monto +
                '}';
    }
}
