import os

from data import Data
my_data = Data(".")

rows = my_data._new_data._iterate_database()
for row in rows:
    print(row[0], row[1])

print()
print(len(rows))
