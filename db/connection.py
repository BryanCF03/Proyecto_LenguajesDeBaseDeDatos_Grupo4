"""
Capa de conexion a Oracle Autonomous Database.

Toda la logica de negocio vive en procedimientos/funciones PL/SQL.
Este modulo SOLO abre la conexion (via wallet) y ofrece dos helpers
genericos para que las rutas de Flask nunca escriban SQL directo:

    call_listar(proc_name, in_params)   -> lista de dicts (para SYS_REFCURSOR)
    call_dml(proc_name, params)         -> ejecuta un INSERT/UPDATE/DELETE_SP

Python actua unicamente como "canalizador de datos de entrada y
receptor de transacciones del servidor", tal como pide el alcance
del proyecto.
"""

import oracledb
from config import Config


def get_connection():
    """
    Abre una conexion nueva contra Oracle Autonomous DB usando el wallet
    (modo thin de python-oracledb, sin necesidad de Instant Client).
    """
    return oracledb.connect(
        user=Config.DB_USER,
        password=Config.DB_PASSWORD,
        dsn=Config.DB_DSN,
        config_dir=Config.WALLET_LOCATION,
        wallet_location=Config.WALLET_LOCATION,
        wallet_password=Config.WALLET_PASSWORD,
    )


def call_listar(proc_name, in_params=None):
    """
    Llama un procedimiento tipo "..._Listar_SP" que recibe (opcionalmente)
    parametros de filtro y devuelve un SYS_REFCURSOR como ultimo parametro OUT.

    Devuelve una lista de dicts: [{columna: valor, ...}, ...]
    """
    in_params = in_params or []
    conn = get_connection()
    try:
        cur = conn.cursor()
        out_cursor = conn.cursor()
        params = list(in_params) + [out_cursor]
        cur.callproc(proc_name, params)

        columnas = [d[0].lower() for d in out_cursor.description]
        filas = [dict(zip(columnas, fila)) for fila in out_cursor.fetchall()]
        return filas
    finally:
        conn.close()


def call_dml(proc_name, params=None, out_param_type=None):
    """
    Llama un procedimiento de Insertar/Actualizar/Delete (sin cursor de salida).

    Si el procedimiento tiene un parametro OUT (p.ej. para devolver el ID
    generado), pasa out_param_type (p.ej. int) y este helper devuelve su valor.
    """
    params = params or []
    conn = get_connection()
    try:
        cur = conn.cursor()
        if out_param_type is not None:
            out_var = cur.var(out_param_type)
            cur.callproc(proc_name, params + [out_var])
            conn.commit()
            return out_var.getvalue()
        else:
            cur.callproc(proc_name, params)
            conn.commit()
            return None
    finally:
        conn.close()
