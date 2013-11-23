from webapp.core import db
from flask.ext.sqlalchemy import SQLAlchemy

class History(db.Model):
  __tablename__ = "history"

  id = db.Column(db.Integer, primary_key=True)
  queue_id = db.Column(db.Integer(10))
  user_id = db.Column(db.Integer(10))
 
  def __init__(self, queue_id, user_id):
    self.queue_id = queue_id
    self.user_id = user_id

  @property
  def serialize(self):
    return {
      "id": self.id,
      "userId": self.user_id,
      "queueId": self.queue_id
    }
