import os

from data import Data
my_data = Data(".")

# Get the list of all files in directory tree at given path
list_of_files = list()
for (dirpath, dirnames, filenames) in os.walk(os.path.abspath("../fetch/")):
    list_of_files += [os.path.join(dirpath, file) for file in filenames if file[-3:] == ".db"]

for file in list_of_files:
    my_data._new_data.merge_from_a_database(file)
