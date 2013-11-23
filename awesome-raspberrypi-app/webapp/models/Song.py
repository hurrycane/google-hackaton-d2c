from app import db
from flask.ext.sqlalchemy import SQLAlchemy

class Song(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	artist = db.Column(db.String(255))
	album = db.Column(db.String(255))
	cover = db.Column(db.String(255))
	song_name = db.Column(db.String(255))
	genre = db.Column(db.String(255))
	duration = db.Column(db.Integer(10))
	source = db.Column(db.String(255))
	status = db.Column(db.Boolean())
	created = db.Column(db.DateTime())
