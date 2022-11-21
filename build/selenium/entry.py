import os
from selenium import webdriver
from selenium.webdriver.common.by import By

link = "https://nerdcave.com/tailwind-cheat-sheet"
driver = webdriver.Chrome()
driver.get(link)


doc_path = os.path.join("../../lua/tailiscope", "docs/")


def replace_char(str):
    chars = [" ", "-", ":", ",", "/"]
    temp = ""
    for s in str:
        c = s
        if s in chars:
            c = "_"
        temp += c
    return temp.lower().replace("\n", " ")


def recursive_write(name, items):

    path = os.path.join(doc_path, replace_char(name)+".lua")
    with open(path, "w") as f:
        f.write('return {\n')
        for item in items:
            value = ""
            if item.get('items') is not None:
                # if the item has sub items write them with the same name as the current item
                recursive_write(item['name'], item['items'])
                # value = "'%s', fn=recursive_picker" % replace_char(item['name'])
                value = "'%s'" % replace_char(item['name'])
            else:
                # value = "'%s', base=true, fn=paste" % replace_char(item['value'])
                value = "'%s', base=true" % replace_char(item['value'])
            if item.get('doc') is not None:
                value += ", doc='%s'" % item['doc']
            write = "\t{'%s', %s},\n" % (item['name'], value)
            f.write(write)
        f.write('}')


btns = driver.find_elements(By.CSS_SELECTOR, "button")

for b in btns:
    if b.text == "EXPAND ALL":
        expander = b
        expander.click()
        break

containers = driver.find_elements(By.CSS_SELECTOR, 'div:has( > header)')

items = []
# for c in containers:
#     category = c.find_element(By.CSS_SELECTOR, 'header > h2').text
#     items.append({'category': category, 'items': []})
#
#     if outerCount == 2:
#         break
#     outerCount += 1
#
#     lis = c.find_elements(By.CSS_SELECTOR, 'li')
#     innerCount = 0
#     for li in lis:
#         if innerCount == 2:
#             break
#         innerCount += 1
#         type = li.find_element(By.CSS_SELECTOR, 'span').text
#         desc = li.find_element(By.CSS_SELECTOR, 'p').text
#         link = li.find_element(By.CSS_SELECTOR, 'a').get_attribute('href')
#         items[-1]['items'].append({'type': type, 'desc': desc, 'link': link, 'items': []})
#         table = li.find_element(By.CSS_SELECTOR, 'table')
#         trs = table.find_elements(By.CSS_SELECTOR, 'tr')
#         print('table: ', type)
#         for t in trs:
#             tds = t.find_elements(By.CSS_SELECTOR, 'td')
#             value = tds[1].text
#             if tds[2] and tds[2].text != '':
#                 value += '\t' + tds[2].text
#             items[-1]['items'][-1]['items'].append({
#                 'name': tds[0].text,
#                 'value': value,
#             })

for c in containers:
    category = c.find_element(By.CSS_SELECTOR, 'header > h2').text
    items.append({'name': category, 'items': []})

    lis = c.find_elements(By.CSS_SELECTOR, 'li')
    for li in lis:
        type = li.find_element(By.CSS_SELECTOR, 'span').text
        link = li.find_element(By.CSS_SELECTOR, 'a').get_attribute('href')
        items[-1]['items'].append({'name': type, 'items': [], 'doc': link})
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
# write files

if not os.path.exists(doc_path):
    os.makedirs(doc_path)

recursive_write('base', items)

print("done")
