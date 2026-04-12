-- =============================================================
--  OPERACION SNOB ATTACK | Datos raw para normalizar
--  Objetivo: ganar cuota a Starbucks con cafe de especialidad
-- =============================================================
--
-- IMPORTANTE:
-- Este fichero NO trae modelo final normalizado.
-- Es un punto de partida intencionalmente desordenado para el reto.

DROP TABLE IF EXISTS ventas_cafe_raw;

CREATE TABLE ventas_cafe_raw (
    id_venta INTEGER,
    fecha_venta TEXT,
    id_cliente INTEGER,
    nombre_cliente TEXT,
    email_cliente TEXT,
    id_cafe INTEGER,
    nombre_cafe TEXT,
    origen_cafe TEXT,
    proceso_cafe TEXT,
    nivel_tueste TEXT,
    id_zona INTEGER,
    nombre_zona TEXT,
    canal_venta TEXT,
    formato_paquete TEXT,
    precio_unitario REAL,
    cantidad INTEGER,
    valoracion INTEGER,
    comentario_valoracion TEXT,
    total_venta REAL
);

INSERT INTO ventas_cafe_raw VALUES
(1001, '2026-02-07', 101, 'Aitana Suarez', 'aitana@tostador.local', 1, 'Colombia Huila', 'Colombia', 'Lavado', 'Medio', 1, 'Oviedo', 'tienda', '250g', 10.50, 2, 5, 'Muy equilibrado', 21.00),
(1001, '2026-02-07', 101, 'Aitana Suarez', 'aitana@tostador.local', 2, 'Etiopia Yirgacheffe', 'Etiopia', 'Lavado', 'Claro', 1, 'Oviedo', 'tienda', '250g', 12.00, 1, 5, 'Aromatico', 12.00),
(1002, '2026-02-07', 102, 'Bruno Mendez', 'bruno@tostador.local', 3, 'Brasil Cerrado', 'Brasil', 'Natural', 'Medio', 2, 'Gijon', 'online', '500g', 18.00, 1, 4, 'Buen cuerpo', 18.00),
(1003, '2026-02-14', 103, 'Carla Mier', 'carla@tostador.local', 2, 'Etiopia Yirgacheffe', 'Etiopia', 'Lavado', 'Claro', 3, 'Aviles', 'tienda', '250g', 12.00, 2, 5, 'Top para filtro', 24.00),
(1004, '2026-02-14', 104, 'Diego Alvarez', 'diego@tostador.local', 4, 'Guatemala Antigua', 'Guatemala', 'Honey', 'Medio-Oscuro', 4, 'Nava', 'online', '1kg', 30.00, 1, 4, 'Muy versatil', 30.00),
(1005, '2026-02-21', 105, 'Elena Ruiz', 'elena@tostador.local', 1, 'Colombia Huila', 'Colombia', 'Lavado', 'Medio', 5, 'Villaviciosa', 'tienda', '500g', 19.50, 1, 5, 'Mi favorito', 19.50),
(1005, '2026-02-21', 105, 'Elena Ruiz', 'elena@tostador.local', 5, 'Peru Cajamarca', 'Peru', 'Lavado', 'Claro', 5, 'Villaviciosa', 'tienda', '250g', 11.80, 1, 4, 'Suave y dulce', 11.80),
(1006, '2026-02-21', 106, 'Fabian Torre', 'fabian@tostador.local', 6, 'Kenia Nyeri', 'Kenia', 'Lavado', 'Claro', 6, 'Pola de Lena', 'online', '250g', 13.20, 2, 4, 'Acidez brillante', 26.40),
(1007, '2026-02-28', 107, 'Gabriela Coto', 'gabriela@tostador.local', 3, 'Brasil Cerrado', 'Brasil', 'Natural', 'Medio', 1, 'Oviedo', 'tienda', '250g', 9.80, 3, 3, 'Correcto', 29.40),
(1008, '2026-02-28', 108, 'Hector Solares', 'hector@tostador.local', 2, 'Etiopia Yirgacheffe', 'Etiopia', 'Lavado', 'Claro', 2, 'Gijon', 'online', '500g', 22.50, 1, 5, 'Muy floral', 22.50),
(1009, '2026-03-07', 109, 'Iria Pravia', 'iria@tostador.local', 5, 'Peru Cajamarca', 'Peru', 'Lavado', 'Claro', 4, 'Nava', 'tienda', '500g', 20.00, 1, 4, 'Dulce', 20.00),
(1010, '2026-03-07', 110, 'Jorge Cifuentes', 'jorge@tostador.local', 4, 'Guatemala Antigua', 'Guatemala', 'Honey', 'Medio-Oscuro', 5, 'Villaviciosa', 'online', '250g', 11.50, 2, 4, 'Chocolate', 23.00),
(1011, '2026-03-14', 101, 'Aitana Suarez', 'aitana@tostador.local', 6, 'Kenia Nyeri', 'Kenia', 'Lavado', 'Claro', 1, 'Oviedo', 'online', '500g', 24.00, 1, 5, 'Espectacular en V60', 24.00),
(1012, '2026-03-14', 103, 'Carla Mier', 'carla@tostador.local', 1, 'Colombia Huila', 'Colombia', 'Lavado', 'Medio', 3, 'Aviles', 'tienda', '250g', 10.50, 2, 5, 'Nunca falla', 21.00),
(1012, '2026-03-14', 103, 'Carla Mier', 'carla@tostador.local', 2, 'Etiopia Yirgacheffe', 'Etiopia', 'Lavado', 'Claro', 3, 'Aviles', 'tienda', '250g', 12.00, 1, 5, 'Aromatico', 12.00),
(1013, '2026-03-21', 108, 'Hector Solares', 'hector@tostador.local', 2, 'Etiopia Yirgacheffe', 'Etiopia', 'Lavado', 'Claro', 2, 'Gijon', 'online', '250g', 12.00, 2, 5, 'Muy floral', 24.00),
(1014, '2026-03-21', 110, 'Jorge Cifuentes', 'jorge@tostador.local', 1, 'Colombia Huila', 'Colombia', 'Lavado', 'Medio', 5, 'Villaviciosa', 'tienda', '500g', 19.50, 1, 5, 'Muy equilibrado', 19.50);

-- =============================================================
-- Escalado de volumen (nivel ideal de clase)
-- Genera 6 ciclos adicionales a partir de la base inicial:
-- 17 filas base + (17 x 6) = 119 filas en bruto.
-- =============================================================
WITH RECURSIVE ciclos(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM ciclos WHERE n < 6
)
INSERT INTO ventas_cafe_raw (
    id_venta,
    fecha_venta,
    id_cliente,
    nombre_cliente,
    email_cliente,
    id_cafe,
    nombre_cafe,
    origen_cafe,
    proceso_cafe,
    nivel_tueste,
    id_zona,
    nombre_zona,
    canal_venta,
    formato_paquete,
    precio_unitario,
    cantidad,
    valoracion,
    comentario_valoracion,
    total_venta
)
SELECT
    b.id_venta + (c.n * 1000) AS id_venta,
    date(b.fecha_venta, printf('+%d days', c.n * 7)) AS fecha_venta,
    b.id_cliente,
    b.nombre_cliente,
    b.email_cliente,
    b.id_cafe,
    b.nombre_cafe,
    b.origen_cafe,
    b.proceso_cafe,
    b.nivel_tueste,
    b.id_zona,
    b.nombre_zona,
    CASE WHEN ((b.id_venta + c.n) % 2) = 0 THEN 'online' ELSE 'tienda' END AS canal_venta,
    CASE ((b.id_cafe + c.n) % 3)
        WHEN 0 THEN '250g'
        WHEN 1 THEN '500g'
        ELSE '1kg'
    END AS formato_paquete,
    ROUND(b.precio_unitario * (1 + ((c.n % 3) * 0.03)), 2) AS precio_unitario,
    CASE WHEN (b.cantidad + (c.n % 2)) > 3 THEN 3 ELSE (b.cantidad + (c.n % 2)) END AS cantidad,
    CASE WHEN (b.valoracion + (c.n % 2)) > 5 THEN 5 ELSE (b.valoracion + (c.n % 2)) END AS valoracion,
    b.comentario_valoracion,
    ROUND(
        ROUND(b.precio_unitario * (1 + ((c.n % 3) * 0.03)), 2) *
        (CASE WHEN (b.cantidad + (c.n % 2)) > 3 THEN 3 ELSE (b.cantidad + (c.n % 2)) END),
        2
    ) AS total_venta
FROM ventas_cafe_raw b
CROSS JOIN ciclos c
WHERE b.id_venta BETWEEN 1001 AND 1014;

-- Pistas (sin solucion):
-- 1) Busca redundancias: cliente, cafe y zona se repiten muchas veces.
-- 2) Mira la clave candidata y decide si conviene separar cabecera/detalle.
-- 3) Ojo con dependencias funcionales tipo id_cafe -> nombre_cafe, origen_cafe...
-- 4) Ojo con dependencias tipo id_cliente -> nombre_cliente, email_cliente, id_zona.
-- 5) Si cambias una zona en muchas filas, tienes problema de actualizacion.

-- Comprobaciones utiles antes de empezar a normalizar:
-- SELECT COUNT(*) AS filas_raw FROM ventas_cafe_raw;
-- SELECT COUNT(DISTINCT id_venta) AS ventas_unicas_raw FROM ventas_cafe_raw;
-- SELECT ROUND(SUM(total_venta), 2) AS facturacion_raw FROM ventas_cafe_raw;