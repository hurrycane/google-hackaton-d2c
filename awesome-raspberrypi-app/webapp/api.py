from webapp.core import app

from webapp.models import Song
from webapp.models import User

@app.route("/browse")
def browse():
  return jsonify("")

if __name__ == "__main__":
  app.run(host='0.0.0.0', debug=True)
