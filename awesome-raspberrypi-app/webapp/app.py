from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from settings import settings

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = settings['SQLALCHEMY_DATABASE_URI']
db = SQLAlchemy(app)

from models import User
from models import Song

@app.route("/browse")
def browse():
  return jsonify()

if __name__ == "__main__":
  app.run(host='0.0.0.0')
