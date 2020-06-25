import os
import sys
import json
import argparse
import youtube_dl
from tqdm import tqdm
from youtube_dl.utils import DownloadError

# Example:
# python subtitles.py --path "data/videos/20200504-193926_joe_biden.json"

def download_subs(PATH):
    with open(PATH, 'r') as f:
        videos = json.loads(f.read())
    videos = set([list(video.keys())[0] for video in videos])
    DIR = f"subtitles_{PATH.split('/')[-1][:-5]}".replace(" ", "_")
    if not os.path.exists(DIR):
        os.mkdir(DIR)
    for video in videos:
        if os.path.isfile(f"{DIR}/{video}.en.vtt"):
            continue
        URL = f"https://www.youtube.com/watch?v={video}"
        opts = {
            "skip_download": True,
            "writeautomaticsub": "%(name)s.vtt",
            "subtitlelangs": "en",
            "outtmpl": f"{DIR}/{video}",
            "verbose": False
        }
        try:
            with youtube_dl.YoutubeDL(opts) as yt:
                yt.download([URL])
        except youtube_dl.utils.DownloadError:
            print("######### DOWNLOAD ERROR #########")
            print(f"# COULD NOT DOWNLOAD {video} #")
            print("######### DOWNLOAD ERROR #########")

if __name__ == '__main__':
    if sys.argv[1] == "--path":
        if os.path.exists(sys.argv[2]):
            download_subs(sys.argv[2])
        else:
            print("COULD NOT FIND PATH. TRY AGAIN!")
