-- ============================================================
-- Proyecto: La Esquinita del Pan | Grupo 4
-- Procedimientos_Extra.sql
-- ============================================================
-- Proyecto: La Esquinita del Pan | Grupo 4
--Dilan Tenorio Rojas
--CALVO HERRA LUIS ESTEBAN
--CARVAJAL FLORES BRYAN ALBERTO
--CORDERO GARCIA BRYAN STEVEN
--VELASQUEZ MORALES EDUARDO JOSE
-- ============================================================
-- Nombres para que se referencien:
--   FIDE_<Tabla>_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
--   FIDE_<Tabla>_TB_Insertar_SP(...)
--   FIDE_<Tabla>_TB_Actualizar_SP(...)
--   FIDE_<Tabla>_TB_Delete_SP(...)   -- baja logica (ID_Estado = 2) salvo que se indique lo contrario
-- ============================================================

-- ================= ESTADOS =================
CREATE OR REPLACE PROCEDURE FIDE_Estados_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Estado, Nombre_Estado FROM FIDE_Estados_TB ORDER BY ID_Estado;
END;
/

-- ================= ROLES  =================
CREATE OR REPLACE PROCEDURE FIDE_Roles_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Rol, Nombre_Rol FROM FIDE_Roles_TB ORDER BY ID_Rol;
END;
/

-- ================= PROVEEDORES  =================
CREATE OR REPLACE PROCEDURE FIDE_Proveedores_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT p.ID_Proveedor, p.Nombre_Proveedor, p.ID_Estado, e.Nombre_Estado
        FROM FIDE_Proveedores_TB p
        JOIN FIDE_Estados_TB e ON e.ID_Estado = p.ID_Estado
        ORDER BY p.ID_Proveedor;
END;
/

-- ================= USUARIOS  =================
CREATE OR REPLACE PROCEDURE FIDE_Usuarios_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT u.ID_Usuario, u.Nombre, u.Apellido_Paterno, u.Apellido_Materno,
               u.Fecha_Creacion, u.ID_Rol, r.Nombre_Rol, u.ID_Estado, e.Nombre_Estado
        FROM FIDE_Usuarios_TB u
        JOIN FIDE_Roles_TB r ON r.ID_Rol = u.ID_Rol
        JOIN FIDE_Estados_TB e ON e.ID_Estado = u.ID_Estado
        ORDER BY u.ID_Usuario;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Usuarios_TB_Actualizar_SP(
    p_ID_Usuario IN NUMBER, p_Nombre IN NVARCHAR2, p_Apellido_Paterno IN NVARCHAR2,
    p_Apellido_Materno IN NVARCHAR2, p_ID_Rol IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Usuarios_TB
    SET Nombre = p_Nombre, Apellido_Paterno = p_Apellido_Paterno,
        Apellido_Materno = p_Apellido_Materno, ID_Rol = p_ID_Rol, ID_Estado = p_ID_Estado
    WHERE ID_Usuario = p_ID_Usuario;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Usuarios_TB_Delete_SP(p_ID_Usuario IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Usuarios_TB SET ID_Estado = 2 WHERE ID_Usuario = p_ID_Usuario;
END;
/

-- ================= COMPRAS =================
CREATE OR REPLACE PROCEDURE FIDE_Compras_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT c.ID_Compra, c.ID_Proveedor, pr.Nombre_Proveedor, c.ID_Usuario,
               c.Fecha_Hora_Compra, c.Total_Compra, c.ID_Estado, e.Nombre_Estado
        FROM FIDE_Compras_TB c
        JOIN FIDE_Proveedores_TB pr ON pr.ID_Proveedor = c.ID_Proveedor
        JOIN FIDE_Estados_TB e ON e.ID_Estado = c.ID_Estado
        ORDER BY c.ID_Compra DESC;
END;
/

-- ================= TIPO =================
CREATE OR REPLACE PROCEDURE FIDE_Tipo_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Tipo, Nombre_Tipo, ID_Estado FROM FIDE_Tipo_TB ORDER BY ID_Tipo;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Tipo_TB_Insertar_SP(p_Nombre_Tipo IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Tipo_TB(Nombre_Tipo, ID_Estado) VALUES(p_Nombre_Tipo, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Tipo_TB_Actualizar_SP(p_ID_Tipo IN NUMBER, p_Nombre_Tipo IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Tipo_TB SET Nombre_Tipo = p_Nombre_Tipo, ID_Estado = p_ID_Estado WHERE ID_Tipo = p_ID_Tipo;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Tipo_TB_Delete_SP(p_ID_Tipo IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Tipo_TB SET ID_Estado = 2 WHERE ID_Tipo = p_ID_Tipo;
END;
/

-- ================= CATEGORIAS =================
CREATE OR REPLACE PROCEDURE FIDE_Categorias_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Categoria, Nombre_Categoria, ID_Estado FROM FIDE_Categorias_TB ORDER BY ID_Categoria;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Categorias_TB_Insertar_SP(p_Nombre_Categoria IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Categorias_TB(Nombre_Categoria, ID_Estado) VALUES(p_Nombre_Categoria, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Categorias_TB_Actualizar_SP(p_ID_Categoria IN NUMBER, p_Nombre_Categoria IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Categorias_TB SET Nombre_Categoria = p_Nombre_Categoria, ID_Estado = p_ID_Estado WHERE ID_Categoria = p_ID_Categoria;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Categorias_TB_Delete_SP(p_ID_Categoria IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Categorias_TB SET ID_Estado = 2 WHERE ID_Categoria = p_ID_Categoria;
END;
/

-- ================= UNIDADES DE MEDIDA =================
CREATE OR REPLACE PROCEDURE FIDE_Unidades_Medidas_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Unidad_Medida, Nombre_Medida, ID_Estado FROM FIDE_Unidades_Medidas_TB ORDER BY ID_Unidad_Medida;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Unidades_Medidas_TB_Insertar_SP(p_Nombre_Medida IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Unidades_Medidas_TB(Nombre_Medida, ID_Estado) VALUES(p_Nombre_Medida, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Unidades_Medidas_TB_Actualizar_SP(p_ID_Unidad_Medida IN NUMBER, p_Nombre_Medida IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Unidades_Medidas_TB SET Nombre_Medida = p_Nombre_Medida, ID_Estado = p_ID_Estado WHERE ID_Unidad_Medida = p_ID_Unidad_Medida;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Unidades_Medidas_TB_Delete_SP(p_ID_Unidad_Medida IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Unidades_Medidas_TB SET ID_Estado = 2 WHERE ID_Unidad_Medida = p_ID_Unidad_Medida;
END;
/

-- ================= METODOS DE PAGO =================
CREATE OR REPLACE PROCEDURE FIDE_Metodos_Pago_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Metodo_Pago, Nombre_Metodo, ID_Estado FROM FIDE_Metodos_Pago_TB ORDER BY ID_Metodo_Pago;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Metodos_Pago_TB_Insertar_SP(p_Nombre_Metodo IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Metodos_Pago_TB(Nombre_Metodo, ID_Estado) VALUES(p_Nombre_Metodo, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Metodos_Pago_TB_Actualizar_SP(p_ID_Metodo_Pago IN NUMBER, p_Nombre_Metodo IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Metodos_Pago_TB SET Nombre_Metodo = p_Nombre_Metodo, ID_Estado = p_ID_Estado WHERE ID_Metodo_Pago = p_ID_Metodo_Pago;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Metodos_Pago_TB_Delete_SP(p_ID_Metodo_Pago IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Metodos_Pago_TB SET ID_Estado = 2 WHERE ID_Metodo_Pago = p_ID_Metodo_Pago;
END;
/

-- ================= REFERENCIA TABLA =================
CREATE OR REPLACE PROCEDURE FIDE_Referencia_Tabla_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Referencia_Tabla, Nombre_Referencia, ID_Estado FROM FIDE_Referencia_Tabla_TB ORDER BY ID_Referencia_Tabla;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Referencia_Tabla_TB_Insertar_SP(p_Nombre_Referencia IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Referencia_Tabla_TB(Nombre_Referencia, ID_Estado) VALUES(p_Nombre_Referencia, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Referencia_Tabla_TB_Actualizar_SP(p_ID_Referencia_Tabla IN NUMBER, p_Nombre_Referencia IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Referencia_Tabla_TB SET Nombre_Referencia = p_Nombre_Referencia, ID_Estado = p_ID_Estado WHERE ID_Referencia_Tabla = p_ID_Referencia_Tabla;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Referencia_Tabla_TB_Delete_SP(p_ID_Referencia_Tabla IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Referencia_Tabla_TB SET ID_Estado = 2 WHERE ID_Referencia_Tabla = p_ID_Referencia_Tabla;
END;
/

-- ================= CORREO USUARIOS (PK compuesta) =================
CREATE OR REPLACE PROCEDURE FIDE_Correo_Usuarios_TB_Listar_SP(p_ID_Usuario IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Usuario, Correo, ID_Estado FROM FIDE_Correo_Usuarios_TB WHERE ID_Usuario = p_ID_Usuario;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Correo_Usuarios_TB_Insertar_SP(p_ID_Usuario IN NUMBER, p_Correo IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Correo_Usuarios_TB(ID_Usuario, Correo, ID_Estado) VALUES(p_ID_Usuario, p_Correo, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Correo_Usuarios_TB_Delete_SP(p_ID_Usuario IN NUMBER, p_Correo IN NVARCHAR2)
IS
BEGIN
    UPDATE FIDE_Correo_Usuarios_TB SET ID_Estado = 2 WHERE ID_Usuario = p_ID_Usuario AND Correo = p_Correo;
END;
/

-- ================= TELEFONOS USUARIOS (PK compuesta) =================
CREATE OR REPLACE PROCEDURE FIDE_Telefonos_Usuarios_TB_Listar_SP(p_ID_Usuario IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Usuario, Telefono, ID_Estado FROM FIDE_Telefonos_Usuarios_TB WHERE ID_Usuario = p_ID_Usuario;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Telefonos_Usuarios_TB_Insertar_SP(p_ID_Usuario IN NUMBER, p_Telefono IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Telefonos_Usuarios_TB(ID_Usuario, Telefono, ID_Estado) VALUES(p_ID_Usuario, p_Telefono, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Telefonos_Usuarios_TB_Delete_SP(p_ID_Usuario IN NUMBER, p_Telefono IN NVARCHAR2)
IS
BEGIN
    UPDATE FIDE_Telefonos_Usuarios_TB SET ID_Estado = 2 WHERE ID_Usuario = p_ID_Usuario AND Telefono = p_Telefono;
END;
/

-- ================= PRODUCTOS =================
CREATE OR REPLACE PROCEDURE FIDE_Productos_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT pr.ID_Producto, pr.Codigo, pr.ID_Categoria, c.Nombre_Categoria,
               pr.Nombre_Producto, pr.Precio_Venta, pr.ID_Estado, e.Nombre_Estado
        FROM FIDE_Productos_TB pr
        JOIN FIDE_Categorias_TB c ON c.ID_Categoria = pr.ID_Categoria
        JOIN FIDE_Estados_TB e ON e.ID_Estado = pr.ID_Estado
        ORDER BY pr.ID_Producto;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Productos_TB_Insertar_SP(
    p_Codigo IN NVARCHAR2, p_ID_Categoria IN NUMBER, p_Nombre_Producto IN NVARCHAR2,
    p_Precio_Venta IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Productos_TB(Codigo, ID_Categoria, Nombre_Producto, Precio_Venta, ID_Estado)
    VALUES(p_Codigo, p_ID_Categoria, p_Nombre_Producto, p_Precio_Venta, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Productos_TB_Actualizar_SP(
    p_ID_Producto IN NUMBER, p_Codigo IN NVARCHAR2, p_ID_Categoria IN NUMBER,
    p_Nombre_Producto IN NVARCHAR2, p_Precio_Venta IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Productos_TB
    SET Codigo = p_Codigo, ID_Categoria = p_ID_Categoria, Nombre_Producto = p_Nombre_Producto,
        Precio_Venta = p_Precio_Venta, ID_Estado = p_ID_Estado
    WHERE ID_Producto = p_ID_Producto;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Productos_TB_Delete_SP(p_ID_Producto IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Productos_TB SET ID_Estado = 2 WHERE ID_Producto = p_ID_Producto;
END;
/

-- ================= INSUMOS =================
CREATE OR REPLACE PROCEDURE FIDE_Insumos_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT i.ID_Insumo, i.Nombre_Insumo, i.Stock, i.ID_Unidad_Medida, u.Nombre_Medida,
               i.ID_Categoria, c.Nombre_Categoria, i.ID_Estado, e.Nombre_Estado
        FROM FIDE_Insumos_TB i
        JOIN FIDE_Unidades_Medidas_TB u ON u.ID_Unidad_Medida = i.ID_Unidad_Medida
        JOIN FIDE_Categorias_TB c ON c.ID_Categoria = i.ID_Categoria
        JOIN FIDE_Estados_TB e ON e.ID_Estado = i.ID_Estado
        ORDER BY i.ID_Insumo;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Insumos_TB_Insertar_SP(
    p_Nombre_Insumo IN NVARCHAR2, p_Stock IN NUMBER, p_ID_Unidad_Medida IN NUMBER,
    p_ID_Categoria IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Insumos_TB(Nombre_Insumo, Stock, ID_Unidad_Medida, ID_Categoria, ID_Estado)
    VALUES(p_Nombre_Insumo, p_Stock, p_ID_Unidad_Medida, p_ID_Categoria, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Insumos_TB_Actualizar_SP(
    p_ID_Insumo IN NUMBER, p_Nombre_Insumo IN NVARCHAR2, p_Stock IN NUMBER,
    p_ID_Unidad_Medida IN NUMBER, p_ID_Categoria IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Insumos_TB
    SET Nombre_Insumo = p_Nombre_Insumo, Stock = p_Stock, ID_Unidad_Medida = p_ID_Unidad_Medida,
        ID_Categoria = p_ID_Categoria, ID_Estado = p_ID_Estado
    WHERE ID_Insumo = p_ID_Insumo;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Insumos_TB_Delete_SP(p_ID_Insumo IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Insumos_TB SET ID_Estado = 2 WHERE ID_Insumo = p_ID_Insumo;
END;
/

-- ================= INVENTARIO ITEM =================
CREATE OR REPLACE PROCEDURE FIDE_Inventario_Item_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT ID_Inventario_Item, ID_Producto, ID_Insumo, Stock, Stock_Minimo, ID_Estado
        FROM FIDE_Inventario_Item_TB
        ORDER BY ID_Inventario_Item;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Inventario_Item_TB_Insertar_SP(
    p_ID_Producto IN NUMBER, p_ID_Insumo IN NUMBER, p_Stock IN NUMBER,
    p_Stock_Minimo IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Inventario_Item_TB(ID_Producto, ID_Insumo, Stock, Stock_Minimo, ID_Estado)
    VALUES(p_ID_Producto, p_ID_Insumo, p_Stock, p_Stock_Minimo, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Inventario_Item_TB_Actualizar_SP(
    p_ID_Inventario_Item IN NUMBER, p_Stock IN NUMBER, p_Stock_Minimo IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Inventario_Item_TB
    SET Stock = p_Stock, Stock_Minimo = p_Stock_Minimo, ID_Estado = p_ID_Estado
    WHERE ID_Inventario_Item = p_ID_Inventario_Item;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Inventario_Item_TB_Delete_SP(p_ID_Inventario_Item IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Inventario_Item_TB SET ID_Estado = 2 WHERE ID_Inventario_Item = p_ID_Inventario_Item;
END;
/

-- ================= MOVIMIENTO INVENTARIO =================
-- Nota: es una tabla de auditoria de movimientos. No se contempla
-- Actualizar (no se edita historial), solo Listar, Insertar y una
-- baja logica por si se registra un movimiento por error.
CREATE OR REPLACE PROCEDURE FIDE_Movimiento_Inventario_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT m.ID_Movimiento, m.ID_Inventario_Item, m.ID_Tipo, t.Nombre_Tipo,
               m.Fecha_Hora_Movimiento, m.Cantidad, m.ID_Referencia_Tabla, r.Nombre_Referencia,
               m.Referencia_Id, m.ID_Usuario, m.ID_Estado
        FROM FIDE_Movimiento_Inventario_TB m
        JOIN FIDE_Tipo_TB t ON t.ID_Tipo = m.ID_Tipo
        JOIN FIDE_Referencia_Tabla_TB r ON r.ID_Referencia_Tabla = m.ID_Referencia_Tabla
        ORDER BY m.Fecha_Hora_Movimiento DESC;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Movimiento_Inventario_TB_Insertar_SP(
    p_ID_Inventario_Item IN NUMBER, p_ID_Tipo IN NUMBER, p_Fecha_Hora_Movimiento IN TIMESTAMP,
    p_Cantidad IN NUMBER, p_ID_Referencia_Tabla IN NUMBER, p_Referencia_Id IN NUMBER,
    p_ID_Usuario IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Movimiento_Inventario_TB(
        ID_Inventario_Item, ID_Tipo, Fecha_Hora_Movimiento, Cantidad,
        ID_Referencia_Tabla, Referencia_Id, ID_Usuario, ID_Estado
    ) VALUES(
        p_ID_Inventario_Item, p_ID_Tipo, p_Fecha_Hora_Movimiento, p_Cantidad,
        p_ID_Referencia_Tabla, p_Referencia_Id, p_ID_Usuario, p_ID_Estado
    );
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Movimiento_Inventario_TB_Delete_SP(p_ID_Movimiento IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Movimiento_Inventario_TB SET ID_Estado = 2 WHERE ID_Movimiento = p_ID_Movimiento;
END;
/

-- ================= VENTA =================
CREATE OR REPLACE PROCEDURE FIDE_Venta_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT v.ID_Venta, v.ID_Usuario, u.Nombre, v.Fecha_Hora_Venta, v.Total_Venta,
               v.ID_Metodo_Pago, mp.Nombre_Metodo, v.ID_Estado, e.Nombre_Estado
        FROM FIDE_Venta_TB v
        JOIN FIDE_Usuarios_TB u ON u.ID_Usuario = v.ID_Usuario
        JOIN FIDE_Metodos_Pago_TB mp ON mp.ID_Metodo_Pago = v.ID_Metodo_Pago
        JOIN FIDE_Estados_TB e ON e.ID_Estado = v.ID_Estado
        ORDER BY v.ID_Venta DESC;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Venta_TB_Insertar_SP(
    p_ID_Usuario IN NUMBER, p_Fecha_Hora_Venta IN TIMESTAMP, p_Total_Venta IN NUMBER,
    p_ID_Metodo_Pago IN NUMBER, p_ID_Estado IN NUMBER, p_ID_Venta_Out OUT NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Venta_TB(ID_Usuario, Fecha_Hora_Venta, Total_Venta, ID_Metodo_Pago, ID_Estado)
    VALUES(p_ID_Usuario, p_Fecha_Hora_Venta, p_Total_Venta, p_ID_Metodo_Pago, p_ID_Estado)
    RETURNING ID_Venta INTO p_ID_Venta_Out;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Venta_TB_Actualizar_SP(
    p_ID_Venta IN NUMBER, p_Total_Venta IN NUMBER, p_ID_Metodo_Pago IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Venta_TB
    SET Total_Venta = p_Total_Venta, ID_Metodo_Pago = p_ID_Metodo_Pago, ID_Estado = p_ID_Estado
    WHERE ID_Venta = p_ID_Venta;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Venta_TB_Delete_SP(p_ID_Venta IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Venta_TB SET ID_Estado = 2 WHERE ID_Venta = p_ID_Venta;
END;
/

-- ================= VENTA PRODUCTOS (PK compuesta) =================
CREATE OR REPLACE PROCEDURE FIDE_Venta_Productos_TB_Listar_SP(p_ID_Venta IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT vp.ID_Venta, vp.ID_Producto, pr.Nombre_Producto, vp.Cantidad,
               vp.Precio_Unitario, vp.Subtotal_Venta, vp.ID_Estado
        FROM FIDE_Venta_Productos_TB vp
        JOIN FIDE_Productos_TB pr ON pr.ID_Producto = vp.ID_Producto
        WHERE vp.ID_Venta = p_ID_Venta;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Venta_Productos_TB_Insertar_SP(
    p_ID_Venta IN NUMBER, p_ID_Producto IN NUMBER, p_Cantidad IN NUMBER,
    p_Precio_Unitario IN NUMBER, p_Subtotal_Venta IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Venta_Productos_TB(ID_Venta, ID_Producto, Cantidad, Precio_Unitario, Subtotal_Venta, ID_Estado)
    VALUES(p_ID_Venta, p_ID_Producto, p_Cantidad, p_Precio_Unitario, p_Subtotal_Venta, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Venta_Productos_TB_Delete_SP(p_ID_Venta IN NUMBER, p_ID_Producto IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Venta_Productos_TB SET ID_Estado = 2 WHERE ID_Venta = p_ID_Venta AND ID_Producto = p_ID_Producto;
END;
/

-- ================= RECETAS =================
CREATE OR REPLACE PROCEDURE FIDE_Recetas_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT r.ID_Receta, r.ID_Producto, p.Nombre_Producto, r.Rendimiento, r.Notas, r.ID_Estado
        FROM FIDE_Recetas_TB r
        JOIN FIDE_Productos_TB p ON p.ID_Producto = r.ID_Producto
        ORDER BY r.ID_Receta;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Recetas_TB_Insertar_SP(
    p_ID_Producto IN NUMBER, p_Rendimiento IN NUMBER, p_Notas IN NVARCHAR2, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Recetas_TB(ID_Producto, Rendimiento, Notas, ID_Estado)
    VALUES(p_ID_Producto, p_Rendimiento, p_Notas, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Recetas_TB_Actualizar_SP(
    p_ID_Receta IN NUMBER, p_Rendimiento IN NUMBER, p_Notas IN NVARCHAR2, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Recetas_TB SET Rendimiento = p_Rendimiento, Notas = p_Notas, ID_Estado = p_ID_Estado
    WHERE ID_Receta = p_ID_Receta;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Recetas_TB_Delete_SP(p_ID_Receta IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Recetas_TB SET ID_Estado = 2 WHERE ID_Receta = p_ID_Receta;
END;
/

-- ================= RECETA INSUMO (PK compuesta) =================
CREATE OR REPLACE PROCEDURE FIDE_Receta_Insumo_TB_Listar_SP(p_ID_Receta IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT ri.ID_Receta, ri.ID_Insumo, i.Nombre_Insumo, ri.Cantidades, ri.ID_Estado
        FROM FIDE_Receta_Insumo_TB ri
        JOIN FIDE_Insumos_TB i ON i.ID_Insumo = ri.ID_Insumo
        WHERE ri.ID_Receta = p_ID_Receta;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Receta_Insumo_TB_Insertar_SP(
    p_ID_Receta IN NUMBER, p_ID_Insumo IN NUMBER, p_Cantidades IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Receta_Insumo_TB(ID_Receta, ID_Insumo, Cantidades, ID_Estado)
    VALUES(p_ID_Receta, p_ID_Insumo, p_Cantidades, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Receta_Insumo_TB_Delete_SP(p_ID_Receta IN NUMBER, p_ID_Insumo IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Receta_Insumo_TB SET ID_Estado = 2 WHERE ID_Receta = p_ID_Receta AND ID_Insumo = p_ID_Insumo;
END;
/

-- ================= COMPRAS INSUMOS (PK compuesta) =================
CREATE OR REPLACE PROCEDURE FIDE_Compras_Insumos_TB_Listar_SP(p_ID_Compra IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT ci.ID_Compra, ci.ID_Insumo, i.Nombre_Insumo, ci.Cantidad, ci.Precio_Unid, ci.Subtotal_Compra, ci.ID_Estado
        FROM FIDE_Compras_Insumos_TB ci
        JOIN FIDE_Insumos_TB i ON i.ID_Insumo = ci.ID_Insumo
        WHERE ci.ID_Compra = p_ID_Compra;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Compras_Insumos_TB_Insertar_SP(
    p_ID_Compra IN NUMBER, p_ID_Insumo IN NUMBER, p_Cantidad IN NUMBER,
    p_Precio_Unid IN NUMBER, p_Subtotal_Compra IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Compras_Insumos_TB(ID_Compra, ID_Insumo, Cantidad, Precio_Unid, Subtotal_Compra, ID_Estado)
    VALUES(p_ID_Compra, p_ID_Insumo, p_Cantidad, p_Precio_Unid, p_Subtotal_Compra, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Compras_Insumos_TB_Delete_SP(p_ID_Compra IN NUMBER, p_ID_Insumo IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Compras_Insumos_TB SET ID_Estado = 2 WHERE ID_Compra = p_ID_Compra AND ID_Insumo = p_ID_Insumo;
END;
/

-- ================= ORDEN PRODUCCION =================
CREATE OR REPLACE PROCEDURE FIDE_Orden_Produccion_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT o.ID_Orden_Produccion, o.ID_Usuario, u.Nombre, o.Fecha_Hora, o.Observaciones, o.ID_Estado
        FROM FIDE_Orden_Produccion_TB o
        JOIN FIDE_Usuarios_TB u ON u.ID_Usuario = o.ID_Usuario
        ORDER BY o.ID_Orden_Produccion DESC;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Orden_Produccion_TB_Insertar_SP(
    p_ID_Usuario IN NUMBER, p_Fecha_Hora IN TIMESTAMP, p_Observaciones IN NVARCHAR2,
    p_ID_Estado IN NUMBER, p_ID_Orden_Out OUT NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Orden_Produccion_TB(ID_Usuario, Fecha_Hora, Observaciones, ID_Estado)
    VALUES(p_ID_Usuario, p_Fecha_Hora, p_Observaciones, p_ID_Estado)
    RETURNING ID_Orden_Produccion INTO p_ID_Orden_Out;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Orden_Produccion_TB_Actualizar_SP(
    p_ID_Orden_Produccion IN NUMBER, p_Observaciones IN NVARCHAR2, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Orden_Produccion_TB SET Observaciones = p_Observaciones, ID_Estado = p_ID_Estado
    WHERE ID_Orden_Produccion = p_ID_Orden_Produccion;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Orden_Produccion_TB_Delete_SP(p_ID_Orden_Produccion IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Orden_Produccion_TB SET ID_Estado = 2 WHERE ID_Orden_Produccion = p_ID_Orden_Produccion;
END;
/

-- ================= ORDEN DETALLE =================
CREATE OR REPLACE PROCEDURE FIDE_Orden_Detalle_TB_Listar_SP(p_ID_Orden_Produccion IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT od.ID_Orden_Produccion, od.ID_Producto, p.Nombre_Producto, od.Cantidad_Ordenada, od.ID_Estado
        FROM FIDE_Orden_Detalle_TB od
        JOIN FIDE_Productos_TB p ON p.ID_Producto = od.ID_Producto
        WHERE od.ID_Orden_Produccion = p_ID_Orden_Produccion;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Orden_Detalle_TB_Insertar_SP(
    p_ID_Orden_Produccion IN NUMBER, p_ID_Producto IN NUMBER, p_Cantidad_Ordenada IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Orden_Detalle_TB(ID_Orden_Produccion, ID_Producto, Cantidad_Ordenada, ID_Estado)
    VALUES(p_ID_Orden_Produccion, p_ID_Producto, p_Cantidad_Ordenada, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Orden_Detalle_TB_Delete_SP(p_ID_Orden_Produccion IN NUMBER, p_ID_Producto IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Orden_Detalle_TB SET ID_Estado = 2 WHERE ID_Orden_Produccion = p_ID_Orden_Produccion AND ID_Producto = p_ID_Producto;
END;
/

-- ================= ORDEN INSUMO =================
CREATE OR REPLACE PROCEDURE FIDE_Orden_Insumo_TB_Listar_SP(p_ID_Orden_Produccion IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT oi.ID_Orden_Produccion, oi.ID_Insumo, i.Nombre_Insumo, oi.Cantidad_Usada
        FROM FIDE_Orden_Insumo_TB oi
        JOIN FIDE_Insumos_TB i ON i.ID_Insumo = oi.ID_Insumo
        WHERE oi.ID_Orden_Produccion = p_ID_Orden_Produccion;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Orden_Insumo_TB_Insertar_SP(
    p_ID_Orden_Produccion IN NUMBER, p_ID_Insumo IN NUMBER, p_Cantidad_Usada IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Orden_Insumo_TB(ID_Orden_Produccion, ID_Insumo, Cantidad_Usada)
    VALUES(p_ID_Orden_Produccion, p_ID_Insumo, p_Cantidad_Usada);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Orden_Insumo_TB_Delete_SP(p_ID_Orden_Produccion IN NUMBER, p_ID_Insumo IN NUMBER)
IS
BEGIN
    DELETE FROM FIDE_Orden_Insumo_TB WHERE ID_Orden_Produccion = p_ID_Orden_Produccion AND ID_Insumo = p_ID_Insumo;
END;
/

-- ================= CORREO PROVEEDORES (PK compuesta) =================
CREATE OR REPLACE PROCEDURE FIDE_Correo_Proveedores_TB_Listar_SP(p_ID_Proveedor IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Proveedor, Correo, ID_Estado FROM FIDE_Correo_Proveedores_TB WHERE ID_Proveedor = p_ID_Proveedor;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Correo_Proveedores_TB_Insertar_SP(p_ID_Proveedor IN NUMBER, p_Correo IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Correo_Proveedores_TB(ID_Proveedor, Correo, ID_Estado) VALUES(p_ID_Proveedor, p_Correo, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Correo_Proveedores_TB_Delete_SP(p_ID_Proveedor IN NUMBER, p_Correo IN NVARCHAR2)
IS
BEGIN
    UPDATE FIDE_Correo_Proveedores_TB SET ID_Estado = 2 WHERE ID_Proveedor = p_ID_Proveedor AND Correo = p_Correo;
END;
/

-- ================= TELEFONO PROVEEDOR  =================
CREATE OR REPLACE PROCEDURE FIDE_Telefono_Proveedor_TB_Listar_SP(p_ID_Proveedor IN NUMBER, p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR SELECT ID_Proveedor, Telefono, ID_Estado FROM FIDE_Telefono_Proveedor_TB WHERE ID_Proveedor = p_ID_Proveedor;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Telefono_Proveedor_TB_Insertar_SP(p_ID_Proveedor IN NUMBER, p_Telefono IN NVARCHAR2, p_ID_Estado IN NUMBER)
IS
BEGIN
    INSERT INTO FIDE_Telefono_Proveedor_TB(ID_Proveedor, Telefono, ID_Estado) VALUES(p_ID_Proveedor, p_Telefono, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Telefono_Proveedor_TB_Delete_SP(p_ID_Proveedor IN NUMBER, p_Telefono IN NVARCHAR2)
IS
BEGIN
    UPDATE FIDE_Telefono_Proveedor_TB SET ID_Estado = 2 WHERE ID_Proveedor = p_ID_Proveedor AND Telefono = p_Telefono;
END;
/

-- ================= FACTURA =================
CREATE OR REPLACE PROCEDURE FIDE_Factura_TB_Listar_SP(p_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT f.ID_Factura, f.Numero_Factura, f.ID_Venta, f.Fecha_Emision, f.Total_Factura, f.ID_Estado
        FROM FIDE_Factura_TB f
        ORDER BY f.ID_Factura DESC;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Factura_TB_Insertar_SP(
    p_Numero_Factura IN NVARCHAR2, p_ID_Venta IN NUMBER, p_Fecha_Emision IN DATE,
    p_Total_Factura IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Factura_TB(Numero_Factura, ID_Venta, Fecha_Emision, Total_Factura, ID_Estado)
    VALUES(p_Numero_Factura, p_ID_Venta, p_Fecha_Emision, p_Total_Factura, p_ID_Estado);
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Factura_TB_Actualizar_SP(
    p_ID_Factura IN NUMBER, p_Numero_Factura IN NVARCHAR2, p_Total_Factura IN NUMBER, p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Factura_TB SET Numero_Factura = p_Numero_Factura, Total_Factura = p_Total_Factura, ID_Estado = p_ID_Estado
    WHERE ID_Factura = p_ID_Factura;
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Factura_TB_Delete_SP(p_ID_Factura IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Factura_TB SET ID_Estado = 2 WHERE ID_Factura = p_ID_Factura;
END;
/
