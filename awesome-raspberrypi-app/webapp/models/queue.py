from webapp.core import db
from flask.ext.sqlalchemy import SQLAlchemy
from datetime import datetime

class Queue(db.Model):
  __tablename__ = "queue"

  id = db.Column(db.Integer, primary_key=True)
  song_id = db.Column(db.Integer(10), db.ForeignKey('songs.id'))
  user_id = db.Column(db.Integer(10), db.ForeignKey('users.id'))
  priority = db.Column(db.Integer(10))
  status = db.Column(db.Integer(1))
  created = db.Column(db.DateTime())

  song = db.relationship("Song")
  user = db.relationship("User")

  def __init__(self, song_id, user_id, priority=1, status=0, created=datetime.now()):
    self.song_id = song_id
    self.user_id = user_id
    self.priority = priority
    self.status = status
    self.created = created

  @property
  def serialize(self):
    return {
      "priority": self.priority,
      "user": self.user.serialize if self.user else None,
      "song": self.song.serialize,
      "status": self.status
    }
