import os

from data import Data
my_data = Data(".")

rows = my_data._new_data._iterate_database()
print(len(rows))
