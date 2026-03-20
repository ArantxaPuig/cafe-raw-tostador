---1. 6 problemas de diseno o calidad de dato.
-- Redundancia de datos: La columna de origen_cafe da la misma informacion que nombre_cafe
-- El formato_paquete esta en formato texto, y no se pueden hacer cálculos con ellos.
-- El precio_unitario del cafe es diferente segun la venta, siendo el mismo formato_paquete y misma zona. No sabemos si ha habido ofertas (nos falta informacion)
-- Si queremos ampliar el negocio, será antes de empezar las ventas, y no podemos añadir zonas sin ventas.
-- La columna comentario_valoracion y valoracion es subjetiva, y no hay ninguna relación entre ellas 
--(a mismo cafe y mismo cliente, diferentes valoraciones segun canal de venta). Ademas, ¿es necesario hacer una valoracion por cada compra del mismo cafe?
-- Las valoraciones son diferentes si la venta es online o en tienda, pero lo que se valora es el cafe. El campo valoracion es de poca calidad.

--- 2. 1 anomalia de insercion.
-- No podemos añadir un nuevo cafe si no hacemos una venta

--- 3. 1 anomalia de actualizacion.
-- No podemos actualizar un email si no cambiamos todas las celdas donde aparece ese email

--- 4. 1 anomalia de borrado.
-- Si eliminamos un cafe (por ejemplo, porque no se vende), se nos borraran datos de ventas que nos pueden servir.



--- Los 5 cafes con mayor facturacion.

SELECT c.id_cafe, c.nombre_cafe, SUM(dv.total_venta)
FROM detalle_venta AS dv
INNER JOIN cafe as c
	ON c.id_cafe = dv.id_cafe
GROUP BY nombre_cafe
ORDER BY SUM(dv.total_venta) DESC
LIMIT 5;

-- Zonas con mayor volumen de ventas (por total de ventas).

SELECT z.id_zona, z.nombre_zona AS Ciudad, SUM(dv.total_venta) AS Ventas
FROM zona as z
INNER JOIN cliente as cl
	ON z.id_zona = cl.id_zona
INNER JOIN venta as v
	ON cl.id_cliente = v.id_cliente
INNER JOIN detalle_venta as dv
	ON v.id_venta = dv.id_venta
GROUP BY nombre_zona
ORDER BY SUM(dv.total_venta) DESC;

-- Zonas con mayor volumen de ventas (por unidades).

SELECT z.id_zona, z.nombre_zona, SUM(dv.cantidad) AS unidades
FROM zona as z
INNER JOIN detalle_venta as dv
	ON z.id_zona = c.id_zona
INNER JOIN cliente as c
	ON c.id_cliente = v.id_cliente
INNER JOIN venta as v
	ON v.id_venta = dv.id_venta
GROUP BY nombre_zona
ORDER BY SUM(dv.cantidad) DESC;

-- Top 3 cafes por valoracion media (minimo 3 valoraciones)

SELECT c.nombre_cafe,
		ROUND(AVG(val.valoracion), 2) AS valoracion_media,
		COUNT(*) AS numero_valoraciones
FROM valoraciones AS val
JOIN cafe AS c ON val.id_cafe = c.id_cafe
GROUP BY c.nombre_cafe
HAVING COUNT(*) >= 3
ORDER BY valoracion_media DESC
LIMIT 3;

-- Ticket medio por canal (`tienda` vs `online`).

SELECT v.canal_venta,
	ROUND(SUM(dv.cantidad * dv.precio_unitario) / COUNT(DISTINCT v.id_venta), 2)
	AS ticket_medio
FROM venta AS v
JOIN detalle_venta AS dv ON v.id_venta = dv.id_venta
GROUP BY v.canal_venta;


-- Consulta libre: recomendacion de cafe para "snobs" (ventas + valoracion).

SELECT c.nombre_cafe, dv.formato_paquete,
	COUNT(dv.cantidad) AS "cantidad",
	ROUND(AVG(v.valoracion),2) AS "valoracion media"
FROM detalle_venta dv INNER JOIN cafe c
	ON dv.id_cafe = c.id_cafe
INNER JOIN valoraciones v
	ON c.id_cafe =  v.id_cafe
GROUP BY c.nombre_cafe
ORDER BY "cantidad" DESC,"valoracion media" DESC
LIMIT 3;

-- Consulta libre: top 5 de clientes que mas compran:

SELECT cl.id_cliente,
       cl.nombre_cliente,
       SUM(dv.cantidad * dv.precio_unitario) AS total_gastado
FROM cliente AS cl
JOIN venta AS v ON cl.id_cliente = v.id_cliente
JOIN detalle_venta AS dv ON v.id_venta = dv.id_venta
GROUP BY cl.id_cliente, cl.nombre_cliente
ORDER BY total_gastado DESC
LIMIT 5;