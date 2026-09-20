<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:if test="${empty sessionScope.saldo}">
    <c:redirect url="/billetera" />
</c:if>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billetera Digital</title>
    <!-- Bootstrap 5 CSS via CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons via CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .wallet-header {
            background: linear-gradient(135deg, #be4184 0%, #0d6efd 100%);
            color: white;
        }
        .balance-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-left: 5px solid #198754;
        }
        .card-custom {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.08);
        }
    </style>
</head>
<body>

    <!-- Barra de Navegación -->
    <nav class="navbar navbar-expand-lg wallet-header shadow-sm mb-4">
        <div class="container">
            <span class="navbar-brand text-white fw-bold d-flex align-items-center gap-2">
                <i class="bi bi-wallet2 fs-4"></i> Billetera Digital
            </span>
            <span class="badge bg-light text-dark px-3 py-2 rounded-pill">
                <i class="bi bi-shield-check text-success"></i> Sesión Activa
            </span>
        </div>
    </nav>

    <div class="container mb-5">

        <!-- Mensaje de Error / Validación -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                <div class="d-flex align-items-center">
                    <i class="bi bi-exclamation-octagon-fill fs-4 me-3"></i>
                    <div>
                        <strong>Error en la operación:</strong> ${error}
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Columna Izquierda: Saldo y Formulario -->
            <div class="col-lg-5">
                <!-- Tarjeta visual con el Saldo Actual -->
                <div class="card card-custom balance-card p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="text-uppercase text-muted fw-semibold small">Saldo Disponible</span>
                        <i class="bi bi-cash-stack text-success fs-3"></i>
                    </div>
                    <div class="display-5 fw-bold text-dark">
                        S/ ${saldo}
                    </div>
                    <div class="text-muted small mt-2">
                        <i class="bi bi-info-circle"></i> Actualizado en tiempo real en memoria de sesión
                    </div>
                </div>

                <!-- Formulario POST de Operaciones -->
                <div class="card card-custom p-4">
                    <h5 class="card-title fw-bold mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left-right text-primary"></i> Nueva Transacción
                    </h5>
                    <form action="${pageContext.request.contextPath}/billetera" method="post">
                        <!-- Selector de Operación -->
                        <div class="mb-3">
                            <label for="tipo" class="form-label fw-semibold">Tipo de Operación</label>
                            <select class="form-select" id="tipo" name="tipo" required>
                                <option value="Recarga">Recarga (+)</option>
                                <option value="Gasto">Gasto (-)</option>
                            </select>
                        </div>

                        <!-- Input Numérico de Monto -->
                        <div class="mb-3">
                            <label for="monto" class="form-label fw-semibold">Monto (S/)</label>
                            <div class="input-group">
                                <span class="input-group-text">S/</span>
                                <input type="number" step="0.01" min="0.01" class="form-control" id="monto" name="monto" placeholder="0.00" required>
                            </div>
                            <div class="form-text">Ingrese un monto positivo mayor a cero.</div>
                        </div>

                        <!-- Botón de Envío -->
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                            <i class="bi bi-check-circle me-1"></i> Registrar Operación
                        </button>
                    </form>
                </div>
            </div>

            <!-- Columna Derecha: Tabla de Movimientos -->
            <div class="col-lg-7">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="card-title fw-bold mb-0 d-flex align-items-center gap-2">
                            <i class="bi bi-clock-history text-secondary"></i> Historial de Movimientos
                        </h5>
                        <span class="badge bg-secondary rounded-pill">${movimientos.size()} operaciones</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th scope="col" style="width: 10%;">ID</th>
                                    <th scope="col" style="width: 25%;">Fecha</th>
                                    <th scope="col" style="width: 25%;">Tipo</th>
                                    <th scope="col" class="text-end" style="width: 40%;">Monto</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty movimientos}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                            Aún no se han registrado movimientos en esta sesión.
                                        </td>
                                    </tr>
                                </c:if>
                                <c:forEach var="mov" items="${movimientos}">
                                    <tr>
                                        <td class="text-muted fw-semibold">#${mov.id}</td>
                                        <td>${mov.fecha}</td>
                                        <td>
                                            <c:if test="${mov.tipo == 'Recarga'}">
                                                <span class="badge bg-success px-2 py-1">Recarga</span>
                                            </c:if>
                                            <c:if test="${mov.tipo == 'Gasto'}">
                                                <span class="badge bg-danger px-2 py-1">Gasto</span>
                                            </c:if>
                                        </td>
                                        <td class="text-end fw-bold">
                                            <c:if test="${mov.tipo == 'Recarga'}">
                                                <span class="text-success">${mov.montoFormateado}</span>
                                            </c:if>
                                            <c:if test="${mov.tipo == 'Gasto'}">
                                                <span class="text-danger">${mov.montoFormateado}</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle via CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
