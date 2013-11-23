import subprocess

class Location(object):

  def __init__(self, path):
    self._path = path

  @property
  def path(self):
    return self._path

class LocationDetecter(object):

  @classmethod
  def get_location(cls):
    #output = subprocess.call("ls -l /dev/sd*", shell=True)
    #print output

    return Location("/Volumes/UNTITLED/")
