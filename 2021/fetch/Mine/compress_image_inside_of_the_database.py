a_file = open("database.json", "r")
json_text = a_file.read()
a_file.close()


"""
{'type': 'kivydiary', 'date': '2018-02-25 00:00:00', 'content': '', 'images': []}
type: kivydiary, twitter, qzone, freedom
"""

import json
diary_list = json.loads(json_text)


# step 1, delete all twitter image
new_diary_list = []
counting = 0
for index, one in enumerate(diary_list):
    type = one["type"]
    if type == "twitter":
        one["images"] = []
        new_diary_list.append(one)
        counting += 1
    else:
        new_diary_list.append(one)
print(counting)
with open("new_database.json", "w", encoding="utf-8") as f:
    f.write(json.dumps(new_diary_list, indent=4, ensure_ascii=False))
print("done: remove twitter image from diary")
exit()

#base64_image_list = []
#counting = 0
#for index, one in enumerate(diary_list):
#    images = one["images"]
#    if len(images) > 0:
#        base64_image_list.append([index, images])
#        #print(one["content"][:10], images[0][-100:])
#        #if index == 1578:
#        #    print(one["content"])
#        #    #with open("test.base64", "w") as f:
#        #    #    f.write(images[0])
#        if one["type"] == "twitter":
#            print(one["content"][:20])
#        counting += 1
#print(counting)
#exit()

#
#
#import base64
#
## Encode an image to Base64
#def encode_image_to_base64(image_path):
#   with open(image_path, "rb") as image_file:
#       encoded_string = base64.b64encode(image_file.read()).decode('utf-8')
#   return encoded_string
#
## Decode Base64 back to an image
#def decode_base64_to_image(base64_string, output_path):
#   with open(output_path, "wb") as image_file:
#       image_file.write(base64.b64decode(base64_string))
#
#
import socket

def tcp_request(ip, port, data):
    host = ip
    port = port  # socket server port number

    client_socket = socket.socket()  # instantiate
    client_socket.connect((host, port))  # connect to the server

    client_socket.send(data)  # send message
    bytes_data = b''
    while True:
        temp_data = client_socket.recv(51200)
        if not temp_data:
            break
        bytes_data += temp_data
    #bytes_data = client_socket.recv(1000000) # won't work for big files, socket cache limited
    #print('Received from server: ' + str(len(bytes_data)))  # show in terminal

    client_socket.close()  # close the connection
    return bytes_data
#
#
#from auto_everything import Disk
#disk = Disk()
#for index, base64_image_string_list in base64_image_list:
#    disk.create_a_folder("./test_image/" + str(index))
#    for index2, base64_image_string in enumerate(base64_image_string_list):
#        decode_base64_to_image(base64_image_string, "./test_image/" + str(index) + "/" + str(index2) + ".jpg")
#        #raw_bytes = base64.b64decode(base64_image_string)
#        #new_bmp_bytes = tcp_request("192.168.56.119", 4141, "jpg_convert_to_bmp:".encode("ascii") + raw_bytes)
#        #output_file_name = "./test_image/" + str(index) + "/" + str(index2) + ".bmp"
#        #print(output_file_name)
#        #with open(output_file_name, "wb") as image_file:
#        #    image_file.write(new_bmp_bytes)


#from auto_everything import Disk
#disk = Disk()
#from auto_everything.image_ import Image
#image = Image()
#
#files = disk.get_files("./test_image_bmp/")
#for file in files:
#    if file.endswith(".bmp"):
#        an_image = image.read_image_from_file(file)
#        image_2 = an_image.get_simplified_image_by_merge_sub_image()
#        image_2.save_image_to_file_path(file[:-4] + ".png")
#        disk.delete_a_file(file)

#response = tcp_request("192.168.56.119", 4141, "hi:".encode("ascii") + b"nice")
#print(response)

from time import sleep
from auto_everything import Disk
disk = Disk()
from auto_everything.image_ import Image
image = Image()

files = disk.get_files("./test_image/")
files = [file for file in files if file.endswith(".bmp")]
index = 140
while index < len(files):
    file = files[index]
    print("\n\n")
    print(index)
    print(file)
    try:
        an_image = image.read_image_from_file(file)

        with open(file, "rb") as image_file:
            image_bytes = image_file.read()
        response = tcp_request("192.168.56.119", 4141, "show_picture:".encode("ascii") + image_bytes)

        char = input("Is this picture important to you? (1==important, 2==second_important, 3==not_important, 4==ignore, 5==previous_one)\n").strip()
        if char == "1":
            an_image = an_image.simplify_image_by_yingshaoxo_method(quick_mode=False)
        elif char == "2":
            an_image = an_image.directly_scale_down_image_to_reduce_size()
            an_image = an_image.simplify_image_by_yingshaoxo_method(quick_mode=False)
        elif char == "3":
            an_image = an_image.directly_scale_down_image_to_reduce_size()
            an_image = an_image.directly_scale_down_image_to_reduce_size()
            an_image = an_image.simplify_image_by_yingshaoxo_method(quick_mode=False)
        elif char == "5":
            index -= 2
            continue
        else:
            index += 1
            continue
        file = file[:-4] + ".png"
        an_image.save_image_to_file_path(file)

        with open(file, "rb") as image_file:
            image_bytes = image_file.read()
        response = tcp_request("192.168.56.119", 4141, "show_picture:".encode("ascii") + image_bytes)
    except Exception as e:
        print(e)
        print(file)

    print()
    input("continue?")
    index += 1
