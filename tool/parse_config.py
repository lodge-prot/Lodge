#!/usr/local/bin/python3.7
# -*- coding: utf-8 -*-
# -*- mode: python;Encoding: utf8n -*-

import argparse
import json

parser = argparse.ArgumentParser(
        prog='parse_config.py',
        usage='Specify config file of json.',
        description='Parse of specifyd json config file.',
        add_help=True
        )

parser.add_argument('-c', '--config',
        action='store',
        nargs=1,
        required=True,
        help='Specify config file of json.')

parser.add_argument('-m', '--mode',
        action='store',
        choices=['name-list', 'parse'],
        required=True,
        help='Output test name list.')

parser.add_argument('-p', '--parse',
        action='store',
        nargs=1,
        help='Test num')

args = parser.parse_args()

with open(args.config[0]) as f:
    test_dict = json.load(f)


def name_list():
    for key in test_dict:
        print(key)

def parse_config():
    test_num = args.parse[0]

    if test_dict.get(test_num) == None:
        print('error')
    else:
        for val in test_dict.get(test_num):
            print(val)

def main():
    if args.mode == 'name-list':
        name_list()
    elif args.mode == 'parse':
        parse_config()

if __name__ == "__main__":
    main()
