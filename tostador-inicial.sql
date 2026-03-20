SELECT COUNT(*) AS filas_raw FROM ventas_cafe_raw;

SELECT COUNT(DISTINCT id_venta) 
AS ventas_unicas_raw 
FROM ventas_cafe_raw;

SELECT ROUND(SUM(total_venta), 2) 
AS facturacion_raw 
FROM ventas_cafe_raw;

SELECT COUNT(*) AS filas_normalizado
FROM detalle_venta;

SELECT COUNT(*) AS id_venta
FROM venta;

SELECT ROUND(SUM(total_venta), 2) AS facturacion_normalizada
FROM detalle_venta;