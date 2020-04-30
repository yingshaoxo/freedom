import json
import os
from datetime import datetime
import sqlite3
import base64
import re

import everyday_pb2


class Data():
    def __init__(self, root_path):
        self._new_data = NewData(root_path)

    def get_todays_data(self):
        self._todays_mine = self._new_data.get_historical_todays()
        print(self._todays_mine)
        return {
            "mine": self._todays_mine,
            "qzone": [],
            "twitter": [],
        }

    def _parse_oneday(self, oneday):
        date = oneday.date
        type = "mine"
        try:
            text = oneday.content[0].text
        except Exception as e:
            print(e)
            text = ""
        images = []
        for image in oneday.content[0].image:
            images.append(image)
        images = json.dumps(images)
        return (date, type, text, images)

    def save_a_day(self, newday):
        self._new_data.save_a_day(*self._parse_oneday(newday))


class NewData():
    def __init__(self, root_path):
        self._root_path = root_path
        self._initialize_SQL()

    def _initialize_SQL(self):
        self.SQL_DATA_FILE = os.path.join(self._root_path, "yourdata.db")
        if not os.path.exists(self.SQL_DATA_FILE):
            print(f"SQL doesn't exist: {self.SQL_DATA_FILE}")
            print(f"We'll create a new one!")
        self._sql_conn = sqlite3.connect(self.SQL_DATA_FILE, check_same_thread=False)

        def regular_expression(expr, item):
            reg = re.compile(expr, flags=re.DOTALL)
            return reg.search(item) is not None
        self._sql_conn.create_function("REGEXP", 2, regular_expression)  # 2 here means two parameters. REGEXP is a fixed value

        self._sql_cursor = self._sql_conn.cursor()
        self._sql_cursor.execute('''CREATE TABLE IF NOT EXISTS thoughts
                    (date TEXT, type TEXT, text TEXT, images TEXT)''')

    def _iterate_database(self):
        days = []
        for row in self._sql_cursor.execute('SELECT * FROM thoughts ORDER BY date'):
            days.append(row)
        return days

    def save_a_day(self, date, type, text, images):
        status = False
        if isinstance(date, str):
            if "." in date:
                date = date.split(".")[0]
            if isinstance(type, str):
                if isinstance(text, str):
                    if isinstance(images, str):
                        self._sql_cursor.execute("INSERT INTO thoughts VALUES (?,?,?,?)",
                                                 (date, type, text, images)
                                                 )
                        self._sql_conn.commit()
                        status = True
        return status

    def search(self, text):
        days = []
        for row in self._sql_cursor.execute('SELECT * FROM thoughts WHERE text REGEXP (?) ORDER BY date', [r'[\s\S.]*'+text+'[\s\S.]*']):
            days.append({
                "date": row[0],
                "type": row[1],
                "text": row[2],
                "images": json.loads(row[3]),
            })
        days.reverse()
        return days

    def get_database(self):
        return self.SQL_DATA_FILE

    def get_historical_todays(self):
        days = []
        for row in self._sql_cursor.execute('SELECT * FROM thoughts ORDER BY date'):
            date = row[0]
            type = row[1]
            text = row[2]
            images = json.loads(row[3])
            that_day_date = datetime.fromisoformat(date).date()
            if that_day_date == datetime.now().date():
                day = everyday_pb2.OneDay()
                day.date = date
                content = day.content.add()
                content.date = date
                content.text = text
                content.image.extend(images)
                days.append(day)
        if days:
            days.reverse()
            everyday = everyday_pb2.EveryDay()
            everyday.oneday.extend(days)
            bytes_data = everyday.SerializeToString()
            base64_string = base64.encodebytes(bytes_data)
            return base64_string.decode("ascii")

    def merge_from_a_database(self, path):
        if not os.path.exists(path):
            print(f"Target SQL doesn't exist: {path}")
            return False

        target_sql_conn = sqlite3.connect(path, check_same_thread=False)
        target_sql_cursor = target_sql_conn.cursor()
        for row in target_sql_cursor.execute('SELECT * FROM thoughts ORDER BY date'):
            date = row[0]
            type = row[1]
            result = self._sql_cursor.execute(''' SELECT * FROM thoughts WHERE date=:date and type=:type ''', {"date": date, "type": type}).fetchall()
            if len(result) == 0:
                self._sql_cursor.execute("INSERT INTO thoughts VALUES (?,?,?,?)",
                                         row
                                         )
                self._sql_conn.commit()


if __name__ == "__main__":
    # test1
    """
    my_data = Data(".")
    todays_data = my_data.get_todays_data()
    print(todays_data)
    """
    """
    # test2
    my_data = NewData(".")
    my_data.save_a_day("28.22", "qzone", "dddddhhhhhhhhi", "[]")
    my_data._iterate_database()
    path = my_data.get_database()
    print(path)
    """
    # test3
    my_data = NewData(".")
    r = my_data.search("垃圾")
    from pprint import pprint
    pprint(r)
