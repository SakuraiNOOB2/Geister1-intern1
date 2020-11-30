#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import unittest
import json

from run import init_database
from test.user_test import UserTest
# from test.room_test import RoomTest # roomの実装を行う際にコメントアウトを解除してください

if __name__ == '__main__':
    init_database(is_test_mode=True)
    unittest.main()
