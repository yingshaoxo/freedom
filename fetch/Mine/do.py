#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
import json
import sqlite3


# In[2]:


db_file = os.path.abspath("../../server/yourdata.db")


# ## export data to json

# In[3]:


class Self():
    pass

self = Self()
self.SQL_DATA_FILE = db_file
if not os.path.exists(self.SQL_DATA_FILE):
    print(f"SQL doesn't exist: {self.SQL_DATA_FILE}")
    print(f"We'll create a new one!")
self._sql_conn = sqlite3.connect(self.SQL_DATA_FILE, check_same_thread=False)
self._sql_cursor = self._sql_conn.cursor()

days = []
for row in self._sql_cursor.execute('SELECT * FROM thoughts ORDER BY date'):
    if row[1] == "mine":
        if " " in row[0]:
            if "." in row[0]:
                date = row[0].split(".")[0]
            else:
                date = row[0]
            row = (date, row[1], row[2], row[3])
            days.append(list(row))

text = json.dumps(days, indent=4)
with open("mine.json", "w") as f:
    f.write(text)


# ## import data to database

# In[4]:


with open("mine.json", "r") as f:
    text = f.read()
days = json.loads(text)


# In[5]:


if os.path.exists("mine.db"):
    os.remove("mine.db")


# In[6]:


class Self():
    pass

self = Self()
self.SQL_DATA_FILE = "./mine.db"
if not os.path.exists(self.SQL_DATA_FILE):
    print(f"SQL doesn't exist: {self.SQL_DATA_FILE}")
    print(f"We'll create a new one!")
self._sql_conn = sqlite3.connect(self.SQL_DATA_FILE, check_same_thread=False)
self._sql_cursor = self._sql_conn.cursor()
self._sql_cursor.execute('''CREATE TABLE IF NOT EXISTS thoughts
        (date TEXT, type TEXT, text TEXT, images TEXT)''')

for day in days:
    self._sql_cursor.execute("INSERT INTO thoughts VALUES (?,?,?,?)", day)
    self._sql_conn.commit()


# In[ ]:



