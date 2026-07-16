-- Proyecto: La Esquinita del Pan | Grupo 4 | Funciones
-- ============================================================
--Dilan Tenorio Rojas
--CALVO HERRA LUIS ESTEBAN
--CARVAJAL FLORES BRYAN ALBERTO
--CORDERO GARCIA BRYAN STEVEN
--VELASQUEZ MORALES EDUARDO JOSE
-- ============================================================
-- 1. Obtener ID de estado de un usuario
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_ESTADO_USUARIO_FN(p_ID_Usuario IN NUMBER)
RETURN NUMBER
IS
    v_Estado NUMBER;
BEGIN
    SELECT ID_Estado INTO v_Estado
    FROM FIDE_Usuarios_TB
    WHERE ID_Usuario = p_ID_Usuario;
    RETURN v_Estado;
END;
/

-- 2. Obtener categoría de un producto
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_CATEGORIA_PRODUCTO_FN(p_ID_Producto IN NUMBER)
RETURN NUMBER
IS
    v_Categoria NUMBER;
BEGIN
    SELECT ID_Categoria INTO v_Categoria
    FROM FIDE_Productos_TB
    WHERE ID_Producto = p_ID_Producto;
    RETURN v_Categoria;
END;
/

-- 3. Obtener proveedor de una compra
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_PROVEEDOR_COMPRA_FN(p_ID_Compra IN NUMBER)
RETURN NUMBER
IS
    v_Proveedor NUMBER;
BEGIN
    SELECT ID_Proveedor INTO v_Proveedor
    FROM FIDE_Compras_TB
    WHERE ID_Compra = p_ID_Compra;
    RETURN v_Proveedor;
END;
/

-- 4. Stock total de un producto
CREATE OR REPLACE FUNCTION FIDE_STOCK_PRODUCTO_FN(p_ID_Producto IN NUMBER)
RETURN NUMBER
IS
    v_Stock NUMBER;
BEGIN
    SELECT NVL(SUM(Stock), 0) INTO v_Stock
    FROM FIDE_Inventario_Item_TB
    WHERE ID_Producto = p_ID_Producto;
    RETURN v_Stock;
END;
/

-- 5. Total de productos en una venta
CREATE OR REPLACE FUNCTION FIDE_TOTAL_PRODUCTOS_VENTA_FN(p_ID_Venta IN NUMBER)
RETURN NUMBER
IS
    v_Total NUMBER;
BEGIN
    SELECT NVL(SUM(Cantidad), 0) INTO v_Total
    FROM FIDE_Venta_Productos_TB
    WHERE ID_Venta = p_ID_Venta;
    RETURN v_Total;
END;
/

-- 6. Total de facturación por venta
CREATE OR REPLACE FUNCTION FIDE_TOTAL_FACTURA_FN(p_ID_Venta IN NUMBER)
RETURN NUMBER
IS
    v_Total NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(Total_Factura), 0) INTO v_Total
    FROM FIDE_Factura_TB
    WHERE ID_Venta = p_ID_Venta;
    RETURN v_Total;
END;
/

-- 7. Obtener estado de un producto
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_ESTADO_PRODUCTO_FN(p_ID_Producto IN NUMBER)
RETURN NUMBER
IS
    v_Estado NUMBER;
BEGIN
    SELECT ID_Estado INTO v_Estado
    FROM FIDE_Productos_TB
    WHERE ID_Producto = p_ID_Producto;
    RETURN v_Estado;
END;
/

-- 8. Obtener categoría de un insumo
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_CATEGORIA_INSUMO_FN(p_ID_Insumo IN NUMBER)
RETURN NUMBER
IS
    v_Categoria NUMBER;
BEGIN
    SELECT ID_Categoria INTO v_Categoria
    FROM FIDE_Insumos_TB
    WHERE ID_Insumo = p_ID_Insumo;
    RETURN v_Categoria;
END;
/

-- 9. Total de insumos por receta
CREATE OR REPLACE FUNCTION FIDE_TOTAL_INSUMOS_RECETA_FN(p_ID_Receta IN NUMBER)
RETURN NUMBER
IS
    v_Total NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(Cantidades), 0) INTO v_Total
    FROM FIDE_Receta_Insumo_TB
    WHERE ID_Receta = p_ID_Receta;
    RETURN v_Total;
END;
/

-- 10. Cantidad de productos por categoría
CREATE OR REPLACE FUNCTION FIDE_TOTAL_PRODUCTOS_CATEGORIA_FN(p_ID_Categoria IN NUMBER)
RETURN NUMBER
IS
    v_Total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_Total
    FROM FIDE_Productos_TB
    WHERE ID_Categoria = p_ID_Categoria;
    RETURN v_Total;
END;
/

-- 11. Total de dinero de una compra de insumos
CREATE OR REPLACE FUNCTION FIDE_TOTAL_MONTO_COMPRA_FN(p_ID_Compra IN NUMBER)
RETURN NUMBER
IS
    v_Total NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(Subtotal_Compra), 0) INTO v_Total
    FROM FIDE_Compras_Insumos_TB
    WHERE ID_Compra = p_ID_Compra;
    RETURN v_Total;
END;
/

-- 12. Obtener estado de un insumo
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_ESTADO_INSUMO_FN(p_ID_Insumo IN NUMBER)
RETURN NUMBER
IS
    v_Estado NUMBER;
BEGIN
    SELECT ID_Estado INTO v_Estado
    FROM FIDE_Insumos_TB
    WHERE ID_Insumo = p_ID_Insumo;
    RETURN v_Estado;
END;
/

-- 13. Obtener estado de una venta
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_ESTADO_VENTA_FN(p_ID_Venta IN NUMBER)
RETURN NUMBER
IS
    v_Estado NUMBER;
BEGIN
    SELECT ID_Estado INTO v_Estado
    FROM FIDE_Venta_TB
    WHERE ID_Venta = p_ID_Venta;
    RETURN v_Estado;
END;
/

-- 14. Obtener usuario de una compra
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_USUARIO_COMPRA_FN(p_ID_Compra IN NUMBER)
RETURN NUMBER
IS
    v_Usuario NUMBER;
BEGIN
    SELECT ID_Usuario INTO v_Usuario
    FROM FIDE_Compras_TB
    WHERE ID_Compra = p_ID_Compra;
    RETURN v_Usuario;
END;
/

-- 15. Obtener método de pago de una venta
CREATE OR REPLACE FUNCTION FIDE_CONSULTAR_METODO_PAGO_VENTA_FN(p_ID_Venta IN NUMBER)
RETURN NUMBER
IS
    v_Metodo NUMBER;
BEGIN
    SELECT ID_Metodo_Pago INTO v_Metodo
    FROM FIDE_Venta_TB
    WHERE ID_Venta = p_ID_Venta;
    RETURN v_Metodo;
END;
/
