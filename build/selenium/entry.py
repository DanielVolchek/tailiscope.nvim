from selenium import webdriver
from selenium.webdriver.common.by import By

link = "https://nerdcave.com/tailwind-cheat-sheet"
driver = webdriver.Chrome()
driver.get(link)

# todo check if page is loadeds without waiting
# driver.implicitly_wait(0.5)


btns = driver.find_elements(By.CSS_SELECTOR, "button")

for b in btns:
    if b.text == "EXPAND ALL":
        expander = b
        expander.click()
        break

containers = driver.find_elements(By.CSS_SELECTOR, 'div:has( > header)')

items = []

for c in containers:
    category = c.find_element(By.CSS_SELECTOR, 'header > h2').text
    items.append({'category': category, 'items': []})

    lis = c.find_elements(By.CSS_SELECTOR, 'li')
    for li in lis:
        type = li.find_element(By.CSS_SELECTOR, 'span').text
        desc = li.find_element(By.CSS_SELECTOR, 'p').text
        link = li.find_element(By.CSS_SELECTOR, 'a').get_attribute('href')
        items[-1]['items'].append({'type': type, 'desc': desc, 'link': link, 'items': []})
        table = li.find_element(By.CSS_SELECTOR, 'table')
        trs = table.find_elements(By.CSS_SELECTOR, 'tr')
        print('table: ', type)
        for t in trs:
            tds = t.find_elements(By.CSS_SELECTOR, 'td')
            items[-1]['items'][-1]['items'].append({
                'name': tds[0].text,
                'value': tds[1].text,
                'supp': tds[2].text,
            })
    break


# {category, items: [type, desc, items: []]}


for t in items:
    print('category: ')
    print(t['category'])

    cat = t['category']
    with open(cat + '.lua', 'w') as f:
        f.write
    print('items: ')
    for i in t['items']:
        print(i['type'], ":", i['desc'])
        print(i['link'])
        for j in i['items']:
            print(j['name'], " ", j['value'], " ", j['supp'])
    break
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
