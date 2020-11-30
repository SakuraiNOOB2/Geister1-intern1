from test.to_json import to_json
from test.user_test import signup, login

def create_test_user_and_access_token(app, name):
    signup(app, name, 'password')
    r = login(app, name, 'password')
    json_data = to_json(r.data)
    access_token = json_data.get("access_token")
    return access_token
