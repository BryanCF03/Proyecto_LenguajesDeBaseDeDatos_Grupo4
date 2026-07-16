# La Esquinita del Pan — Sistema de Gestión
--Dilan Tenorio Rojas
--CALVO HERRA LUIS ESTEBAN
--CARVAJAL FLORES BRYAN ALBERTO
--CORDERO GARCIA BRYAN STEVEN
--VELASQUEZ MORALES EDUARDO JOSE
Sistema de gestión (ventas, compras, producción e inventario) para la
microempresa La Esquinita del Pan. Backend en Flask Python, toda la
lógica de negocio vive en Oracle PL/SQL(procedimientos, funciones y
disparadores); Python solo llama a esos procedimientos.

## 1. Orden de ejecución de los scripts SQL

Abre SQL Developer, conéctate a tu Autonomous Database, y ejecuta los
scripts de la carpeta `sql/` **en este orden exacto**:

1. `00_Estados_y_Secuencias.sql` — crea `FIDE_Estados_TB`  y
   todas las secuencias que usan los triggers.
2. `Avance2_Proyecto_Grupo4_Tablas.sql` — el script de tablas
3. `Avance2_Proyecto_Grupo4_Procedimientos.sql` — procedimientos
   (Estados, Roles, Proveedores, Usuarios, Compras).
4. `Avance2_Proyecto_Grupo4_Procedimientos_Extra.sql` 
   (con `SYS_REFCURSOR`) para cada tabla.
5. `Avance2_Proyecto_Grupo4_Funciones.sql` — funciones originales, sin
   cambios (le agregué el `/` al final de cada función porque en Oracle
   hace falta para separar bloques PL/SQL al correr el script completo como explico el profe).
6. `Vistas_y_Cursores.sql` — script para cumplir con las vistas, cursores 
   funciones minimas de la base de datos (aun falta bastante para completar)
   
## 2. Configurar el wallet de Oracle Autonomous Database
## El proyecto para funcionar debe tener la base de datos en la nube corriendo
## 4. Instalar dependencias y correr el proyecto

# Crear y activar entorno virtual
python -m venv venv
venv\Scripts\activate        # Windows
# Instalar dependencias
pip install -r requirements.txt
# Correr la aplicación
python app.py
```
Despues tienen que abrir **http://localhost:5000** en el navegador.
## Instrucciones
## Este es el patrón para agregar el resto de módulos

El módulo **Proveedores** (`routes/proveedores.py` +
`templates/proveedores/`) es la plantilla a copiar para cada módulo nuevo
(Productos, Insumos, Ventas, Compras, Inventario, Recetas, Órdenes de
Producción, Facturas, Usuarios). Para cada uno:

1. Crear `routes/<modulo>.py` con un `Blueprint`, usando
   `call_listar("FIDE_<Tabla>_TB_Listar_SP")` para leer y
   `call_dml("FIDE_<Tabla>_TB_Insertar_SP", [...])` para escribir — los
   procedimientos ya existen en `sql/Avance2_Proyecto_Grupo4_Procedimientos_Extra.sql`.
2. Crear `templates/<modulo>/list.html` y `form.html` (copiar y adaptar
   los de `proveedores/`).
3. Registrar el blueprint en `app.py`.
4. Activar el link correspondiente en `templates/base.html` (quitar la
   clase `disabled`).
