from flask import Flask, render_template
from config import Config
from routes.proveedores import proveedores_bp

app = Flask(__name__)
app.config.from_object(Config)

app.register_blueprint(proveedores_bp)

# A medida que se completen los demas modulos (Productos, Insumos,
# Ventas, Compras, Inventario, Recetas, Ordenes de Produccion,
# Facturas, Usuarios, etc.) se registran aqui con su propio blueprint,
# siguiendo el mismo patron que routes/proveedores.py


@app.route("/")
def home():
    return render_template("home.html")


if __name__ == "__main__":
    app.run(debug=True, port=5000)
