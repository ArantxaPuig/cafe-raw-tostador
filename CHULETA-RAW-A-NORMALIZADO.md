# Chuleta - Metodo General De RAW A Normalizado

Objetivo: pasar de una tabla desordenada (`ventas_cafe_raw`) a un modelo relacional en 3FN sin perder informacion.

## 0) Regla de oro

`CREATE TABLE` define estructura, pero NO mueve datos.
Para poblar tablas: `INSERT INTO ... SELECT ...`.

## 1) Foto inicial del RAW (checkpoint)

Guarda estas metricas antes de transformar:

```sql
SELECT COUNT(*) AS filas_raw FROM ventas_cafe_raw;
SELECT COUNT(DISTINCT id_venta) AS ventas_unicas_raw FROM ventas_cafe_raw;
SELECT ROUND(SUM(total_venta), 2) AS facturacion_raw FROM ventas_cafe_raw;
```

## 2) Decide entidades (sin copiar recetas)

Pregunta base: "Que bloques de informacion se repiten en el raw?"

Piensalo asi (version facil):
1. cosas que describen "quien" o "que" (por ejemplo clientes, productos, zonas),
2. la venta principal (id, fecha, canal),
3. las lineas de esa venta (producto, cantidad, precio),
4. datos extra si hacen falta (por ejemplo valoraciones).

No hace falta acertar a la primera.
Lo importante es separar lo que se repite para evitar duplicados.

## 3) Patron SQL minimo que siempre funciona

### 3.1 Crear tablas

```sql
CREATE TABLE entidad_maestra_A (
  id_A INTEGER PRIMARY KEY,
  atributo_A1 TEXT,
  atributo_A2 TEXT
);

CREATE TABLE entidad_evento (
  id_evento INTEGER PRIMARY KEY,
  fecha_evento TEXT,
  id_A INTEGER,
  FOREIGN KEY (id_A) REFERENCES entidad_maestra_A(id_A)
);

CREATE TABLE entidad_detalle (
  id_evento INTEGER,
  id_item INTEGER,
  atributo_detalle TEXT,
  cantidad INTEGER,
  PRIMARY KEY (id_evento, id_item),
  FOREIGN KEY (id_evento) REFERENCES entidad_evento(id_evento)
);
```

### 3.2 Poblar maestras (evitar duplicados)

```sql
INSERT INTO entidad_maestra_A (id_A, atributo_A1, atributo_A2)
SELECT DISTINCT campo_id_A, campo_A1, campo_A2
FROM ventas_cafe_raw;
```

### 3.3 Poblar cabecera y detalle

```sql
INSERT INTO entidad_evento (id_evento, fecha_evento, id_A)
SELECT DISTINCT id_venta, fecha_venta, campo_id_A
FROM ventas_cafe_raw;

INSERT INTO entidad_detalle (id_evento, id_item, atributo_detalle, cantidad)
SELECT id_venta, campo_id_item, campo_detalle, campo_cantidad
FROM ventas_cafe_raw;
```

## 4) Validacion anti-perdida (obligatoria)

Despues de normalizar, compara con los checkpoints del raw:

```sql
-- Debe cuadrar con filas_raw (o justificar diferencia)
SELECT COUNT(*) AS filas_normalizadas_desde_detalle
FROM entidad_detalle;

-- Debe cuadrar con ventas_unicas_raw
SELECT COUNT(*) AS eventos_unicos_normalizado
FROM entidad_evento;

-- Debe cuadrar con facturacion_raw (si has guardado total_linea)
SELECT ROUND(SUM(total_linea), 2) AS facturacion_normalizada
FROM entidad_detalle;
```

Si no coincide, revisa:
1. `DISTINCT` faltante o mal colocado,
2. duplicados por joins,
3. campos calculados inconsistentes.

## 5) Criterio para saber si vais bien (3FN)

1. Cada atributo depende de su clave, no de otra columna no-clave.
2. No guardas el mismo dato maestro repetido en mil filas de detalle.
3. Puedes insertar un dato maestro sin crear una venta falsa.
4. Al borrar una venta no pierdes catalogos.

## 6) Entregable minimo

1. Script de creacion de tablas.
2. Script de carga (`INSERT ... SELECT`).
3. Script de comprobacion de metricas.
4. 4 consultas de negocio sobre el modelo final.
