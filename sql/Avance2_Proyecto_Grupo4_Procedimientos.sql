-- Proyecto: La Esquinita del Pan | Grupo 4 | Procedimientos
-- ============================================================
--Dilan Tenorio Rojas
--CALVO HERRA LUIS ESTEBAN
--CARVAJAL FLORES BRYAN ALBERTO
--CORDERO GARCIA BRYAN STEVEN
--VELASQUEZ MORALES EDUARDO JOSE
-- ============================================================
-- Estados
CREATE OR REPLACE PROCEDURE FIDE_Estados_TB_Insertar_SP(p_Nombre_Estado IN NVARCHAR2)
IS
BEGIN
    INSERT INTO FIDE_Estados_TB(Nombre_Estado) VALUES(p_Nombre_Estado);
    DBMS_OUTPUT.PUT_LINE('Estado insertado con exito');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Estados_TB_Actualizar_SP(p_ID_Estado IN NUMBER, p_Nombre_Estado IN NVARCHAR2)
IS
BEGIN
    UPDATE FIDE_Estados_TB SET Nombre_Estado = p_Nombre_Estado WHERE ID_Estado = p_ID_Estado;
    DBMS_OUTPUT.PUT_LINE('Estado actualizado');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Estados_TB_Delete_SP(p_ID_Estado IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Estados_TB SET Nombre_Estado = 'INACTIVO' WHERE ID_Estado = p_ID_Estado;
    DBMS_OUTPUT.PUT_LINE('Estado eliminado');
END;
/
-- Roles
CREATE OR REPLACE PROCEDURE FIDE_Roles_TB_Insertar_SP(p_Nombre_Rol IN NVARCHAR2)
IS
BEGIN
    INSERT INTO FIDE_Roles_TB(Nombre_Rol) VALUES(p_Nombre_Rol);
    DBMS_OUTPUT.PUT_LINE('Rol insertado');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Roles_TB_Actualizar_SP(p_ID_Rol IN NUMBER, p_Nombre_Rol IN NVARCHAR2)
IS
BEGIN
    UPDATE FIDE_Roles_TB SET Nombre_Rol = p_Nombre_Rol WHERE ID_Rol = p_ID_Rol;
    DBMS_OUTPUT.PUT_LINE('Rol actualizado');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Roles_TB_Delete_SP(p_ID_Rol IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Roles_TB SET Nombre_Rol = 'INACTIVO' WHERE ID_Rol = p_ID_Rol;
    DBMS_OUTPUT.PUT_LINE('Rol eliminado');
END;
/
-- Proveedores
CREATE OR REPLACE PROCEDURE FIDE_Proveedores_TB_Insertar_SP(
    p_Nombre_Proveedor IN NVARCHAR2,
    p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Proveedores_TB(Nombre_Proveedor, ID_Estado)
    VALUES(p_Nombre_Proveedor, p_ID_Estado);
    DBMS_OUTPUT.PUT_LINE('Proveedor insertado');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Proveedores_TB_Actualizar_SP(
    p_ID_Proveedor IN NUMBER,
    p_Nombre_Proveedor IN NVARCHAR2,
    p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Proveedores_TB
    SET Nombre_Proveedor = p_Nombre_Proveedor, ID_Estado = p_ID_Estado
    WHERE ID_Proveedor = p_ID_Proveedor;
    DBMS_OUTPUT.PUT_LINE('Proveedor actualizado');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Proveedores_TB_Delete_SP(p_ID_Proveedor IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Proveedores_TB SET ID_Estado = 2 WHERE ID_Proveedor = p_ID_Proveedor;
    DBMS_OUTPUT.PUT_LINE('Proveedor eliminado');
END;
/
-- Usuarios
CREATE OR REPLACE PROCEDURE FIDE_Usuarios_TB_Insertar_SP(
    p_Nombre IN NVARCHAR2,
    p_Apellido_Paterno IN NVARCHAR2,
    p_Apellido_Materno IN NVARCHAR2,
    p_Contrasenna IN NVARCHAR2,
    p_Fecha_Creacion IN DATE,
    p_ID_Rol IN NUMBER,
    p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Usuarios_TB(Nombre, Apellido_Paterno, Apellido_Materno, Contrasenna, Fecha_Creacion, ID_Rol, ID_Estado)
    VALUES(p_Nombre, p_Apellido_Paterno, p_Apellido_Materno, p_Contrasenna, p_Fecha_Creacion, p_ID_Rol, p_ID_Estado);
END;
/
-- Compras
CREATE OR REPLACE PROCEDURE FIDE_Compras_TB_Insertar_SP(
    p_ID_Proveedor IN NUMBER,
    p_ID_Usuario IN NUMBER,
    p_Fecha_Hora_Compra IN TIMESTAMP,
    p_Total_Compra IN NUMBER,
    p_ID_Estado IN NUMBER
)
IS
BEGIN
    INSERT INTO FIDE_Compras_TB(ID_Proveedor, ID_Usuario, Fecha_Hora_Compra, Total_Compra, ID_Estado)
    VALUES(p_ID_Proveedor, p_ID_Usuario, p_Fecha_Hora_Compra, p_Total_Compra, p_ID_Estado);
    DBMS_OUTPUT.PUT_LINE('Compra insertada');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Compras_TB_Actualizar_SP(
    p_ID_Compra IN NUMBER,
    p_ID_Proveedor IN NUMBER,
    p_ID_Usuario IN NUMBER,
    p_Fecha_Hora_Compra IN TIMESTAMP,
    p_Total_Compra IN NUMBER,
    p_ID_Estado IN NUMBER
)
IS
BEGIN
    UPDATE FIDE_Compras_TB
    SET ID_Proveedor = p_ID_Proveedor,
        ID_Usuario = p_ID_Usuario,
        Fecha_Hora_Compra = p_Fecha_Hora_Compra,
        Total_Compra = p_Total_Compra,
        ID_Estado = p_ID_Estado
    WHERE ID_Compra = p_ID_Compra;
    DBMS_OUTPUT.PUT_LINE('Compra actualizada');
END;
/
CREATE OR REPLACE PROCEDURE FIDE_Compras_TB_Delete_SP(p_ID_Compra IN NUMBER)
IS
BEGIN
    UPDATE FIDE_Compras_TB SET ID_Estado = 2 WHERE ID_Compra = p_ID_Compra;
    DBMS_OUTPUT.PUT_LINE('Compra eliminada');
END;
/
