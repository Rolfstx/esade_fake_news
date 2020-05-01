import os
import sys
import time
import json
import argparse
import requests
import traceback
import pandas as pd
from tqdm import tqdm
from datetime import datetime
from bs4 import BeautifulSoup

class YouTube:
    baseURL = 'https://www.youtube.com/'

    def __init__(self, query, searches=5, branch=3, depth=5, country='US', language='en-US', delay=0.5, name=None, fetch_channels=False, key=None):
        self.query = query
        self.country = country
        self.header = {"Accept-Language": language}
        self.depth = depth
        self.branch = branch
        self.searches = searches
        self.data = []
        self.iterations = self.get_number_iterations()
        self.video_results = self.get_search_results()
        self.videos_loops = []
        self.current_iteration = 0
        self.current_key = ''
        self.delay = delay
        self.name = name
        self.fetch_channels = fetch_channels
        self.key = key

    def run(self):
        try:
            self.loop_searches()
        except Exception as e:
            print(traceback.format_exc())
            print('AN ERROR HAPPENED - TRY AGAIN!', e)
        finally:
            self.save_results()
            self.save_csv()
            if self.fetch_channels:
                print('\n\n########## FETCHING CHANNEL INFO! ##########')
                self.get_channels()

    def get_search_results(self, attempts=0):
        URL = f"{self.baseURL}results?sp=EgIQAQ%253D%253D&q={self.query}&gl={self.country}"
        r = requests.get(URL, headers=self.header)
        soup = BeautifulSoup(r.text, 'html.parser')
        videos = soup.findAll('div', {'class': 'yt-lockup-content'})
        try:
            if videos[0].a.text == 'Wikipedia':
                videos = videos[1:]
        except:
            if attempts > 3:
                print("AN ERROR HAPPENED")
            else:
                self.get_search_results(attempts=attempts+1)
        return [video.a['href'][9:] for video in videos[:self.searches]]

    def loop_searches(self):
        for e, video in enumerate(self.video_results):
            self.current_iteration += 1
            self.current_key = str(e+1)
            data, status_code, title = self.get_video_recommendations(video, self.current_key)
            self.print(video, 1, status_code, self.current_key, title)
            self.current_depth = 1
            self.loop_recursive(data, current_depth=self.current_depth, current_key=self.current_key)

    def loop_recursive(self, data, current_depth, current_key):
        if current_depth < self.depth:
            id = list(data.keys())[0]
            for e, video in enumerate(data[id]['recommendations'][:self.branch]):
                self.current_key = current_key + str(e+1)
                data, status_code, title = self.get_video_recommendations(video, self.current_key)
                self.current_iteration += 1
                self.print(video, current_depth, status_code, self.current_key, title)
                self.loop_recursive(data, current_depth+1, self.current_key)

    def print(self, video, current_depth, status_code, current_key, title):
        extra_spacing = (len(str(self.iterations))-len(str(self.current_iteration)))-2
        print(f"({' '*extra_spacing}{self.current_iteration} / {int(self.iterations)}): Fetching {video} | Status Code {str(status_code):4s} | Depth {current_depth} | Key {self.current_key:{self.depth}s} | {str(title)[:60]:60s}")

    def get_video_recommendations(self, id, key, attempt=0):
        ids = [list(d.keys())[0] for d in self.data]
        if id in ids:
            existing_data = dict(self.data[ids.index(id)][id])
            existing_data['key'] = key
            data = {id: existing_data}
            self.data.append(data)
            return (data, 'COPY', existing_data['title'])
        run, attempts = True, 0
        while run:
            if attempts >= 1:
                time.sleep(15)
            attempts += 1
            soup, status_code = self.get_soup(id)
            try:
                data = self.get_video_info(soup, id, key)
                run = False
            except Exception as e:
                pass
        self.data.append(data)
        return (data, status_code, data[id]['title'])

    def get_video_info(self, soup, id, key):
        recommendations = soup.findAll('div', {'class': 'content-wrapper'})
        recommendations = [recommendation.a['href'][9:] for recommendation in recommendations]
        data = {
            id: {
                'title': soup.title.text[:-10],
                'genre': soup.find('meta', itemprop='genre')['content'],
                'views': soup.find('meta', itemprop='interactionCount')['content'],
                'likes': soup.find('button', {'title': 'I like this'}).text,
                'dislikes': soup.find('button', {'title': 'I dislike this'}).text,
                'description': soup.find('div', {'id': 'watch-description-text'}).text,
                'duration': soup.find('meta', itemprop='duration')['content'],
                'datePublished': soup.find('meta', itemprop='datePublished')['content'],
                'uploadDate': soup.find('meta', itemprop='uploadDate')['content'],
                'key': key,
                'channel': soup.find('a', {'class': 'yt-uix-sessionlink spf-link'}).text,
                'channel_url': soup.find('a', {'class': 'yt-uix-sessionlink spf-link'})['href'],
                'channel_id': soup.find('meta', {'itemprop': 'channelId'})['content'], 
                'recommendations': recommendations
            }
        }
        return data

    def get_soup(self, id, attempt=0):
        time.sleep(self.delay)
        URL = f"{self.baseURL}watch?v={id}"
        r = requests.get(URL, headers=self.header)
        if r.status_code != 200 and attempt < 5:
            print(f'ATTEMPTING URL: {attempt+1}')
            time.sleep(5)
            self.get_soup(id, attempt+1)
        else: 
            pass
        soup = BeautifulSoup(r.text, 'html.parser')
        return soup, r.status_code

    def get_number_iterations(self):
        res = 0
        for i in range(self.depth):
            res += self.branch**(i+1)
        self.iterations = res * (self.searches/self.branch)
        return self.iterations

    def get_iterations(self):
        iterations = []
        for i in range(2, self.depth):
            iters = []
            for x in product(range(self.branch), repeat=i+1):
                iters.append(x)
            iterations.append(iters)
        self.iterations = iterations
        return self.iterations

    def save_results(self):
        if self.name:
            file_name = self.name
        else:
            file_name = self.query.replace(' ', '_')
        if not os.path.exists('data'):
            os.mkdir('data')
        if not os.path.exists('data/videos'):
            os.mkdir('data/videos')
        global time
        time = str(datetime.now())[:19].replace('-', '').replace(':', '').replace(' ', '-')
        file_path = f'data/videos/{time}_{file_name}.json'
        with open(file_path, 'w') as file:
            json.dump(self.data, file, indent=4)
        print(f'########## FETCHING COMPLETED | FILE SAVED TO {file_path} VIDEOS ##########')

    def save_csv(self):
        ids = [list(d.keys())[0] for d in self.data]
        flat_data = []
        for unique_id in set(ids):
            flat = dict(self.data[ids.index(unique_id)][unique_id])
            flat['id'] = unique_id
            flat['recommendations'] = len(flat['recommendations'])
            flat_data.append(flat)
        flat_data = pd.DataFrame(flat_data)
        if self.name:
            file_name = self.name
        else:
            file_name = self.query.replace(' ', '_')
        global file_path_csv
        file_path_csv = f'data/{time}_{file_name}.csv'
        flat_data.to_csv(file_path_csv, index=False)

    def get_channels(self):
        HEADERS = {'Content-type': 'application/json'}
        videos = pd.read_csv(file_path_csv)
        channels = videos['channel_id'].unique()
        channel_data = []
        for channel in tqdm(channels):
            URL = f'https://www.googleapis.com/youtube/v3/channels?part=snippet%2Cstatistics&id={channel}&key={self.key}'
            r = requests.get(URL)
            r.encoding = 'UTF-8'
            data = json.loads(r.text)
            videos.loc[videos['channel_id'] == channel, 'channelDescription'] = data['items'][0]['snippet']['description']
            videos.loc[videos['channel_id'] == channel, 'viewCount'] = data['items'][0]['statistics']['viewCount']
            videos.loc[videos['channel_id'] == channel, 'commentCount'] = data['items'][0]['statistics']['commentCount']
            videos.loc[videos['channel_id'] == channel, 'subscriberCount'] = data['items'][0]['statistics']['subscriberCount']
            videos.loc[videos['channel_id'] == channel, 'hiddenSubscriberCount'] = data['items'][0]['statistics']['hiddenSubscriberCount']
            videos.loc[videos['channel_id'] == channel, 'videoCount'] = data['items'][0]['statistics']['videoCount']
            channel_data.append(data)
        if not os.path.exists('data/channels'):
            os.mkdir('data/channels')
        with open(f'data/channels/{file_path_csv[5:-4]}.json', 'w') as file:
            json.dump(channel_data, file, indent=4)
        videos.to_csv(f'data/{file_path_csv[5:]}', index=False)

def main():
    global parser
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--query', help='The start search query')
    parser.add_argument('--searches', default='5', type=int, help='The number of search results to start the exploration')
    parser.add_argument('--branch', default='3', type=int, help='The branching factor of the exploration')
    parser.add_argument('--depth', default='5', type=int, help='The depth of the exploration')
    parser.add_argument('--country', default='US', help='Country passed to YouTube e.g. US, FR, GB, DE...')
    parser.add_argument('--language', default='en-US', help='Languaged passed to HTML header, en, fr, en-US, ...')
    parser.add_argument('--delay', default='0.5', type=float, help='Adds a delay between requests.')
    parser.add_argument('--name', default=None, help='Name given to the file')
    parser.add_argument('--channels', default=False, type=bool, help='If channel info should be fetched (requires Google API Key)')
    parser.add_argument('--key', default=None, help='Your Google API Key')
    args = parser.parse_args()
    youtube = YouTube(args.query, args.searches, args.branch, args.depth, args.country, args.language, args.delay, args.name, args.channels, args.key)
    user_input = True
    if youtube.iterations > 9999:
        user_input = input(f"You will make {int(youtube.iterations)} iterations. Are you sure you want to continue [y/n]\n\n>>> ").lower()
    if user_input in [True, 'yes', 'y', 'yes', 'ok']:
        print(f'########## INITIALIZING YOUTUBE CRAWLER | FETCHING {int(youtube.iterations)} VIDEOS ##########')
        youtube.run()
    else:
        print(f'########## INTERRUPTED ##########')

if __name__ == "__main__":
    sys.exit(main())