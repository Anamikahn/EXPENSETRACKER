from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from datetime import datetime

app = Flask(__name__)
CORS(app)

# ---------------- DATABASE CONNECTION ----------------
mysql_conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="heeseung",
    database="mini_project_db"
)

# ---------------- GLOBAL LOGIN STATE (FOR MINI PROJECT) ----------------
logged_in_user_id = None


# ---------------- HELPER FUNCTION ----------------
def is_empty(value):
    return value is None or str(value).strip() == ""


# ---------------- SIGNUP ----------------
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json

    username = data.get('username')
    password = data.get('password')
    phone = data.get('phone')
    balance = data.get('balance')

    if is_empty(username) or is_empty(password) or is_empty(phone) or balance is None:
        return jsonify({"success": False, "message": "All fields are required"}), 400

    if balance < 0:
        return jsonify({"success": False, "message": "Balance cannot be negative"}), 400

    cur = mysql_conn.cursor(buffered=True)

    cur.execute("SELECT id FROM users WHERE username=%s", (username,))
    if cur.fetchone():
        cur.close()
        return jsonify({"success": False, "message": "Username already exists"}), 409

    cur.execute(
        "INSERT INTO users(username, password, phone, balance) VALUES (%s, %s, %s, %s)",
        (username, password, phone, balance)
    )

    mysql_conn.commit()
    cur.close()

    return jsonify({"success": True}), 201


# ---------------- LOGIN ----------------
@app.route('/login', methods=['POST'])
def login():
    global logged_in_user_id

    data = request.json
    username = data.get('username')
    password = data.get('password')

    if is_empty(username) or is_empty(password):
        return jsonify({"success": False, "message": "Username and password required"}), 400

    cur = mysql_conn.cursor(buffered=True)
    cur.execute(
        "SELECT id, balance FROM users WHERE username=%s AND password=%s",
        (username, password)
    )
    user = cur.fetchone()
    cur.close()

    if not user:
        return jsonify({"success": False, "message": "Invalid credentials"}), 401

    logged_in_user_id = user[0]

    return jsonify({
        "success": True,
        "balance": float(user[1])
    })
 
    '''
    return jsonify({ #newly added
    "success": True,
    "user_id": user[0],
    "balance": float(user[1])
})'''


# ---------------- GET ALL EXPENSES ----------------
@app.route('/expenses', methods=['GET'])
def get_expenses():
    if logged_in_user_id is None:
        return jsonify({"success": False, "message": "Not logged in"}), 401

    cur = mysql_conn.cursor(buffered=True)
    cur.execute(
        "SELECT id, amount, date, time, category FROM expenses WHERE user_id=%s",
        (logged_in_user_id,)
    )

    rows = cur.fetchall()
    cur.close()

    expenses = []
    for r in rows:
        expenses.append({
            "id": r[0],
            "amount": float(r[1]),
            "date": str(r[2]),
            "time": str(r[3]),
            "category": r[4]
        })

    return jsonify(expenses)


# ---------------- ADD EXPENSE (AUTO DATE & TIME) ----------------
@app.route('/expenses', methods=['POST'])
def add_expense():
    if logged_in_user_id is None:
        return jsonify({"success": False, "message": "Not logged in"}), 401

    data = request.json
    amount = data.get('amount')
    category = data.get('category')

    if amount is None or is_empty(category):
        return jsonify({"success": False, "message": "Amount and category required"}), 400

    if amount <= 0:
        return jsonify({"success": False, "message": "Amount must be positive"}), 400

    now = datetime.now()
    date = now.date()
    time = now.time()

    cur = mysql_conn.cursor(buffered=True)

    cur.execute(
        "INSERT INTO expenses(amount, date, time, category, user_id) VALUES (%s, %s, %s, %s, %s)",
        (amount, date, time, category, logged_in_user_id)
    )

    expense_id = cur.lastrowid

    cur.execute(
        "UPDATE users SET balance = balance - %s WHERE id=%s",
        (amount, logged_in_user_id)
    )

    mysql_conn.commit()
    cur.close()

    return jsonify({"success": True, "id": expense_id}), 201

'''
# ---------------- ADD EXPENSE (AUTO DATE & TIME) ----------------
@app.route('/expenses', methods=['POST'])
def add_expense():
    data = request.json

    amount = data.get('amount')
    category = data.get('category')
    user_id = data.get('user_id')

    if not user_id:
        return jsonify({"success": False, "message": "User ID required"}), 400

    if amount is None or is_empty(category):
        return jsonify({"success": False, "message": "Amount and category required"}), 400

    now = datetime.now()
    date = now.date()
    time = now.time()

    cur = mysql_conn.cursor(buffered=True)

    cur.execute(
        "INSERT INTO expenses(amount, date, time, category, user_id) VALUES (%s, %s, %s, %s, %s)",
        (amount, date, time, category, user_id)
    )

    cur.execute(
        "UPDATE users SET balance = balance - %s WHERE id=%s",
        (amount, user_id)
    )

    mysql_conn.commit()
    cur.close()

    return jsonify({"success": True}), 201
'''

# ---------------- EDIT EXPENSE (PARTIAL UPDATE) ----------------
@app.route('/expenses/<int:expense_id>', methods=['PUT'])
def edit_expense(expense_id):
    if logged_in_user_id is None:
        return jsonify({"success": False, "message": "Not logged in"}), 401

    data = request.json

    cur = mysql_conn.cursor(buffered=True)

    cur.execute(
        "SELECT amount, category FROM expenses WHERE id=%s AND user_id=%s",
        (expense_id, logged_in_user_id)
    )
    row = cur.fetchone()

    if not row:
        cur.close()
        return jsonify({"success": False, "message": "Expense not found"}), 404

    old_amount, old_category = row

    new_amount = data.get('amount', old_amount)
    category = data.get('category', old_category)

    if new_amount <= 0:
        cur.close()
        return jsonify({"success": False, "message": "Amount must be positive"}), 400

    difference = new_amount - old_amount

    cur.execute(
        "UPDATE expenses SET amount=%s, category=%s WHERE id=%s",
        (new_amount, category, expense_id)
    )

    cur.execute(
        "UPDATE users SET balance = balance - %s WHERE id=%s",
        (difference, logged_in_user_id)
    )

    mysql_conn.commit()
    cur.close()

    return jsonify({"success": True})


# ---------------- DELETE EXPENSE ----------------
@app.route('/expenses/<int:expense_id>', methods=['DELETE'])
def delete_expense(expense_id):
    if logged_in_user_id is None:
        return jsonify({"success": False, "message": "Not logged in"}), 401

    cur = mysql_conn.cursor(buffered=True)

    cur.execute(
        "SELECT amount FROM expenses WHERE id=%s AND user_id=%s",
        (expense_id, logged_in_user_id)
    )
    row = cur.fetchone()

    if not row:
        cur.close()
        return jsonify({"success": False, "message": "Expense not found"}), 404

    amount = row[0]

    cur.execute("DELETE FROM expenses WHERE id=%s", (expense_id,))
    cur.execute(
        "UPDATE users SET balance = balance + %s WHERE id=%s",
        (amount, logged_in_user_id)
    )

    mysql_conn.commit()
    cur.close()

    return jsonify({"success": True})


# ---------------- RUN SERVER ----------------
if __name__ == '__main__':
    app.run(debug=True)