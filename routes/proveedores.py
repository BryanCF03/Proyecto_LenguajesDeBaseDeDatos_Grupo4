from flask import Blueprint, render_template, request, redirect, url_for, flash
from db.connection import call_listar, call_dml

proveedores_bp = Blueprint("proveedores", __name__, url_prefix="/proveedores")


@proveedores_bp.route("/")
def listar():
    proveedores = call_listar("FIDE_Proveedores_TB_Listar_SP")
    return render_template("proveedores/list.html", proveedores=proveedores)


@proveedores_bp.route("/nuevo", methods=["GET", "POST"])
def nuevo():
    if request.method == "POST":
        nombre = request.form["nombre_proveedor"].strip()
        id_estado = int(request.form["id_estado"])

        if not nombre:
            flash("El nombre del proveedor es obligatorio.", "error")
            return render_template("proveedores/form.html", proveedor=None)

        call_dml("FIDE_Proveedores_TB_Insertar_SP", [nombre, id_estado])
        flash("Proveedor creado con exito.", "success")
        return redirect(url_for("proveedores.listar"))

    return render_template("proveedores/form.html", proveedor=None)


@proveedores_bp.route("/editar/<int:id_proveedor>", methods=["GET", "POST"])
def editar(id_proveedor):
    if request.method == "POST":
        nombre = request.form["nombre_proveedor"].strip()
        id_estado = int(request.form["id_estado"])

        if not nombre:
            flash("El nombre del proveedor es obligatorio.", "error")
            return redirect(url_for("proveedores.editar", id_proveedor=id_proveedor))

        call_dml("FIDE_Proveedores_TB_Actualizar_SP", [id_proveedor, nombre, id_estado])
        flash("Proveedor actualizado con exito.", "success")
        return redirect(url_for("proveedores.listar"))

    # Buscamos el proveedor dentro del listado (evita otro SELECT directo)
    proveedores = call_listar("FIDE_Proveedores_TB_Listar_SP")
    proveedor = next((p for p in proveedores if p["id_proveedor"] == id_proveedor), None)

    if proveedor is None:
        flash("Proveedor no encontrado.", "error")
        return redirect(url_for("proveedores.listar"))

    return render_template("proveedores/form.html", proveedor=proveedor)


@proveedores_bp.route("/eliminar/<int:id_proveedor>", methods=["POST"])
def eliminar(id_proveedor):
    call_dml("FIDE_Proveedores_TB_Delete_SP", [id_proveedor])
    flash("Proveedor eliminado (baja logica).", "success")
    return redirect(url_for("proveedores.listar"))
