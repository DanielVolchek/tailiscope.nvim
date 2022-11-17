#!/usr/local/bin/python3

import re
import json
from os.path import abspath, join, dirname
import urllib.request
from shutil import copyfile

# Create a request with a valid User-Agent
req = urllib.request.Request(
    'https://tailwindcss.com/docs',
    data=None,
    headers={
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) ' +
        'AppleWebKit/537.36 (KHTML, like Gecko) ' +
        'Chrome/35.0.1916.47 Safari/537.36'
    }
)

# Pull the html from the main docs page and find all /docs links
docs = urllib.request.urlopen(req)
links = re.findall('href="(/docs/.*?)"', docs.read().decode('utf-8'))

found = []
pages = []

# Compile all the info for the pages
for url in sorted(set(links)):
    topic = url.split('/')[2].title().replace('-', ' ').split('#')[0]
    slug = url.split('/')[2].split('#')[0]

    if (topic not in found):
        found.append(topic)
        pages.append({
            "topic": topic,
            "slug": slug,
        })

parsedPages = []
for page in pages:
    parsedPages.append('{"%s", "%s"}' % (page["topic"], page["slug"])) 

outfile = '../lua/tailiscope/docs.lua'
with open(join(abspath(dirname(__file__)), outfile), 'w') as f:
    f.write('return {\n')
    f.write('\t{"Cheat Sheet", "cheat-sheet"},\n')
    for page in parsedPages:
        f.write('\t%s,\n' % page)
    f.write('}')

print('Extension files have been built.')
