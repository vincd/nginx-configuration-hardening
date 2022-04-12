from flask import Flask, send_file

app = Flask(__name__)

# vulnerable Flask app: don't copy it ;)
@app.route("/<path:path>")
def vuln(path):
    return send_file(path)

if __name__ == "__main__":
    app.run(debug=True, port=8000, host='0.0.0.0')
