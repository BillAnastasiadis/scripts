import os
import requests
import json

server = os.environ['matrix_server']
data = '{"msgtype": "m.text", "body": "' + str(os.environ[
    "message"]) + '", "format": "org.matrix.custom.html", "formatted_body": "' + \
       str(os.environ["message"]) + '"}'
data = json.loads(data)
params = (
    ('access_token', os.environ["access_token"]),
)
room_id = os.environ['matrix_room']
address = "https://" + server + "/_matrix/client/r0/rooms/" + room_id + "/send/m.room.message"
response = requests.post(address, params=params, data=json.dumps(data))
print(response.content)
