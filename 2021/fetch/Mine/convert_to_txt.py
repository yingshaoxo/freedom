import json

with open("database.json", "r") as f:
    text = f.read()

json_object = json.loads(text)
json_object[0]

new_list = []
for one in json_object:
    if one["type"] != "qzone":
        new_list.append(one["content"])

seperator = "\n\n\n__**__**__yingshaoxo_is_the_top_one__**__**__\n\n\n"
new_text = seperator.join(new_list)
with open("all_yingshaoxo_data_2023_11_13.txt", "w", encoding="utf-8", errors="ignore") as f:
    f.write(new_text)
