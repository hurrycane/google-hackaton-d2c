import os
import time

import mutagen

from webapp.core import db
from webapp.models import Song
from indexer.location import LocationDetecter

SUPPORTED_EXTENSIONS = [ "mp3", "m4a" ]
EXTRACTED_PARAMS = [ "album", "artist", "title", "genre" ] 
TIMEOUT = 1

class Tag(object):

  def __init__(self, mutagen_obj):
    self._params = {}

    for param in EXTRACTED_PARAMS:
      if param in mutagen_obj:
        setattr(self, param, mutagen_obj[param][0])
        # for to_filter
        self._params[param] = mutagen_obj[param][0]
      else:
        setattr(self, param, None)

  def to_filter(self):
    return self._params

class Indexer(object):

  def __init__(self):
    pass

  def run(self):
    self.location = LocationDetecter().get_location()

    #while True:
    self.update()
    #  time.sleep(TIMEOUT)

  def update(self):
    path = self.location.path

    updated = []

    for root, dirs, files in os.walk(path):
      for filename in files:
        if any([ filename.endswith(ext) and not filename.startswith(".") for ext in SUPPORTED_EXTENSIONS ]):
          audiofile = Tag(mutagen.File(root + "/" + filename, easy=True))

          filters = audiofile.to_filter()
          song = Song.query.filter_by(**filters).first()

          if song == None:
            song = Song(**filters)
            db.session.add(song)
            db.session.commit()

            updated.append(song.id)
          else:
            updated.append(song.id)

    db.session.execute(db.update(Song).where(db.not_(Song.id.in_(updated))).values(status=0))
    db.session.commit()
