INSERT INTO cafe (id_cafe, nombre_cafe, origen_cafe, proceso_cafe, nivel_tueste)
SELECT DISTINCT id_cafe, nombre_cafe, origen_cafe, proceso_cafe, nivel_tueste
FROM ventas_cafe_raw;

INSERT INTO zona (id_zona, nombre_zona)
SELECT DISTINCT id_zona, nombre_zona
FROM ventas_cafe_raw;

INSERT INTO cliente (id_cliente, nombre_cliente, email_cliente, id_zona)
SELECT DISTINCT id_cliente, nombre_cliente, email_cliente, id_zona
FROM ventas_cafe_raw;

INSERT INTO venta (id_venta, fecha_venta, canal_venta, id_cliente)
SELECT DISTINCT id_venta, fecha_venta, canal_venta, id_cliente
FROM ventas_cafe_raw;

INSERT INTO valoraciones (id_venta, id_cafe, id_cliente, valoracion, comentario_valoracion)
SELECT DISTINCT id_venta, id_cafe, id_cliente, valoracion, comentario_valoracion
FROM ventas_cafe_raw;

INSERT INTO detalle_venta (id_venta, id_cafe, formato_paquete, precio_unitario, total_venta, cantidad)
SELECT DISTINCT id_venta, id_cafe, formato_paquete, precio_unitario, total_venta, cantidad
FROM ventas_cafe_raw;

UPDATE detalle_venta
SET formato_paquete = 
    CASE
        WHEN formato_paquete LIKE '%kg' THEN REPLACE(formato_paquete, 'kg', '') * 1000 || 'g'
        WHEN formato_paquete LIKE '%g'  THEN REPLACE(formato_paquete, 'g', '') || 'g'
    END;