from webapp.core import app, db

from webapp.models import Song
from webapp.models import User

from flask import request
import json

@app.route("/browse.json")
def browse():
  songs = Song.query.filter_by(status=1).all()

  return json.dumps([x.serialize for x in songs])

@app.route("/users.json", methods=["GET", "POST"])
def users():
  if request.method == "POST":
    user = User.query.filter_by(google_plus_id=request.form["googlePlusId"]).first()

    if user is None:
      user = User(request.form["fullName"], request.form["googlePlusId"])
      db.session.add(user)
      db.session.commit()

    return json.dumps(user.serialize)

@app.route("/queue.json", methods=["GET", "POST"])
def queue():
  if request.method == "POST":
    pass
  if request.method == "GET":
    pass

if __name__ == "__main__":
  app.run(host="0.0.0.0", debug=True)
