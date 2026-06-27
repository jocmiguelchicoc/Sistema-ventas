-- Script 03 - Consultas de Validación
SET search_path TO ventas_normalizacion;

-- 1. Total calculado por cada venta desde el detalle.
-- Resultado esperado: venta_id, total_calculado.
SELECT 
    venta_id,
    SUM(cantidad * precio_unitario - descuento) AS total_calculado
FROM ventas_normalizacion.detalle_venta
GROUP BY venta_id
ORDER BY venta_id;

-- 2. Productos mas vendidos por cantidad total.
-- Resultado esperado: producto_codigo, producto_nombre, unidades_vendidas.
SELECT 
    p.codigo AS producto_codigo,
    p.nombre AS producto_nombre,
    SUM(dv.cantidad) AS unidades_vendidas
FROM ventas_normalizacion.detalle_venta dv
JOIN ventas_normalizacion.productos p ON dv.producto_id = p.producto_id
GROUP BY p.codigo, p.nombre
ORDER BY unidades_vendidas DESC;

-- 3. Ventas por vendedor.
-- Resultado esperado: vendedor_id, vendedor_nombre, cantidad_ventas, valor_total.
SELECT 
    ve.vendedor_id,
    ve.nombre AS vendedor_nombre,
    COUNT(DISTINCT v.venta_id) AS cantidad_ventas,
    SUM(dv.cantidad * dv.precio_unitario - dv.descuento) AS valor_total
FROM ventas_normalizacion.vendedores ve
JOIN ventas_normalizacion.ventas v ON ve.vendedor_id = v.vendedor_id
JOIN ventas_normalizacion.detalle_venta dv ON v.venta_id = dv.venta_id
GROUP BY ve.vendedor_id, ve.nombre
ORDER BY valor_total DESC;

-- 4. Historial de compras de un cliente especifico.
-- Resultado esperado: cliente_doc, cliente_nombre, venta_id, fecha_venta, producto, cantidad.
SELECT 
    c.doc AS cliente_doc,
    c.nombre AS cliente_nombre,
    v.venta_id,
    v.fecha AS fecha_venta,
    p.nombre AS producto,
    dv.cantidad
FROM ventas_normalizacion.clientes c
JOIN ventas_normalizacion.ventas v ON c.cliente_id = v.cliente_id
JOIN ventas_normalizacion.detalle_venta dv ON v.venta_id = dv.venta_id
JOIN ventas_normalizacion.productos p ON dv.producto_id = p.producto_id
WHERE c.doc = 'CC101'
ORDER BY v.fecha DESC, p.nombre;

-- 5. Control de integridad: detalles sin venta o sin producto.
-- Resultado esperado: cero registros huerfanos.
SELECT 
    (
        SELECT COUNT(*) 
        FROM ventas_normalizacion.detalle_venta 
        WHERE venta_id NOT IN (SELECT venta_id FROM ventas_normalizacion.ventas)
    ) AS huerfanos_sin_venta,
    (
        SELECT COUNT(*) 
        FROM ventas_normalizacion.detalle_venta 
        WHERE producto_id NOT IN (SELECT producto_id FROM ventas_normalizacion.productos)
    ) AS huerfanos_sin_producto;
