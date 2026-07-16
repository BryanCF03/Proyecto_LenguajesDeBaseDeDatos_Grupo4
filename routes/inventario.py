from flask import Blueprint, render_template, request, redirect, url_for, flash
from db.connection import call_listar, call_dml

inventario_bp = Blueprint("inventario", __name__, url_prefix="/inventario")


def _catalogos_activos():
    """Productos e insumos activos, para elegir a que item de inventario corresponde."""
    productos = [p for p in call_listar("FIDE_Productos_TB_Listar_SP") if p["id_estado"] == 1]
    insumos = [i for i in call_listar("FIDE_Insumos_TB_Listar_SP") if i["id_estado"] == 1]
    return productos, insumos


@inventario_bp.route("/")
def listar():
    items = call_listar("FIDE_Inventario_Item_TB_Listar_SP")
    return render_template("inventario/list.html", items=items)


@inventario_bp.route("/nuevo", methods=["GET", "POST"])
def nuevo():
    productos, insumos = _catalogos_activos()

    if request.method == "POST":
        tipo = request.form["tipo_item"]  # "producto" o "insumo"
        stock = int(request.form["stock"])
        stock_minimo = int(request.form["stock_minimo"])
        id_estado = int(request.form["id_estado"])

        id_producto = int(request.form["id_producto"]) if tipo == "producto" else None
        id_insumo = int(request.form["id_insumo"]) if tipo == "insumo" else None

        if tipo == "producto" and not request.form.get("id_producto"):
            flash("Selecciona un producto.", "error")
            return render_template("inventario/form.html", item=None, productos=productos, insumos=insumos)
        if tipo == "insumo" and not request.form.get("id_insumo"):
            flash("Selecciona un insumo.", "error")
            return render_template("inventario/form.html", item=None, productos=productos, insumos=insumos)

        call_dml(
            "FIDE_Inventario_Item_TB_Insertar_SP",
            [id_producto, id_insumo, stock, stock_minimo, id_estado],
        )
        flash("Item de inventario creado con exito.", "success")
        return redirect(url_for("inventario.listar"))

    return render_template("inventario/form.html", item=None, productos=productos, insumos=insumos)


@inventario_bp.route("/editar/<int:id_inventario_item>", methods=["GET", "POST"])
def editar(id_inventario_item):
    productos, insumos = _catalogos_activos()

    if request.method == "POST":
        stock = int(request.form["stock"])
        stock_minimo = int(request.form["stock_minimo"])
        id_estado = int(request.form["id_estado"])

        # El producto/insumo asociado a un item de inventario no se reasigna
        # una vez creado (solo se ajusta stock, stock minimo y estado).
        call_dml(
            "FIDE_Inventario_Item_TB_Actualizar_SP",
            [id_inventario_item, stock, stock_minimo, id_estado],
        )
        flash("Item de inventario actualizado con exito.", "success")
        return redirect(url_for("inventario.listar"))

    items = call_listar("FIDE_Inventario_Item_TB_Listar_SP")
    item = next((i for i in items if i["id_inventario_item"] == id_inventario_item), None)

    if item is None:
        flash("Item de inventario no encontrado.", "error")
        return redirect(url_for("inventario.listar"))

    return render_template("inventario/form.html", item=item, productos=productos, insumos=insumos)


@inventario_bp.route("/eliminar/<int:id_inventario_item>", methods=["POST"])
def eliminar(id_inventario_item):
    call_dml("FIDE_Inventario_Item_TB_Delete_SP", [id_inventario_item])
    flash("Item de inventario eliminado (baja logica).", "success")
    return redirect(url_for("inventario.listar"))
