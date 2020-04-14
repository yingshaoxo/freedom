from sanic import Sanic, response
from sanic_cors import CORS
import datetime
import pprint

import everyday_pb2
everyday = everyday_pb2.EveryDay()


app = Sanic(name="freedom")
CORS(app)


@app.route('/api/v1/upload', methods=['POST'])
async def user_management(request):
    result = {"status": "wrong"}
    if request.json:
        action = request.json.get("action")
        data = request.json.get("data").encode("utf-8")
        if action and data:
            print(data)
            everyday.MergeFromString(data)
            print(everyday)
            result["status"] = "ok"
            return response.text(everyday.SerializeToString().decode('utf-8'))
    return response.json(result)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8888, debug=True)
