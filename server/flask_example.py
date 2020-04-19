from flask import Flask, request
from flask_cors import CORS
import json
from datetime import datetime
import pprint

import base64
import everyday_pb2

from PIL import Image
import io

from data import Data
my_data = Data()


#DEBUG = False
DEBUG = True


def printit(text):
    if DEBUG == False:
        return
    print("\n", '-'*10, "\n")
    print(text)


def show_image(base64_string):
    if DEBUG == False:
        return
    base64_string = base64_string.split(",")[1]
    im = Image.open(io.BytesIO(base64.b64decode(base64_string)))
    #im.save('image.png', 'PNG')
    im.show()


everyday = everyday_pb2.EveryDay()


app = Flask(__name__)
CORS(app)


@app.route('/api/v1/upload', methods=['POST'])
def upload():
    result = {"status": "wrong"}
    request_json = request.get_json()
    if request_json:
        action = request_json.get("action")
        data = request_json.get("data")
        if action and data:
            printit(data[:30])  # raw data
            data = base64.b64decode(data)  # encoded by our self with our own javascript function
            printit(data[:30])
            data = base64.decodebytes(data)  # encoded by google protocol
            printit(data[:30])  # mergeable bytes data for protocol object
            oneday = everyday_pb2.OneDay()
            oneday.MergeFromString(data)
            printit(oneday.content[0].text)

            if len(oneday.content[0].image):
                base64_image_string = oneday.content[0].image[0]
                printit(base64_image_string[:30])
                show_image(base64_image_string)

            everyday.oneday.extend([oneday])
            printit(everyday)

            result["status"] = "ok"
    return json.dumps(result)


@app.route('/api/v1/get', methods=['GET'])
async def get_today_message():
    request_json = request.get_json()
    return json.dumps(my_data.get_todays_data())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888, debug=True)
