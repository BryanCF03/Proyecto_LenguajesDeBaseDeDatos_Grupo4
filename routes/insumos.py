from flask import Blueprint, render_template, request, redirect, url_for, flash
from db.connection import call_listar, call_dml

insumos_bp = Blueprint("insumos", __name__, url_prefix="/insumos")


def _catalogos_activos():
    """Unidades de medida y categorias activas, para llenar los <select> del formulario."""
    unidades = [u for u in call_listar("FIDE_Unidades_Medidas_TB_Listar_SP") if u["id_estado"] == 1]
    categorias = [c for c in call_listar("FIDE_Categorias_TB_Listar_SP") if c["id_estado"] == 1]
    return unidades, categorias


@insumos_bp.route("/")
def listar():
    insumos = call_listar("FIDE_Insumos_TB_Listar_SP")
    return render_template("insumos/list.html", insumos=insumos)


@insumos_bp.route("/nuevo", methods=["GET", "POST"])
def nuevo():
    unidades, categorias = _catalogos_activos()

    if request.method == "POST":
        nombre = request.form["nombre_insumo"].strip()
        stock = request.form["stock"]
        id_unidad = request.form["id_unidad_medida"]
        id_categoria = request.form["id_categoria"]
        id_estado = int(request.form["id_estado"])

        if not nombre:
            flash("El nombre del insumo es obligatorio.", "error")
            return render_template("insumos/form.html", insumo=None, unidades=unidades, categorias=categorias)

        call_dml("FIDE_Insumos_TB_Insertar_SP", [nombre, int(stock), int(id_unidad), int(id_categoria), id_estado])
        flash("Insumo creado con exito.", "success")
        return redirect(url_for("insumos.listar"))

    return render_template("insumos/form.html", insumo=None, unidades=unidades, categorias=categorias)


@insumos_bp.route("/editar/<int:id_insumo>", methods=["GET", "POST"])
def editar(id_insumo):
    unidades, categorias = _catalogos_activos()

    if request.method == "POST":
        nombre = request.form["nombre_insumo"].strip()
        stock = request.form["stock"]
        id_unidad = request.form["id_unidad_medida"]
        id_categoria = request.form["id_categoria"]
        id_estado = int(request.form["id_estado"])

        if not nombre:
            flash("El nombre del insumo es obligatorio.", "error")
            return redirect(url_for("insumos.editar", id_insumo=id_insumo))

        call_dml(
            "FIDE_Insumos_TB_Actualizar_SP",
            [id_insumo, nombre, int(stock), int(id_unidad), int(id_categoria), id_estado],
        )
        flash("Insumo actualizado con exito.", "success")
        return redirect(url_for("insumos.listar"))

    insumos = call_listar("FIDE_Insumos_TB_Listar_SP")
    insumo = next((i for i in insumos if i["id_insumo"] == id_insumo), None)

    if insumo is None:
        flash("Insumo no encontrado.", "error")
        return redirect(url_for("insumos.listar"))

    return render_template("insumos/form.html", insumo=insumo, unidades=unidades, categorias=categorias)


@insumos_bp.route("/eliminar/<int:id_insumo>", methods=["POST"])
def eliminar(id_insumo):
    call_dml("FIDE_Insumos_TB_Delete_SP", [id_insumo])
    flash("Insumo eliminado (baja logica).", "success")
    return redirect(url_for("insumos.listar"))
