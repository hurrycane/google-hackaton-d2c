from webapp.core import app, db

from webapp.models import Song
from webapp.models import User

from flask import request
import json

@app.route("/browse.json")
def browse():
  songs = Song.query.all()

  return json.dumps([x.serialize for x in songs])

@app.route("/users.json", methods=['GET', 'POST'])
def users():
  if request.method == "POST":
    user = User(request.form['fullname'], request.form['googlePlusId'])
    db.session.add(user)
    db.session.commit()

    return json.dumps(user.serialize)

if __name__ == "__main__":
  app.run(host='0.0.0.0', debug=True)
