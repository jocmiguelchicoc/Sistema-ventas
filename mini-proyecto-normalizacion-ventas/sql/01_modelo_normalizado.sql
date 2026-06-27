-- Crear esquema
CREATE SCHEMA IF NOT EXISTS ventas_normalizacion;
SET search_path TO ventas_normalizacion;

DROP TABLE IF EXISTS detalle_venta CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS vendedores CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- Tabla clientes
CREATE TABLE clientes (
    cliente_id SERIAL,
    doc        VARCHAR(20) NOT NULL,
    nombre     VARCHAR(100) NOT NULL,
    email      VARCHAR(120) NOT NULL,
    telefono   VARCHAR(30),
    direccion  VARCHAR(150),
    ciudad     VARCHAR(80) NOT NULL,
    CONSTRAINT pk_clientes PRIMARY KEY (cliente_id),
    CONSTRAINT uq_cliente_doc UNIQUE (doc),
    CONSTRAINT uq_cliente_email UNIQUE (email)
);

-- Tabla vendedores
CREATE TABLE vendedores (
    vendedor_id VARCHAR(10),
    nombre      VARCHAR(100) NOT NULL,
    zona        VARCHAR(80) NOT NULL,
    CONSTRAINT pk_vendedores PRIMARY KEY (vendedor_id)
);

-- Tabla categorias
CREATE TABLE categorias (
    categoria_id SERIAL,
    nombre       VARCHAR(100) NOT NULL,
    CONSTRAINT pk_categorias PRIMARY KEY (categoria_id),
    CONSTRAINT uq_categoria_nombre UNIQUE (nombre)
);

-- Tabla productos
CREATE TABLE productos (
    producto_id  SERIAL,
    codigo       VARCHAR(10) NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    categoria_id INT NOT NULL,
    CONSTRAINT pk_productos PRIMARY KEY (producto_id),
    CONSTRAINT uq_producto_codigo UNIQUE (codigo),
    CONSTRAINT fk_productos_categorias FOREIGN KEY (categoria_id) 
        REFERENCES categorias(categoria_id) ON DELETE RESTRICT
);

-- Tabla ventas
CREATE TABLE ventas (
    venta_id     VARCHAR(10),
    fecha        DATE NOT NULL,
    cliente_id   INT NOT NULL,
    vendedor_id  VARCHAR(10) NOT NULL,
    metodo_pago  VARCHAR(80) NOT NULL,
    entidad_pago VARCHAR(80) NOT NULL,
    CONSTRAINT pk_ventas PRIMARY KEY (venta_id),
    CONSTRAINT fk_ventas_clientes FOREIGN KEY (cliente_id) 
        REFERENCES clientes(cliente_id) ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_vendedores FOREIGN KEY (vendedor_id) 
        REFERENCES vendedores(vendedor_id) ON DELETE RESTRICT
);

-- Tabla detalle_venta
CREATE TABLE detalle_venta (
    venta_id        VARCHAR(10) NOT NULL,
    producto_id     INT NOT NULL,
    cantidad        INT NOT NULL,
    precio_unitario INT NOT NULL,
    descuento       INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_detalle_venta PRIMARY KEY (venta_id, producto_id),
    CONSTRAINT fk_detalle_venta_ventas FOREIGN KEY (venta_id) 
        REFERENCES ventas(venta_id) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_venta_productos FOREIGN KEY (producto_id) 
        REFERENCES productos(producto_id) ON DELETE RESTRICT,
    CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT chk_precio_no_negativo CHECK (precio_unitario >= 0),
    CONSTRAINT chk_descuento_no_negativo CHECK (descuento >= 0)
);
