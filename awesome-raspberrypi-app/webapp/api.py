from webapp.core import app, db

from webapp.models import Song
from webapp.models import User
from webapp.models import Queue
from webapp.models import History

from flask import request, Response
import json

SONG_ADDED = 0
SONG_PLAYING = 1
SONG_PLAYED = 2

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
  songs = Queue.query.filter_by(status=SONG_ADDED).order_by(Queue.priority.desc(), Queue.id.asc()).all()

  return Response(json.dumps([x.serialize for x in songs]),  mimetype='application/json')

@app.route("/queue/add.json", methods=["POST"])
def queue_add():
  user = User.query.filter_by(google_plus_id=request.form["googlePlusId"]).first()

  song = db.session.query(Queue).filter(
    Queue.song_id == int(request.form["songId"])
  ).filter(
    Queue.status == SONG_ADDED
  ).first()

  if song is None:
    song = Queue(int(request.form["songId"]), user.id)
  else:
    history = db.session.query(History).filter(
      History.user_id == user.id
    ).filter(
      History.queue_id == song.id
    ).all()

    if not history:
      song.priority += 1
      history = History(song.id, user.id)
      db.session.add(history)

  db.session.add(song)
  db.session.commit()

  return Response(json.dumps(song.serialize),  mimetype='application/json')

@app.route("/queue/top.json", methods=["GET"])
def queue_top():
  song = Queue.query.filter_by(status=SONG_ADDED).order_by(Queue.priority.desc(), Queue.id.asc()).first()

  if not song:
    song = db.engine.execute("""SELECT Songs.id FROM songs Songs
      WHERE Songs.id NOT IN (
        SELECT song_id FROM queue ORDER BY id DESC LIMIT 10
      ) ORDER BY RANDOM() LIMIT 1""")
    song = song.fetchone()
    song = Queue(song["id"], None)

    db.session.add(song)
    db.session.commit()

  if song:
    song.status = SONG_PLAYING
    db.session.commit()

  song = song.serialize if song else {} 

  return Response(json.dumps(song),  mimetype='application/json')

@app.route("/queue/now.json", methods=["GET"])
def queue_now():
  song = Queue.query.filter_by(status=SONG_PLAYING).order_by(Queue.priority.desc(), Queue.id.asc()).first()
  song = song.serialize if song else {} 

  return Response(json.dumps(song),  mimetype='application/json')

@app.route("/queue/finish.json", methods=["PUT"])
def queue_finish():
  songs = Queue.query.filter_by(status=SONG_PLAYING).all()

  for song in songs:
    song.status = SONG_PLAYED

  db.session.commit()

  return Response(json.dumps([x.serialize for x in songs]),  mimetype='application/json')

@app.route("/timeline.json", methods=["GET"])
def timeline():
  songs = Queue.query.filter_by(status=SONG_PLAYED).order_by(
    Queue.priority.desc(), Queue.id.asc()
  ).limit(20).all()
  songs = [x.serialize for x in songs]

  now_playing = Queue.query.filter_by(status=SONG_PLAYING).order_by(Queue.priority.desc(), Queue.id.asc()).first()
  if now_playing:
    songs.insert(0, now_playing.serialize)
  
  return Response(json.dumps(songs),  mimetype='application/json')

if __name__ == "__main__":
  app.run(host="0.0.0.0", debug=True)
