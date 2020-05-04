import json
import graphistry
import pandas as pd

file_name = 'data/videos/20200501-145335_the_earth_is_flat.json'

with open(file_name, 'r') as file:
    data = json.loads(file.read())

network = []

for video in data:
    id = list(video.keys())[0]
    recommendations = video[id]['recommendations']
    title = video[id]['title']
    for recommendation in recommendations:
        network.append([id, recommendation, title])


df = pd.DataFrame(network, columns=['source', 'destination', 'title'])
graphistry.register(key='8516ae2040123b8d54680c6b259df909871bda458f3f4690728093c7ce896e79')
graphistry.bind(source='title', destination='destination').plot(df)