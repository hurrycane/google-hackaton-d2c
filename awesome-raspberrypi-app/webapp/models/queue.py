from webapp.core import db
from flask.ext.sqlalchemy import SQLAlchemy

class Queue(db.Model):
  __tablename__ = "queue"

  id = db.Column(db.Integer, primary_key=True)
  song_id = db.Column(db.Integer(10))
  user_id = db.Column(db.Integer(10))
  priority = db.Column(db.Integer(10))
  status = db.Column(db.Integer(1))
 
  def __init__(self, song_id, user_id, priority=1, status=0):
    self.song_id = song_id
    self.user_id = user_id
    self.priority = priority
    self.status = status

  @property
  def serialize(self):
    return {
      "songId": self.song_id,
      "userId": self.user_id,
      "priority": self.priority,
      "status": self.status
    }
