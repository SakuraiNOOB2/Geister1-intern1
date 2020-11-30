#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import unittest
from run import app
from test.to_json import to_json

def signup(app, name, password):
    return app.post(
        'api/users'
        , json={u'name':name, u'password':password}
    )

def login(app, name, password):
    return app.post(
        '/api/user_sessions'
        , json={u'name':name, u'password':password}
    )

def logout(app, access_token, session_id):
    return app.delete(
        '/api/user_sessions/' + str(session_id)
        , headers={'Authorization': 'token="{0}"'.format(access_token)}
    )

class UserTest(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.access_token = ""

    def get_test_session(self):
        r = login(self.app, 'test1', 'password')
        json_data = to_json(r.data)
        session_id = json_data.get("user_session_id")
        access_token = json_data.get("access_token")
        return session_id, access_token

    def test_01_not_signup_login(self):
        # ユーザー新規作成前はログインできないこと
        r = login(self.app, 'test1', 'password')
        self.assertEqual(r.status_code, 400)

    def test_02_signup(self):
        # ユーザー新規作成
        r = signup(self.app, 'test1', 'password')
        self.assertEqual(r.status_code, 200)
        json_data = to_json(r.data)
        self.assertIsNotNone(json_data.get("user_id")) # user_idの生成方法は任意とする(auto incrementでなくても良い)
        self.assertEqual(json_data["name"], "test1")
        # note:created_at等のパラメータは任意とする

        # TODO:ユーザー名、パスワードの文字数はそれぞれ仕様があるので、文字数チェックの対応を入れたらテストを追加して下さい

    def test_03_signup_exited_user(self):
        # 登録済みの名前なら、ユーザー新規作成に失敗すること
        r = signup(self.app, 'test1', 'password')
        self.assertEqual(r.status_code, 400)

    def test_10_login(self):
        # 作成されたユーザーでログインできること
        r = login(self.app, 'test1', 'password')
        self.assertEqual(r.status_code, 200)
        json_data = to_json(r.data)
        self.assertIsNotNone(json_data["user_id"])
        session_id = json_data.get("user_session_id")
        self.assertIsNotNone(session_id)
        access_token = json_data.get("access_token")
        self.assertIsNotNone(access_token)

    def test_11_login_incorrect_user_name(self):
        # ユーザー名が異なる場合にログインできないこと
        r = login(self.app, 'incorrect', 'password')
        self.assertEqual(r.status_code, 400)

    def test_12_login_incorrect_password(self):
        # パスワードが異なる場合にログインできないこと
        r = login(self.app, 'test1', 'incorrect')
        self.assertEqual(r.status_code, 400)

    def test_20_logout(self):
        # ログアウトできること
        session_id, access_token = self.get_test_session()
        r = logout(self.app, access_token, session_id)
        self.assertEqual(r.status_code, 200)

        # TODO:ログアウト後、セッションが無効になることが理想だが
        #      チュートリアルでは無効にならない簡易なセッションをサンプルとして提示するので
        #      セッションを無効にする対応を入れたらテストコードを追加してください

    def test_21_logout_without_access_token(self):
        # 認証無しのログアウトに失敗すること
        session_id, _ = self.get_test_session()
        dummy_access_token = ""
        r = logout(self.app, dummy_access_token, session_id)
        self.assertEqual(r.status_code, 401)
