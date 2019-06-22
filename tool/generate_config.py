#!/usr/local/bin/python3.7
# -*- coding: utf-8 -*-
# -*- mode: python;Encoding: utf8n -*-

import glob
import os
import json
import sys
import datetime

if os.getenv('IS_DOCKER', default=0):
    BASE_DIR  = "/Lodge"
else:
    BASE_DIR  = "./text"

ANS_DIR         = BASE_DIR + "/ans/"
CONF_DIR        = BASE_DIR + "/conf/"
PROB_DIR        = BASE_DIR + "/prob/"
DIRECTORY_INFO  = [BASE_DIR, ANS_DIR, CONF_DIR, PROB_DIR]
DEFAULT_TIMEOUT = 20

dirlist     = []
dict_arr    = {}

class Timeout(Exception):
    pass

class ComplexEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime):
            return o.isoformat()
        return super(ComplexEncoder, self).default(o)

def test___is_exit():
    i = __is_exit()
    assert i == 0

def do_kill_process(line):
    num = 0
    for pid in line.split():
        num = num + 1
        print('Killing %d' % int(pid))
        try:
            os.kill(int(pid), signal.SIGKILL)
        except OSError as e:
            if e.errno != errno.ESRCH:
                raise e
    return num

# 間違いなくいらないファイルを消していく
def do_kill_process(devfile):
    for i in dirlist:
        do_kill_process(line)
        sleep(1)

# pytestで使う用
def print_infomation(dic):
    print ("Result Successfully.\n")
    print ("PID      : " + dic['pid'])
    print ("FILENAME : " + dic['filename'])
    print ("FILENUM  : " + dic['filenum'])

def get_problem_list(path):
    for x in os.listdir(path):
        if os.path.isdir(path + x):
            dirlist.append(x)

def get_file_list():
    ind = []
    L = []
    for i in range(len(dirlist)):
        p = '{}{}'.format(DIRECTORY_INFO[1], dirlist[i])
        L.append(p)
        for j in os.listdir(L[i]):
            ind.append(j)

    return ind

def parse_to_json(d):
    results = {}
    for num in d:
        key = num[0:3]
        if key not in results:
            results[key] = []
        results[key].append(num)

    # ファイルが存在するかを確認
    if __is_exit(results):
        print ("Wrong file configurationi.")
        sys.exit()

    # Conversion : dict => str
    json_str = json.dumps(results, cls=ComplexEncoder)

    # output to jsonfile
    filename = '{}{}.json'.format(DIRECTORY_INFO[2], datetime.datetime.now().strftime("%m-%d-%H:%M:%S"))
    json_file = open(filename, 'w')
    json.dump(results, json_file)

    generate_info = {
        'pid'      : str(os.getpid()),
        'filename' : os.path.basename(filename) ,
        'filenum'  : str(len(d))
    }

    print_infomation(generate_info)

def __is_exit(r):
    L =[]
    for key in r:
        for val in r[key]:
            if os.path.exists('{}{}/{}'.format(PROB_DIR, key, val)):
                continue
            else:
                return val
    return 0

def do_run():
    get_problem_list(DIRECTORY_INFO[1])
    file_list_dict = get_file_list()
    parse_to_json(file_list_dict)

def main():
    if (len(sys.argv) != 1):
        print('Usage: %s' % sys.argv[0])
        sys.exit(1)
    else:
        do_run()

if __name__ == "__main__":
    main()
