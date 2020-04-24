import os
import sys
import json
import argparse
import youtube_dl
from tqdm import tqdm
from youtube_dl.utils import DownloadError

# Example:
# python get_subtitles.py --path "../results/20200319_Joe_Biden-2020-03-19.json"

def download_subs(PATH):
    with open(PATH, 'r') as f:
        data = json.loads(f.read())
    DIR = f"subtitles_{PATH.split('/')[-1][:-5]}".replace(" ", "_")
    if not os.path.exists(DIR):
        os.mkdir(DIR)
    for topic in data.keys():
        for video in tqdm(data[topic]):
            IDX = video["id"]
            if os.path.isfile(f"{DIR}/{IDX}.en.vtt"):
                continue
            URL = f"https://www.youtube.com/watch?v={IDX}"
            opts = {
                "skip_download": True,
                "writeautomaticsub": "%(name)s.vtt",
                "subtitlelangs": "en",
                "outtmpl": f"{DIR}/{IDX}",
                "verbose": False
            }
            try:
                with youtube_dl.YoutubeDL(opts) as yt:
                    yt.download([URL])
            except youtube_dl.utils.DownloadError:
                print("######### DOWNLOAD ERROR #########")
                print(f"# COULD NOT DOWNLOAD {video['id']} #")
                print("######### DOWNLOAD ERROR #########")

if __name__ == '__main__':
    if sys.argv[1] == "--path":
        if os.path.exists(sys.argv[2]):
            download_subs(sys.argv[2])
        else:
            print("COULD NOT FIND PATH. TRY AGAIN!")
