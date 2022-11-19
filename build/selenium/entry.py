import os
from selenium import webdriver
from selenium.webdriver.common.by import By

link = "https://nerdcave.com/tailwind-cheat-sheet"
driver = webdriver.Chrome()
driver.get(link)

# todo check if page is loadeds without waiting
# driver.implicitly_wait(0.5)

doc_path = os.path.join(".", "")


def replace_char(str):
    chars = [" ", "-", ":"]
    temp = ""
    for s in str:
        c = s
        if s in chars:
            c = "_"
        temp += c
    return str


# def write_to_file(items):
#     print(items)
#     path = os.path.join(doc_path, replace_char(items['name'])+".lua")
#     print('Writing to file: ' + path)
#     with open(path, "w") as f:
#         f.write('{\n')
#     if (items['items']):
#         write_to_file(items['items'])
#     f.write("}")


def write_to_file(name, items):
    if not isinstance(items, list):
        return
    for item in items:
        write_to_file(item.name, item.items)
        path = os.path.join(doc_path, replace_char(name)+".lua")
        with open(path, "w") as f:
            f.write('return {\n')
            for i in items:
                f.write(('\t{%s, %s\n}', i['name'], replace_char(i['name'])))
            f.write("}")


btns = driver.find_elements(By.CSS_SELECTOR, "button")

for b in btns:
    if b.text == "EXPAND ALL":
        expander = b
        expander.click()
        break

containers = driver.find_elements(By.CSS_SELECTOR, 'div:has( > header)')

items = []

outerCount = 0
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

    if outerCount == 2:
        break
    outerCount += 1

    lis = c.find_elements(By.CSS_SELECTOR, 'li')
    innerCount = 0
    for li in lis:
        type = li.find_element(By.CSS_SELECTOR, 'span').text
        items[-1]['items'].append({'name': type, 'items': []})

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
            break
        break
    break

# write files


if not os.path.exists(doc_path):
    os.makedirs(doc_path)
write_to_file(items)

# for c in containers:
#     category = c.find_element(By.TAG_NAME, 'h2')
#     print(category.text)
#
# print("---")
#
# containers2 = driver.find_elements(locate_with(By.TAG_NAME, 'div')
#                                    .above({By.TAG_NAME, 'h2'}))
#
# for c in containers2:
#     category = c.find_element(By.TAG_NAME, 'h2')
#     print(category.text)

#
# categories = []
#
# for h in headers:
#     categories.append(h.text)
#
#
#
#
#
#
# # expandbtn = driver.find_element(by=By.CSS_SELECTOR, value=".btn.btn-blue.w-5/6")
#
