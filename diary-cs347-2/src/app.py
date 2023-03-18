from flask import Flask, request
import json
import time
import text2emotion as te

app = Flask(__name__)

@app.route('/classify', methods=['POST'])
def sentiment():
    headers = {'Access-Control-Allow-Origin': '*'}
    print('REST API Request Received at', time.time())
    req = json.loads(request.get_data())
    lines = req["text"]
    passage = " ".join(lines)
    result = { "emotions": te.get_emotion(passage)}
    return result, 200, headers

if __name__ == '__main__':
    app.run()