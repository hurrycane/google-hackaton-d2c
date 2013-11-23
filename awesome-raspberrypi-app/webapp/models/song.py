from datetime import datetime

from webapp.core import db
from flask.ext.sqlalchemy import SQLAlchemy

class Song(db.Model):
  __tablename__ = "songs"

  id = db.Column(db.Integer, primary_key=True)
  artist = db.Column(db.String(255))
  album = db.Column(db.String(255))
  cover = db.Column(db.String(255))
  title = db.Column(db.String(255))
  genre = db.Column(db.String(255))
  duration = db.Column(db.Integer(10))
  source = db.Column(db.String(255))
  status = db.Column(db.Boolean())
  created = db.Column(db.DateTime())

  def __init__(self, artist=None, album=None, cover=None, title=None,
               genre=None, duration=None, source=None, status=True,
               created=None):

    self.artist = artist
    self.album = album
    self.cover = cover
    self.title = title
    self.duration = duration
    self.source = source
    self.status = status
    self.genre = genre

    if not created:
      self.created = datetime.now()
    else:
      self.created = created

  @property
  def serialize(self):
    return {
      "id": self.id,
      "artist": self.artist,
      "album": self.album,
      "cover": self.cover,
      "title": self.title,
      "genre": self.genre,
      "duration": self.duration,
      # "source": self.source,
      # "status": self.status,
      "created": self.created.strftime("%Y-%m-%d %H:%M:%S")
    }
