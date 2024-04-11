a_file = open("database.json", "r")
json_text = a_file.read()
a_file.close()


"""
{'type': 'kivydiary', 'date': '2018-02-25 00:00:00', 'content': '', 'images': []}
"""

import json
diary_list = json.loads(json_text)
for one in diary_list:
    images = one["images"]
    if len(images) > 0:
        print(one)
        break

