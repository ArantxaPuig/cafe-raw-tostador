-- FOTO ESTADO INICIAL:

SELECT COUNT(*) AS filas_raw FROM ventas_cafe_raw; --119
SELECT COUNT(DISTINCT id_venta) AS ventas_unicas_raw FROM ventas_cafe_raw; --98
SELECT ROUND(SUM(total_venta), 2) AS facturacion_raw FROM ventas_cafe_raw; --3371.48

--BORRAR en orden inverso (primero las que dependen de otras) (Por segunda creación)
DROP TABLE IF EXISTS valoraciones;
DROP TABLE IF EXISTS detalle_venta;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS cafes;
DROP TABLE IF EXISTS zonas;


-- CREAR TABLAS
-- 1. ZONAS
CREATE TABLE zonas (
  id_zona INTEGER PRIMARY KEY,
  nombre_zona TEXT
);

-- 2. CAFES
CREATE TABLE cafes (
  id_cafe INTEGER PRIMARY KEY,
  nombre_cafe  TEXT,
  origen_cafe  TEXT,
  proceso_cafe TEXT,
  nivel_tueste TEXT
);

-- 3. CLIENTES (depende de zonas)
CREATE TABLE clientes (
  id_cliente INTEGER PRIMARY KEY,
  nombre_cliente TEXT,
  email_cliente  TEXT,
  id_zona INTEGER,
  FOREIGN KEY (id_zona) REFERENCES zonas(id_zona)
);

-- 4. VENTAS (depende de clientes)
CREATE TABLE ventas (
  id_venta INTEGER PRIMARY KEY,
  fecha_venta TEXT,
  canal_venta TEXT,
  id_cliente INTEGER,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- 5. DETALLE_VENTA (depende de ventas y cafes)
CREATE TABLE detalle_venta (
  id_venta INTEGER,
  id_cafe INTEGER,
  formato_paquete TEXT,
  precio_unitario REAL,
  cantidad INTEGER,
  total_venta REAL,
  PRIMARY KEY (id_venta, id_cafe),
  FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
  FOREIGN KEY (id_cafe)  REFERENCES cafes(id_cafe)
);

-- 6. VALORACIONES (depende de ventas, cafes y clientes)
CREATE TABLE valoraciones (
  id_venta INTEGER,
  id_cafe INTEGER,
  id_cliente INTEGER,
  valoracion INTEGER,
  comentario_valoracion TEXT,
  PRIMARY KEY (id_venta, id_cafe),
  FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
  FOREIGN KEY (id_cafe) REFERENCES cafes(id_cafe),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

---POBLAR TABLAS
--DISTINCT TABLAS MAESTRAS

-- 1. Poblar zonas
INSERT INTO zonas (id_zona, nombre_zona)
SELECT DISTINCT id_zona, nombre_zona
FROM ventas_cafe_raw;

-- 2. Poblar cafes
INSERT INTO cafes (id_cafe, nombre_cafe, origen_cafe, proceso_cafe, nivel_tueste)
SELECT DISTINCT id_cafe, nombre_cafe, origen_cafe, proceso_cafe, nivel_tueste
FROM ventas_cafe_raw;

-- 3. Poblar clientes
INSERT INTO clientes (id_cliente, nombre_cliente, email_cliente, id_zona)
SELECT DISTINCT id_cliente, nombre_cliente, email_cliente, id_zona
FROM ventas_cafe_raw;

-- 4. Poblar ventas
INSERT INTO ventas (id_venta, fecha_venta, canal_venta, id_cliente)
SELECT DISTINCT id_venta, fecha_venta, canal_venta, id_cliente
FROM ventas_cafe_raw;

-- 5. Poblar detalle_venta
INSERT INTO detalle_venta (id_venta, id_cafe, formato_paquete, precio_unitario, cantidad, total_venta)
SELECT id_venta, id_cafe, formato_paquete, precio_unitario, cantidad, total_venta
FROM ventas_cafe_raw;

-- 6. Poblar valoraciones
INSERT INTO valoraciones (id_venta, id_cafe, id_cliente, valoracion, comentario_valoracion)
SELECT DISTINCT id_venta, id_cafe, id_cliente, valoracion, comentario_valoracion
FROM ventas_cafe_raw;


--- VALIDACION ANTI-PERDIDA
SELECT COUNT(*) AS filas_normalizado FROM detalle_venta;
SELECT COUNT(*) AS ventas_unicas FROM ventas;
SELECT ROUND(SUM(total_venta), 2) AS facturacion_normalizada FROM detalle_venta;

-- 119 filas → no perdimos ninguna línea de venta.
-- 98 ventas únicas → ningún pedido se duplicó ni se perdió.
-- 3371.48 € → la facturación es idéntica.

--- Los 5 cafes con mayor facturacion
-- En la tabla cafe añadimos columna suma en tabla de ventas

SELECT c.id_cafe, c.nombre_cafe, SUM(dv.total_venta)
FROM detalle_venta AS dv
INNER JOIN cafes as c
	ON c.id_cafe = dv.id_cafe
GROUP BY nombre_cafe
ORDER BY SUM(dv.total_venta) DESC
LIMiT 5;

-- Zonas con mayor volumen de ventas.

SELECT z.id_zona, z.nombre_zona, SUM(dv.cantidad) AS unidades
FROM zonas as z
INNER JOIN clientes as cl
	ON z.id_zona = cl.id_zona
INNER JOIN ventas as v
	ON cl.id_cliente = v.id_cliente
INNER JOIN detalle_venta as dv
	ON v.id_venta = dv.id_venta
GROUP BY nombre_zona
ORDER BY SUM(dv.cantidad) DESC;

-- Cafes por valoracion media (minimo 3 valoraciones).
SELECT v.canal_venta,
	ROUND(SUM(dv.cantidad * dv.precio_unitario) /
	COUNT(DISTINCT v.id_venta), 2)
	AS ticket_medio
FROM ventas AS v
JOIN detalle_venta AS dv ON v.id_venta = dv.id_venta
GROUP BY v.canal_venta;

-- Ticket medio por canal (`tienda` vs `online`).

SELECT v.canal_venta,
    ROUND(
        SUM(dv.cantidad * dv.precio_unitario) / COUNT(DISTINCT v.id_venta),
        2
    ) AS ticket_medio
FROM ventas AS v
JOIN detalle_venta AS dv ON v.id_venta = dv.id_venta
GROUP BY v.canal_venta;

--- Consulta libre: recomendacion de cafe para "snobs" (ventas + valoracion).
-- NOT IN ('Brasil', 'Colombia') — filtra los orígenes más comunes, se queda con los exóticos.
-- HAVING COUNT >= 3 — solo cafés con suficientes valoraciones para ser fiables.
-- ORDER BY valoracion_media DESC, veces_vendido DESC — primero los mejor valorados, si empatan gana el más vendido.

SELECT 
    c.nombre_cafe,
    c.origen_cafe,
    c.proceso_cafe,
    c.nivel_tueste,
    ROUND(AVG(val.valoracion), 2) AS valoracion_media,
    COUNT(DISTINCT dv.id_venta) AS veces_vendido
FROM cafes c
JOIN detalle_venta dv ON c.id_cafe = dv.id_cafe
JOIN valoraciones val ON val.id_cafe = c.id_cafe 
    AND val.id_venta = dv.id_venta
WHERE c.origen_cafe NOT IN ('Brasil', 'Colombia')
GROUP BY c.nombre_cafe
HAVING COUNT(val.valoracion) >= 3
ORDER BY valoracion_media DESC, veces_vendido DESC
LIMIT 3;

--- Clientes online vs tienda
-- CASE WHEN — es un if/else en SQL. Cuenta las compras online y tienda por separado para cada cliente.
-- perfil_cliente — clasifica a cada cliente en solo tienda, solo online, o ambos canales.

SELECT 
    cl.nombre_cliente,
    COUNT(DISTINCT CASE WHEN v.canal_venta = 'online' THEN v.id_venta END) AS compras_online,
    COUNT(DISTINCT CASE WHEN v.canal_venta = 'tienda' THEN v.id_venta END) AS compras_tienda,
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN v.canal_venta = 'online' THEN v.id_venta END) = 0 
            THEN 'solo tienda'
        WHEN COUNT(DISTINCT CASE WHEN v.canal_venta = 'tienda' THEN v.id_venta END) = 0 
            THEN 'solo online'
        ELSE 'ambos canales'
    END AS perfil_cliente
FROM clientes cl
JOIN ventas v ON cl.id_cliente = v.id_cliente
GROUP BY cl.nombre_cliente
ORDER BY perfil_cliente;

