-- ============================================================
-- Proyecto: La Esquinita del Pan | Grupo 4
--Dilan Tenorio Rojas
--CALVO HERRA LUIS ESTEBAN
--CARVAJAL FLORES BRYAN ALBERTO
--CORDERO GARCIA BRYAN STEVEN
--VELASQUEZ MORALES EDUARDO JOSE
-- ============================================================
CREATE OR REPLACE PROCEDURE FIDE_Inventario_Item_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT
            ii.ID_Inventario_Item,
            ii.ID_Producto,
            p.Nombre_Producto,
            ii.ID_Insumo,
            i.Nombre_Insumo,
            ii.Stock,
            ii.Stock_Minimo,
            ii.ID_Estado,
            e.Nombre_Estado
        FROM FIDE_Inventario_Item_TB ii
        LEFT JOIN FIDE_Productos_TB p ON p.ID_Producto = ii.ID_Producto
        LEFT JOIN FIDE_Insumos_TB i ON i.ID_Insumo = ii.ID_Insumo
        JOIN FIDE_Estados_TB e ON e.ID_Estado = ii.ID_Estado
        ORDER BY ii.ID_Inventario_Item;
END;
/
