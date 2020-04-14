import everyday_pb2
from sanic import Sanic, response
from sanic_cors import CORS
import datetime
import pprint
import base64

from PIL import Image
import cv2
import io


def show_image(base64_bytes):
    #print(base64_bytes)
    datauri = base64.b64decode(base64_bytes)
    #print(datauri)
    header, encoded = datauri.split(",", 1)
    print(header)
    #print(type(encoded))
    image = Image.open(io.BytesIO(encoded))
    image.show()
    # return cv2.cvtColor(np.array(image), cv2.COLOR_BGR2RGB)


everyday = everyday_pb2.EveryDay()


app = Sanic(name="freedom")
CORS(app)


def printit(text):
    print("\n", '-'*10, "\n")
    print(text)


@app.route('/api/v1/upload', methods=['POST'])
async def user_management(request):
    result = {"status": "wrong"}
    if request.json:
        action = request.json.get("action")
        data = request.json.get("data")
        if action and data:
            if action == "oneday":
                # printit(data)
                data = base64.decodebytes(data.encode("utf-8"))
                print(data[:30])
                data = base64.decodebytes(data)
                print(data.decode("utf-8")[:30])
                """
                oneday = everyday_pb2.OneDay()
                oneday.MergeFromString(data)
                base64_image = oneday.content[0].image[0]
                show_image(base64_image)
                # printit(oneday)
                everyday.oneday.extend([oneday])
                # printit(everyday)
                """
                result["status"] = "ok"
    return response.json(result)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888, debug=True)
