from core import app

from models import Song
from models import User

@app.route("/browse")
def browse():
  return jsonify("")

if __name__ == "__main__":
  app.run(host='0.0.0.0', debug=True)
