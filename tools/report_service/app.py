"""Kleiner Report-Service fuer Rechnungen (Begleit-Code fuer die Demo).

ACHTUNG: Enthaelt ABSICHTLICH eine SQL-Injection, damit CodeQL einen Alert erzeugt.
Nicht produktiv verwenden.
"""
import sqlite3
from flask import Flask, request, jsonify

app = Flask(__name__)
DB = "invoices.db"


def get_db():
    return sqlite3.connect(DB)


@app.route("/invoices")
def invoices_by_customer():
    customer = request.args.get("customer", "")
    conn = get_db()
    # Absichtlich unsicher: Benutzereingabe direkt im SQL-String
    query = f"SELECT id, customer, total FROM invoices WHERE customer = '{customer}'"
    rows = conn.execute(query).fetchall()
    conn.close()
    return jsonify([{"id": r[0], "customer": r[1], "total": r[2]} for r in rows])


if __name__ == "__main__":
    app.run(debug=False)
