import os
import time

import mutagen

from location import LocationDetecter

SUPPORTED_EXTENSIONS = [ "mp3", "m4a" ]
EXTRACTED_PARAMS = [ "album", "artist", "title", "genre" ] 
TIMEOUT = 1

class Tag(object):

  def __init__(self, mutagen_obj):
    for param in EXTRACTED_PARAMS:
      if param in mutagen_obj:
        setattr(self, param, mutagen_obj[param][0])
      else:
        setattr(self, param, None)

class Notify(object):

  def __init__(self):
    pass

  def run(self):
    self.location = LocationDetecter().get_location()

    while True:
      self.update()
      time.sleep(TIMEOUT)

  def update(self):
    path = self.location.path

    for root, dirs, files in os.walk(path):
      for filename in files:
        if any([ filename.endswith(ext) and not filename.startswith(".") for ext in SUPPORTED_EXTENSIONS ]):
          audiofile = Tag(mutagen.File(root + "/" + filename, easy=True))

          print audiofile

if __name__ == "__main__":
  Notify().run()
