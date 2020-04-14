from auto_everything.base import IO, Terminal
import json
io = IO()
t_ = Terminal()

DIARY_DATA_STRUCTURE = [
    {
        "date": "",
        "content": [
            [{"image": ""}, {"text": ""}],
            [{"image": ""}, {"text": ""}],
        ]
    }
]

DATA_FILE_PATH = "data.json"
if not t_.exists(DATA_FILE_PATH):
    io.write(DATA_FILE_PATH, json.dumps(DIARY_DATA_STRUCTURE))
else:
    text = io.read(DATA_FILE_PATH)
    print(text)
