import os
from dotenv import load_dotenv

load_dotenv()  # lee el archivo .env si existe


class Config:
    # --- Conexion a Oracle Autonomous Database (via wallet / mTLS) ---
    DB_USER = os.getenv("DB_USER", "ADMIN")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")
    DB_DSN = os.getenv("DB_DSN", "")  # alias definido en wallet/tnsnames.ora
    WALLET_LOCATION = os.getenv("WALLET_LOCATION", "./wallet")
    WALLET_PASSWORD = os.getenv("WALLET_PASSWORD", "")

    # --- Flask ---
    SECRET_KEY = os.getenv("FLASK_SECRET_KEY", "dev-key-cambiar")
