from webapp.core import app, db

from webapp.models import Song
from webapp.models import User
from webapp.models import Queue

from flask import request, Response
import json

@app.route("/browse.json")
def browse():
  songs = Song.query.filter_by(status=1).all()

  return Response(json.dumps([x.serialize for x in songs]),  mimetype='application/json')

@app.route("/users.json", methods=["GET", "POST"])
def users():
  if request.method == "POST":
    user = User.query.filter_by(google_plus_id=request.form["googlePlusId"]).first()

    if user is None:
      user = User(request.form["fullName"], request.form["googlePlusId"])
      db.session.add(user)
      db.session.commit()

    return Response(json.dumps(user.serialize),  mimetype='application/json')

@app.route("/queue.json", methods=["GET"])
def queue():
  pass

@app.route("/queue/add.json", methods=["POST"])
def queue_add():
  user = User.query.filter_by(google_plus_id=request.form["googlePlusId"]).first()

  song = db.session.query(Queue).filter(
    Queue.song_id == int(request.form["songId"])
  ).filter(
    Queue.user_id == user.id
  ).first()

  if song is None:
    song = Queue(int(request.form["songId"]), user.id)
  else:
    song.priority += 1

  db.session.add(song)
  db.session.commit()

  return Response(json.dumps(song.serialize),  mimetype='application/json')

@app.route("/timeline.json", methods=["GET"])
def timeline():
  pass

if __name__ == "__main__":
  app.run(host="0.0.0.0", debug=True)
