# La Esquinita del Pan — Sistema de Gestión

Sistema de gestión (ventas, compras, producción e inventario) para la
microempresa La Esquinita del Pan. Backend en **Flask (Python)**, toda la
lógica de negocio vive en **Oracle PL/SQL** (procedimientos, funciones y
disparadores); Python solo llama a esos procedimientos.

## 1. Orden de ejecución de los scripts SQL

Abre **SQL Developer**, conéctate a tu Autonomous Database, y ejecuta los
scripts de la carpeta `sql/` **en este orden exacto**:

1. `00_Estados_y_Secuencias.sql` — crea `FIDE_Estados_TB` (faltaba en el
   script original y es referenciada por casi todas las demás tablas) y
   todas las secuencias que usan los triggers.
2. `Avance2_Proyecto_Grupo4_Tablas.sql` — el script original de tablas, sin
   cambios.
3. `Avance2_Proyecto_Grupo4_Procedimientos.sql` — procedimientos originales
   (Estados, Roles, Proveedores, Usuarios, Compras).
4. `Avance2_Proyecto_Grupo4_Procedimientos_Extra.sql` — procedimientos que
   faltaban para el resto de tablas, más un procedimiento `*_Listar_SP`
   (con `SYS_REFCURSOR`) para **cada** tabla, incluidas las que ya tenían
   CRUD, porque Python nunca debe hacer un `SELECT` directo.
5. `Avance2_Proyecto_Grupo4_Funciones.sql` — funciones originales, sin
   cambios (le agregué el `/` al final de cada función porque en Oracle
   hace falta para separar bloques PL/SQL al correr el script completo).

> ⚠️ Cuando tu compañero entregue la tabla de Usuarios definitiva, avísame
> para revisar si cambia algo en `FIDE_Usuarios_TB` y sus procedimientos.

## 2. Configurar el wallet de Oracle Autonomous Database

1. En **OCI Console** → tu Autonomous Database → **Database Connection** →
   **Download Wallet**. Te pedirá crear un password para el wallet (guárdalo).
2. Descomprime ese `.zip` dentro de la carpeta del proyecto, en una carpeta
   llamada `wallet/` (ya está en `.gitignore` / no se sube a ningún lado).
   Debe quedar así:
   ```
   LaEsquinitaDelPan/
     wallet/
       cwallet.sso
       tnsnames.ora
       sqlnet.ora
       ...
   ```
3. Abre `wallet/tnsnames.ora` y copia uno de los alias que aparecen ahí
   (ej. `midb_high`, `midb_medium`, `midb_low`) — normalmente se usa el
   `_high` para más rendimiento en OLTP simple.

## 3. Configurar variables de entorno

1. Copia `.env.example` como `.env`:
   ```bash
   cp .env.example .env
   ```
2. Edita `.env` con tus datos reales: usuario, contraseña, el alias del
   paso anterior (`DB_DSN`), la ruta del wallet y su contraseña.

## 4. Instalar dependencias y correr el proyecto

```bash
# Crear y activar entorno virtual
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS/Linux

# Instalar dependencias
pip install -r requirements.txt

# Correr la aplicación
python app.py
```

Abre **http://localhost:5000** en el navegador.

## 5. Estructura del proyecto

```
LaEsquinitaDelPan/
├── app.py                 # Punto de entrada Flask, registra blueprints
├── config.py               # Lee variables de entorno (.env)
├── requirements.txt
├── .env.example
├── db/
│   └── connection.py       # Conexión (wallet) + helpers call_listar/call_dml
├── routes/
│   └── proveedores.py      # Blueprint de ejemplo, ya conectado (CRUD completo)
├── templates/
│   ├── base.html           # Layout con menú lateral de módulos
│   ├── home.html
│   └── proveedores/
│       ├── list.html
│       └── form.html
├── static/css/style.css
└── sql/
    ├── 00_Estados_y_Secuencias.sql
    ├── Avance2_Proyecto_Grupo4_Tablas.sql
    ├── Avance2_Proyecto_Grupo4_Procedimientos.sql
    ├── Avance2_Proyecto_Grupo4_Procedimientos_Extra.sql
    └── Avance2_Proyecto_Grupo4_Funciones.sql
```

## 6. Patrón para agregar el resto de módulos

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

Puedo seguir generando los módulos restantes uno por uno siguiendo este
mismo patrón — dime por cuál seguimos.
