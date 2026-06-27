SET search_path TO ventas_normalizacion;

TRUNCATE TABLE detalle_venta, ventas, productos, categorias, vendedores, clientes RESTART IDENTITY CASCADE;

INSERT INTO clientes (doc, nombre, email, telefono, direccion, ciudad) VALUES
('CC101', 'Maria Gomez', 'maria.gomez@mail.com', '3101112233', 'Calle 10 # 5-20', 'Bogota'),
('CC102', 'Juan Perez', 'juan.perez@mail.com', '3155558899', 'Carrera 8 # 20-15', 'Bogota'),
('CC103', 'Laura Rojas', 'laura.rojas@mail.com', '3209994455', 'Av. 68 # 45-30', 'Medellin');

INSERT INTO vendedores (vendedor_id, nombre, zona) VALUES
('VEN01', 'Ana Torres', 'Norte'),
('VEN02', 'Carlos Ruiz', 'Centro'),
('VEN03', 'Diana Mora', 'Occidente');

INSERT INTO categorias (nombre) VALUES
('Perifericos'),
('Pantallas'),
('Computadores'),
('Accesorios');

INSERT INTO productos (codigo, nombre, categoria_id) VALUES
('P001', 'Mouse USB', 1),
('P002', 'Teclado mecanico', 1),
('P003', 'Monitor 24', 2),
('P004', 'Portatil 14', 3),
('P005', 'Base refrigerante', 4),
('P006', 'Webcam HD', 1);

INSERT INTO ventas (venta_id, fecha, cliente_id, vendedor_id, metodo_pago, entidad_pago) VALUES
('V1001', '2026-04-01', 1, 'VEN01', 'Transferencia', 'Bancolombia'),
('V1002', '2026-04-02', 2, 'VEN02', 'Tarjeta credito', 'Visa'),
('V1003', '2026-04-03', 1, 'VEN01', 'Transferencia', 'Bancolombia'),
('V1004', '2026-04-04', 3, 'VEN03', 'Efectivo', 'Caja principal');

INSERT INTO detalle_venta (venta_id, producto_id, cantidad, precio_unitario, descuento) VALUES
('V1001', 1, 2, 45000, 0),
('V1001', 2, 1, 180000, 0),
('V1002', 3, 1, 720000, 20000),
('V1002', 1, 1, 45000, 0),
('V1003', 4, 1, 2450000, 50000),
('V1003', 2, 2, 180000, 0),
('V1003', 5, 1, 95000, 0),
('V1004', 3, 2, 720000, 0),
('V1004', 6, 1, 150000, 10000);
