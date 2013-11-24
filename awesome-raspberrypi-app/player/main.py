import requests
import json
import time
import subprocess

from multiprocessing import Process, Pipe

ENDPOINT = "http://192.168.2.68:5000"

class RestClient(object):

  def __init__(self, endpoint):
    self.endpoint = endpoint

  def finish(self):
    return requests.put(ENDPOINT + "/queue/finish.json")

  def top(self):
    return json.loads(requests.get(ENDPOINT + "/queue/top.json").text)

class Player(object):

  def __init__(self):
    pass

  def play_song(self, song):
    # vlc HugeWAV.wav --quiet --play-and-exit -I dummy --start-time 16
    print "vlc %s --quiet --play-and-exit -I dummy" % song["source"]
    subprocess.call("vlc \"%s\" --quiet --play-and-exit -I dummy" % song["source"], shell=True)

  def play(self):
    client = RestClient(ENDPOINT)

    client.finish()

    while True:
      response = client.top()
      # open process and play
      proc = Process(target=self.play_song, args=(response["song"],))
      proc.start()
      proc.join()

      client.finish()
