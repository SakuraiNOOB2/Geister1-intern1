#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import unittest

from run import app
from test.to_json import to_json
from test.create_test_user_access_token import create_test_user_and_access_token

def create_room(app, access_token):
    return app.post(
        'api/rooms'
        , headers={'Authorization': 'token="{0}"'.format(access_token)}
    )

def entry_room(app, access_token, room_id):
    return app.post(
        '/api/rooms/{0}/player_entries'.format(room_id)
        , headers={'Authorization': 'token="{0}"'.format(access_token)}
    )

def get_rooms(app, access_token):
    return app.get(
        '/api/rooms'
        , headers={'Authorization': 'token="{0}"'.format(access_token)}
    )

def exit_room(app, access_token, entry_id):
    return app.delete(
        '/api/player_entries/{0}'.format(entry_id)
        , headers={'Authorization': 'token="{0}"'.format(access_token)}
    )

class RoomTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        test_client = app.test_client()
        # 下準備としてユーザーを作成しておく
        cls.room_creator_access_token = create_test_user_and_access_token(test_client, "creator")
        cls.visitor_access_token = create_test_user_and_access_token(test_client, "visitor")
        cls.room_id = None
        cls.entry_player_id = None

    def setUp(self):
        self.app = app.test_client()

    def test_11_create_room(self):
        # ルーム新規作成
        r = create_room(self.app, RoomTest.room_creator_access_token)
        self.assertEqual(r.status_code, 200)
        json_data = to_json(r.data)
        RoomTest.room_id = json_data.get("room_id")
        self.assertIsNotNone(RoomTest.room_id)
        RoomTest.player_entry_id = json_data.get("player_entry_id")
        self.assertIsNotNone(RoomTest.player_entry_id)

    def test_12_create_room_existed_player_entry(self):
        # ルーム作成済みのプレイヤーが再度ルームを作ろうとしたら失敗すること
        r = create_room(self.app, RoomTest.room_creator_access_token)
        self.assertEqual(r.status_code, 400)

    def test_21_get_rooms(self):
        # ルームが取得できること
        r = get_rooms(self.app, RoomTest.visitor_access_token)
        self.assertEqual(r.status_code, 200)
        rooms = to_json(r.data)['rooms']
        found = False
        for room in rooms:
            if room['room_id'] == RoomTest.room_id:
                # 作成した部屋が含まれていて、waiting状態であること
                self.assertEqual(room['status'], "waiting")
                found = True
                break
        self.assertTrue(found)
        # TODO:既にゲームが終了したルームを作成できるなら、そのルームが一覧に含まれていないテストを書く

    def test_31_entry_room(self):
        # 作成済みのルームに入場できること
        r = entry_room(self.app, RoomTest.visitor_access_token, RoomTest.room_id)
        self.assertEqual(r.status_code, 200)
        json_data = to_json(r.data)
        self.assertEqual(json_data['room_id'], RoomTest.room_id)
        self.assertIsNotNone(json_data.get("player_entry_id"))

    def test_32_entry_full_room(self):
        # 満員のルームに入場できないこと
        full_visitor_access_token = create_test_user_and_access_token(self.app, "full")
        r = entry_room(self.app, full_visitor_access_token, RoomTest.room_id)
        self.assertEqual(r.status_code, 400)

    def test_41_exit_room(self):
        # ルームから退室できること
        r = exit_room(self.app, RoomTest.room_creator_access_token, RoomTest.player_entry_id)
        self.assertEqual(r.status_code, 200)

    def test_42_exit_room_no_entry_user(self):
        # 一度退室して、ルームに入っていないユーザーは退室できないこと
        r = exit_room(self.app, RoomTest.room_creator_access_token, RoomTest.player_entry_id)
        self.assertEqual(r.status_code, 400)
