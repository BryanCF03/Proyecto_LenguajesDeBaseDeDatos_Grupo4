-- ============================================================
-- Proyecto: La Esquinita del Pan | Grupo 4
-- Dilan Tenorio
-- Vistas_y_Cursores.sql
--  añadi 6 vistas de solo lectura y 9 cursores explicitos 
--  los 9 repartidos entre procedimientos y 3 funciones sueltas
-- falta para el ultimo avance crear la vistas, cursores y funciones restantes
-- compañeros pueden ejecutar este script con tranquilidad porque nada de este script modifica tablas ni procedimientos existentes;
-- es 100% aditivo a falta de tiempo y de que al que le tocaba no hizo su parte.
-- ============================================================
-- ================================================================
--Solo dependen de las tablas ya creadas
-- ================================================================

-- ================================================================
-- VISTAS
-- ================================================================
 
CREATE OR REPLACE VIEW VW_PROVEEDORES_ACTIVOS AS
SELECT p.ID_Proveedor, p.Nombre_Proveedor
FROM FIDE_Proveedores_TB p
WHERE p.ID_Estado = 1;
 
CREATE OR REPLACE VIEW VW_INSUMOS_STOCK AS
SELECT i.ID_Insumo, i.Nombre_Insumo, i.Stock, u.Nombre_Medida, c.Nombre_Categoria
FROM FIDE_Insumos_TB i
JOIN FIDE_Unidades_Medidas_TB u ON u.ID_Unidad_Medida = i.ID_Unidad_Medida
JOIN FIDE_Categorias_TB c ON c.ID_Categoria = i.ID_Categoria
WHERE i.ID_Estado = 1;
 
CREATE OR REPLACE VIEW VW_INVENTARIO_BAJO_STOCK AS
SELECT ii.ID_Inventario_Item,
       NVL(p.Nombre_Producto, i.Nombre_Insumo) AS Nombre_Item,
       ii.Stock, ii.Stock_Minimo
FROM FIDE_Inventario_Item_TB ii
LEFT JOIN FIDE_Productos_TB p ON p.ID_Producto = ii.ID_Producto
LEFT JOIN FIDE_Insumos_TB i ON i.ID_Insumo = ii.ID_Insumo
WHERE ii.Stock <= ii.Stock_Minimo AND ii.ID_Estado = 1;
 
CREATE OR REPLACE VIEW VW_PRODUCTOS_CATEGORIA AS
SELECT pr.ID_Producto, pr.Nombre_Producto, pr.Precio_Venta, c.Nombre_Categoria
FROM FIDE_Productos_TB pr
JOIN FIDE_Categorias_TB c ON c.ID_Categoria = pr.ID_Categoria
WHERE pr.ID_Estado = 1;
 
CREATE OR REPLACE VIEW VW_COMPRAS_DETALLE AS
SELECT c.ID_Compra, pr.Nombre_Proveedor, u.Nombre AS Nombre_Usuario,
       c.Fecha_Hora_Compra, c.Total_Compra
FROM FIDE_Compras_TB c
JOIN FIDE_Proveedores_TB pr ON pr.ID_Proveedor = c.ID_Proveedor
JOIN FIDE_Usuarios_TB u ON u.ID_Usuario = c.ID_Usuario;
 
CREATE OR REPLACE VIEW VW_VENTAS_DETALLE AS
SELECT v.ID_Venta, u.Nombre AS Nombre_Usuario, mp.Nombre_Metodo,
       v.Fecha_Hora_Venta, v.Total_Venta
FROM FIDE_Venta_TB v
JOIN FIDE_Usuarios_TB u ON u.ID_Usuario = v.ID_Usuario
JOIN FIDE_Metodos_Pago_TB mp ON mp.ID_Metodo_Pago = v.ID_Metodo_Pago;
 
 
-- ================================================================
-- FUNCIONES/ procedimientos con cursores
-- ================================================================
 
-- Cursor explicito 1: recorre categorias activas y usa la funcion
-- FIDE_TOTAL_PRODUCTOS_CATEGORIA_FN (ya existente) para contar
-- cuantos productos tiene cada una.
CREATE OR REPLACE PROCEDURE FIDE_REPORTE_PRODUCTOS_POR_CATEGORIA_SP
IS
    CURSOR c_categorias IS
        SELECT ID_Categoria, Nombre_Categoria
        FROM FIDE_Categorias_TB
        WHERE ID_Estado = 1;
    v_total NUMBER;
BEGIN
    FOR r_cat IN c_categorias LOOP
        v_total := FIDE_TOTAL_PRODUCTOS_CATEGORIA_FN(r_cat.ID_Categoria);
        DBMS_OUTPUT.PUT_LINE(r_cat.Nombre_Categoria || ': ' || v_total || ' producto(s)');
    END LOOP;
END FIDE_REPORTE_PRODUCTOS_POR_CATEGORIA_SP;
/
 
-- Cursor explicito 2: recorre unidades de medida activas y cuenta
-- cuantos insumos usan cada una.
CREATE OR REPLACE PROCEDURE FIDE_REPORTE_INSUMOS_POR_UNIDAD_SP
IS
    CURSOR c_unidades IS
        SELECT ID_Unidad_Medida, Nombre_Medida
        FROM FIDE_Unidades_Medidas_TB
        WHERE ID_Estado = 1;
    v_total NUMBER;
BEGIN
    FOR r_uni IN c_unidades LOOP
        SELECT COUNT(*) INTO v_total
        FROM FIDE_Insumos_TB
        WHERE ID_Unidad_Medida = r_uni.ID_Unidad_Medida;
        DBMS_OUTPUT.PUT_LINE(r_uni.Nombre_Medida || ': ' || v_total || ' insumo(s)');
    END LOOP;
END FIDE_REPORTE_INSUMOS_POR_UNIDAD_SP;
/
 
-- Cursor explicito 3: recorre los items de inventario cuyo stock ya
-- llego o esta por debajo del minimo, e imprime una alerta por cada uno.
CREATE OR REPLACE PROCEDURE FIDE_REPORTE_STOCK_BAJO_SP
IS
    CURSOR c_bajo_stock IS
        SELECT ii.ID_Inventario_Item,
               NVL(p.Nombre_Producto, i.Nombre_Insumo) AS Nombre_Item,
               ii.Stock, ii.Stock_Minimo
        FROM FIDE_Inventario_Item_TB ii
        LEFT JOIN FIDE_Productos_TB p ON p.ID_Producto = ii.ID_Producto
        LEFT JOIN FIDE_Insumos_TB i ON i.ID_Insumo = ii.ID_Insumo
        WHERE ii.Stock <= ii.Stock_Minimo AND ii.ID_Estado = 1;
BEGIN
    FOR r IN c_bajo_stock LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ALERTA: ' || r.Nombre_Item ||
            ' - Stock: ' || r.Stock || ' / Minimo: ' || r.Stock_Minimo
        );
    END LOOP;
END FIDE_REPORTE_STOCK_BAJO_SP;
/
 
-- Cursor explicito 4: calcula el valor total del inventario de insumos,
-- usando el precio promedio de compra de cada uno.
CREATE OR REPLACE FUNCTION FIDE_VALOR_TOTAL_INSUMOS_FN
RETURN NUMBER
IS
    v_total NUMBER := 0;
    v_costo_unit NUMBER;
    CURSOR c_insumos IS
        SELECT ID_Insumo, Stock FROM FIDE_Insumos_TB WHERE ID_Estado = 1;
BEGIN
    FOR r_ins IN c_insumos LOOP
        SELECT NVL(AVG(Precio_Unid), 0) INTO v_costo_unit
        FROM FIDE_Compras_Insumos_TB
        WHERE ID_Insumo = r_ins.ID_Insumo;
 
        v_total := v_total + (r_ins.Stock * v_costo_unit);
    END LOOP;
    RETURN v_total;
END FIDE_VALOR_TOTAL_INSUMOS_FN;
/
 
-- Cursor explicito 5: recorre los insumos de una receta para calcular
-- su costo total (cantidad x precio promedio de compra de cada insumo).
CREATE OR REPLACE FUNCTION FIDE_COSTO_RECETA_FN(p_ID_Receta IN NUMBER)
RETURN NUMBER
IS
    v_total NUMBER := 0;
    v_costo_unit NUMBER;
    CURSOR c_insumos IS
        SELECT ID_Insumo, Cantidades
        FROM FIDE_Receta_Insumo_TB
        WHERE ID_Receta = p_ID_Receta AND ID_Estado = 1;
BEGIN
    FOR r_insumo IN c_insumos LOOP
        SELECT NVL(AVG(Precio_Unid), 0) INTO v_costo_unit
        FROM FIDE_Compras_Insumos_TB
        WHERE ID_Insumo = r_insumo.ID_Insumo;
 
        v_total := v_total + (r_insumo.Cantidades * v_costo_unit);
    END LOOP;
    RETURN v_total;
END FIDE_COSTO_RECETA_FN;
/
 
-- Procedimiento de apoyo (SYS_REFCURSOR, no cuenta como cursor explicito,
-- pero se apoya en la funcion anterior para exponer recetas con su costo).
CREATE OR REPLACE PROCEDURE FIDE_LISTAR_RECETAS_CON_COSTO_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT r.ID_Receta, p.Nombre_Producto, r.Rendimiento,
               FIDE_COSTO_RECETA_FN(r.ID_Receta) AS Costo_Total
        FROM FIDE_Recetas_TB r
        JOIN FIDE_Productos_TB p ON p.ID_Producto = r.ID_Producto
        WHERE r.ID_Estado = 1;
END FIDE_LISTAR_RECETAS_CON_COSTO_SP;
/
 
-- Cursor explicito 6: al confirmar una orden de produccion, descuenta
-- del stock de insumos lo que se uso en la orden.
CREATE OR REPLACE PROCEDURE FIDE_DESCONTAR_INSUMOS_ORDEN_SP(p_ID_Orden_Produccion IN NUMBER)
IS
    CURSOR c_insumos_orden IS
        SELECT ID_Insumo, Cantidad_Usada
        FROM FIDE_Orden_Insumo_TB
        WHERE ID_Orden_Produccion = p_ID_Orden_Produccion;
BEGIN
    FOR r IN c_insumos_orden LOOP
        UPDATE FIDE_Insumos_TB
        SET Stock = Stock - r.Cantidad_Usada
        WHERE ID_Insumo = r.ID_Insumo;
    END LOOP;
    COMMIT;
END FIDE_DESCONTAR_INSUMOS_ORDEN_SP;
/
 
-- Cursor explicito 7: recorre usuarios activos y cuenta cuantas
-- ordenes de produccion ha generado cada uno.
CREATE OR REPLACE PROCEDURE FIDE_REPORTE_ORDENES_POR_USUARIO_SP
IS
    CURSOR c_usuarios IS
        SELECT ID_Usuario, Nombre FROM FIDE_Usuarios_TB WHERE ID_Estado = 1;
    v_total NUMBER;
BEGIN
    FOR r_usr IN c_usuarios LOOP
        SELECT COUNT(*) INTO v_total
        FROM FIDE_Orden_Produccion_TB
        WHERE ID_Usuario = r_usr.ID_Usuario;
        DBMS_OUTPUT.PUT_LINE(r_usr.Nombre || ': ' || v_total || ' orden(es)');
    END LOOP;
END FIDE_REPORTE_ORDENES_POR_USUARIO_SP;
/
 
-- Cursor explicito 8: al confirmar una venta, descuenta el stock
-- de cada producto vendido.
CREATE OR REPLACE PROCEDURE FIDE_DESCONTAR_STOCK_VENTA_SP(p_ID_Venta IN NUMBER)
IS
    CURSOR c_productos_venta IS
        SELECT ID_Producto, Cantidad
        FROM FIDE_Venta_Productos_TB
        WHERE ID_Venta = p_ID_Venta;
BEGIN
    FOR r IN c_productos_venta LOOP
        UPDATE FIDE_Inventario_Item_TB
        SET Stock = Stock - r.Cantidad
        WHERE ID_Producto = r.ID_Producto;
    END LOOP;
    COMMIT;
END FIDE_DESCONTAR_STOCK_VENTA_SP;
/
 
-- Cursor explicito 9: recorre metodos de pago activos y suma el total
-- vendido con cada uno.
CREATE OR REPLACE PROCEDURE FIDE_REPORTE_VENTAS_POR_METODO_PAGO_SP
IS
    CURSOR c_metodos IS
        SELECT ID_Metodo_Pago, Nombre_Metodo
        FROM FIDE_Metodos_Pago_TB
        WHERE ID_Estado = 1;
    v_total NUMBER;
BEGIN
    FOR r_met IN c_metodos LOOP
        SELECT NVL(SUM(Total_Venta), 0) INTO v_total
        FROM FIDE_Venta_TB
        WHERE ID_Metodo_Pago = r_met.ID_Metodo_Pago;
        DBMS_OUTPUT.PUT_LINE(r_met.Nombre_Metodo || ': ' || v_total);
    END LOOP;
END FIDE_REPORTE_VENTAS_POR_METODO_PAGO_SP;
/
 
-- Funcion adicional (no usa cursor, pero suma funciones al total)
CREATE OR REPLACE FUNCTION FIDE_TOTAL_VENTAS_DIA_FN(p_Fecha IN DATE)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(Total_Venta), 0) INTO v_total
    FROM FIDE_Venta_TB
    WHERE TRUNC(Fecha_Hora_Venta) = TRUNC(p_Fecha);
    RETURN v_total;
END FIDE_TOTAL_VENTAS_DIA_FN;
/

