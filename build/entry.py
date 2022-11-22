# if anyone knows why this is super slow and wants to fix it be my guest
# its not a big deal since it rarely ever needs to run but all code improvement is good code improvement


import os
from selenium import webdriver
from selenium.webdriver.common.by import By

link = "https://nerdcave.com/tailwind-cheat-sheet"
driver = webdriver.Chrome()
driver.get(link)

doc_path = os.path.join("../lua/tailiscope", "docs/")

if not os.path.exists(doc_path):
    os.makedirs(doc_path)

all_file = open(doc_path + "all.lua", "w+")
category_file = open(doc_path + "categories.lua", "w+")
classes_file = open(doc_path + "classes.lua", "w+")


btns = driver.find_elements(By.CSS_SELECTOR, "button")
containers = driver.find_elements(By.CSS_SELECTOR, 'div:has( > header)')


for b in btns:
    if b.text == "EXPAND ALL":
        expander = b
        expander.click()
        break


items = []

# most of the lag comes from right here
for c in containers:
    category = c.find_element(By.CSS_SELECTOR, 'header > h2').text
    items.append({'name': category, 'items': []})

    lis = c.find_elements(By.CSS_SELECTOR, 'li')
    for li in lis:
        type = li.find_element(By.CSS_SELECTOR, 'span').text
        link = li.find_element(By.CSS_SELECTOR, 'a').get_attribute('href')
        desc = li.find_element(By.CSS_SELECTOR, 'p').text
        items[-1]['items'].append(
            {'name': type, 'items': [], 'doc': link, 'desc': desc}
        )
        table = li.find_element(By.CSS_SELECTOR, 'table')
        trs = table.find_elements(By.CSS_SELECTOR, 'tr')
        print('table: ', type)
        for t in trs:
            tds = t.find_elements(By.CSS_SELECTOR, 'td')
            value = tds[1].text
            if tds[2] and tds[2].text != '':
                value += '\t' + tds[2].text
            items[-1]['items'][-1]['items'].append({
                'name': tds[0].text,
                'value': value,
            })

def replace_char(str):
    chars = [" ", "-", ":", ",", "/"]
    temp = ""
    for s in str:
        c = s
        if s in chars:
            c = "_"
        temp += c
    # todo choose appropriate char to replace with and split accordingly in lua
    return temp.lower().replace("\n", "|")


def recursive_write(name, items):

    # path of the file to write to passed in before hand
    # i.e breakpoint.lua file should have the classes contained in breakpoint category
    path = os.path.join(doc_path, replace_char(name)+".lua")
    with open(path, "w+") as f:
        f.write('return {\n')
        for item in items:
            writeTo = [f, all_file]
            value = ""
            # if the item has subitems we run the function again
            if item.get('items') is not None:
                recursive_write(item['name'], item['items'])
                value = "'%s'" % replace_char(item['name'])
            # otherwise we have a class and write the class name + the css
            # replace the \n with | so we can split it in lua
            else:
                value = "'%s', base=true" % item['value'].replace('\n', "|")
                writeTo.append(classes_file)
            # if we have a doc link we write it to the file as well
            if item.get('doc') is not None:
                value += ", doc='%s'" % item['doc']
                writeTo.append(category_file)
            # if we have a description we write it to the file as well
            if item.get('desc') is not None:
                value += ", desc='%s'" % item['desc'].replace('\'', '\\\'')
            write = "\t{'%s', %s},\n" % (item['name'], value)
            for w in writeTo:
                w.write(write)
        f.write('}')


writeTo = [all_file, category_file, classes_file]

for w in writeTo:
    w.write('return {\n')

recursive_write('base', items)

for w in writeTo:
    w.write('}')

print("done")
