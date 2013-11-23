from webapp.core import db
from flask.ext.sqlalchemy import SQLAlchemy

class User(db.Model):
  __tablename__ = "users"

  id = db.Column(db.Integer, primary_key=True)
  fullname = db.Column(db.String(255))
  google_plus_id = db.Column(db.String(255), unique=True)
 
  def __init__(self, fullname, google_plus_id):
    self.fullname = fullname
    self.google_plus_id = google_plus_id

  @property
  def serialize(self):
    return {
      "id": self.id,
      "fullName": self.fullname,
      "googlePlusId": self.google_plus_id
    }
