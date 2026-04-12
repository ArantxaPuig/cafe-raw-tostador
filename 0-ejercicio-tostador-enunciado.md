# Ejercicio Viernes - Operacion "Snob Attack"

## Contexto (la historia)

Sois el equipo de datos de una marca de cafe de especialidad que quiere romper el mercado.
No queremos ser "otro cafe mas": queremos ser la referencia absoluta para gente exigente que ya no soporta el cafe plano de cadenas masivas.

Y si hace falta una referencia de exigencia: nuestra profe, que no soporta torrefactos ni cafes con notas a quemado.

Mision: convertirnos en el distribuidor numero 1 para amantes del cafe premium y destronar el "siempre lo mismo" con datos, estrategia y calidad real.

El reto no es solo vender mas.
El reto es vender mejor: el origen correcto, el tueste correcto, al cliente correcto.

Nuestra propuesta de valor:

1. mejores origenes,
2. tostado mas adecuado para cada cafe,
3. calidad alta y consistente.

Problema: los datos vienen en bruto y con caos.
Si el modelo es malo, tomaremos decisiones malas y perderemos ventaja frente a la competencia.

## Objetivo del reto

No se trata de ejecutar queries sobre un modelo ya limpio.
Se trata de construir ese modelo vosotras:

1. detectar problemas en los datos en bruto,
2. normalizar hasta 3FN,
3. responder preguntas de negocio con SQL.

## Nota importante (para no mezclar conceptos)

Mañana trabajamos solo en entorno relacional (SQLite + DB Browser).
No hay que cargar ni transformar CSV en clase.
El punto de partida ya viene en la tabla `ventas_cafe_raw` dentro de `tostador-cafe-raw.db`.

## Material que teneis

1. `TOSTADOR-CAFE-RAW-RETO.sql` (tabla desnormalizada + datos).
2. `tostador-cafe-raw.db` (la misma info, lista para abrir en DB Browser).
3. Esta guia de reto.

## Mini glosario (por si ayuda)

- `raw` = datos en bruto.
- `insight` = conclusion accionable para negocio.
- `ticket medio` = gasto medio por venta.
- `top 5` = los 5 primeros segun un criterio.

## Parte A - Diagnostico

Sobre `ventas_cafe_raw`, detectad al menos:

1. 6 problemas de diseno o calidad de dato.
-- Redundancia de datos: La columna de origen_cafe da la misma informacion que nombre_cafe
-- El formato_paquete esta en formato texto, y no se pueden hacer cálculos con ellos.
-- El precio_unitario del cafe es diferente segun la venta, siendo el mismo formato_paquete y misma zona. No sabemos si ha habido ofertas.
2. 1 anomalia de insercion.
-- No podemos añadir un nuevo cafe si no hacemos una venta
3. 1 anomalia de actualizacion.
-- No podemos actualizar un email si no cambiamos todas las celdas donde aparece ese email
4. 1 anomalia de borrado. ---1. 6 problemas de diseno o calidad de dato.
-- Si eliminamos un cafe (por ejemplo, porque no se vende), se nos borraran datos de ventas que nos pueden servir.


## Parte B - Normalizacion

1. Propuesta de tablas finales (PK y FK claras).
2. Paso por 1FN, 2FN, 3FN con explicacion corta.
3. Diagrama simple de relaciones (texto o dibujo rapido).

### Protocolo anti-perdida de datos (obligatorio)

Antes de transformar, guarda estos 3 numeros del raw:

1. total de filas,
2. total de ventas unicas (`id_venta`),
3. facturacion total (`SUM(total_venta)`).

Despues de normalizar, comprobad que podeis reconstruir esos totales con `JOIN` entre vuestras tablas.
Si no coincide, hay datos perdidos o duplicados en la transformacion.

Objetivo: normalizar SI, pero sin romper trazabilidad.

## Parte C - SQL de negocio

Con vuestro modelo final, resolved:

1. Los 5 cafes con mayor facturacion.
2. Zonas con mayor volumen de ventas.
3. Top 3 cafes por valoracion media (minimo 3 valoraciones).
4. Ticket medio por canal (`tienda` vs `online`).
5. Consulta libre: recomendacion de cafe para "snobs" (ventas + valoracion).

## Pista pro

No gana quien haga la query mas larga.
Gana quien conecte mejor: dato en bruto -> modelo limpio -> decision real.