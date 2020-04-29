import os
import sqlite3


class Self():
    _root_path = "."
    pass


self = Self()
self.SQL_DATA_FILE = os.path.join(self._root_path, "qzone.db")
self._sql_conn = sqlite3.connect(self.SQL_DATA_FILE, check_same_thread=False)

self._sql_cursor = self._sql_conn.cursor()
self._sql_cursor.execute('''CREATE TABLE IF NOT EXISTS thoughts
            (date TEXT, type TEXT, text TEXT, images TEXT)''')


SQL_DATA_FILE = os.path.join(".", "yourdata.db")
_sql_conn = sqlite3.connect(SQL_DATA_FILE, check_same_thread=False)

_sql_cursor = _sql_conn.cursor()
_sql_cursor.execute('''CREATE TABLE IF NOT EXISTS thoughts
            (date TEXT, type TEXT, text TEXT, images TEXT)''')

_sql_cursor.execute('''
DELETE FROM thoughts 
WHERE type LIKE '%qzone%';
''')
_sql_conn.commit()

for row in self._sql_cursor.execute('SELECT * FROM thoughts ORDER BY date'):
    _sql_cursor.execute("INSERT INTO thoughts VALUES (?,?,?,?)",
                        row
                        )
    _sql_conn.commit()
