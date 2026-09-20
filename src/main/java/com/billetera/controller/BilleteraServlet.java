package com.billetera.controller;

import com.billetera.model.Movimiento;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * Controlador principal de la Billetera Digital.
 * Mapeado a la ruta /billetera.
 */
@WebServlet("/billetera")
public class BilleteraServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final double SALDO_INICIAL = 250.00;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Inicializar en sesión el saldo inicial de prueba (S/ 250.00) y la lista de movimientos si no existen
        if (session.getAttribute("saldo") == null) {
            session.setAttribute("saldo", SALDO_INICIAL);
        }

        if (session.getAttribute("movimientos") == null) {
            session.setAttribute("movimientos", new ArrayList<Movimiento>());
        }

        // Enviar mensajes de error a la vista si existen en sesión
        String error = (String) session.getAttribute("error");
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        // Hacer forward a index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Asegurar estado de saldo y movimientos en sesión
        Double saldo = (Double) session.getAttribute("saldo");
        if (saldo == null) {
            saldo = SALDO_INICIAL;
            session.setAttribute("saldo", saldo);
        }

        @SuppressWarnings("unchecked")
        List<Movimiento> movimientos = (List<Movimiento>) session.getAttribute("movimientos");
        if (movimientos == null) {
            movimientos = new ArrayList<>();
            session.setAttribute("movimientos", movimientos);
        }

        // Recibir parámetros tipo y monto
        String tipo = request.getParameter("tipo");
        String montoStr = request.getParameter("monto");

        // Validaciones
        if (tipo == null || (!tipo.equalsIgnoreCase("Recarga") && !tipo.equalsIgnoreCase("Gasto"))) {
            session.setAttribute("error", "Debe seleccionar un tipo de operación válido (Recarga o Gasto).");
        } else if (montoStr == null || montoStr.trim().isEmpty()) {
            session.setAttribute("error", "Debe ingresar un monto numérico.");
        } else {
            try {
                // Soportar coma decimal y punto decimal
                double monto = Double.parseDouble(montoStr.trim().replace(',', '.'));
                monto = Math.round(monto * 100.0) / 100.0;

                if (monto <= 0) {
                    session.setAttribute("error", "El monto ingresado debe ser mayor a cero.");
                } else if ("Gasto".equalsIgnoreCase(tipo) && monto > saldo) {
                    session.setAttribute("error", "Saldo insuficiente para realizar este gasto.");
                } else {
                    // Operación válida: actualizar saldo con redondeo a 2 decimales
                    if ("Recarga".equalsIgnoreCase(tipo)) {
                        saldo += monto;
                        tipo = "Recarga";
                    } else {
                        saldo -= monto;
                        tipo = "Gasto";
                    }
                    saldo = Math.round(saldo * 100.0) / 100.0;
                    session.setAttribute("saldo", saldo);

                    // Insertar el movimiento en la posición 0 de la lista (orden descendente)
                    int nuevoId = movimientos.size() + 1;
                    String fecha = LocalDate.now().format(DATE_FORMATTER);
                    Movimiento nuevoMovimiento = new Movimiento(nuevoId, fecha, tipo, monto);
                    movimientos.add(0, nuevoMovimiento);

                    // Limpiar mensaje de error si la operación fue exitosa
                    session.removeAttribute("error");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "El monto ingresado no es un número válido.");
            }
        }

        // Finalizar estrictamente con response.sendRedirect("billetera") (patrón PRG)
        // Verificación: Ningún flujo en doPost utiliza forward().
        response.sendRedirect("billetera");
    }
}
