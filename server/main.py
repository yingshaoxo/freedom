import everyday_pb2
from sanic import Sanic, response
from sanic_cors import CORS
import datetime
import pprint
import base64

from PIL import Image
import cv2
import io


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
    im = Image.open(io.BytesIO(base64.b64decode(base64_string)))
    #im.save('image.png', 'PNG')
    im.show()


everyday = everyday_pb2.EveryDay()


app = Sanic(name="freedom")
CORS(app)


@app.route('/api/v1/upload', methods=['POST'])
async def user_management(request):
    result = {"status": "wrong"}
    if request.json:
        action = request.json.get("action")
        data = request.json.get("data")
        if action and data:
            if action == "oneday":
                printit(data[:30])  # raw data
                data = base64.b64decode(data)  # encoded by our self with our own javascript function
                printit(data[:30])
                data = base64.decodebytes(data)  # encoded by google protocol
                printit(data[:30])  # mergeable bytes data for protocol object
                oneday = everyday_pb2.OneDay()
                oneday.MergeFromString(data)
                printit(oneday.content[0].text)

                base64_image_string = oneday.content[0].image[0]
                printit(base64_image_string[:30])
                show_image(base64_image_string)

                everyday.oneday.extend([oneday])
                printit(everyday)

                result["status"] = "ok"
    return response.json(result)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888, debug=True)
