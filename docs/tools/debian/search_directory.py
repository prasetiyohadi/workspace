#!/usr/bin/env python
import os

keyword = "ansible_host"

curr_dir = os.getcwd()

print("current directory is : " + curr_dir)

dir_name = os.path.basename(curr_dir)

print("directory name is : " + dir_name)

script_path = os.path.realpath(__file__)

print("script path is : ", script_path)

files = [f for f in os.listdir('.') if os.path.isfile(f)]

for f in files:
    print(f)
