#!/usr/bin/env python
from __future__ import print_function
import argparse
import psycopg2
import sys
import time


if __name__ == '__main__':
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--db_host', required=True)
    arg_parser.add_argument('--db_port', required=True)
    arg_parser.add_argument('--db_user', required=True)
    arg_parser.add_argument('--db_password', required=True)
    arg_parser.add_argument('--timeout', type=int, default=5)
    arg_parser.add_argument('--database', required=True)
    #arg_parser.add_argument('--db_sslmode', required=False)

    args = arg_parser.parse_args()

    start_time = time.time()
    while (time.time() - start_time) < args.timeout:
        try:
            print("**************************************************************************")
            print("Database try")
            print("user: {} ".format(args.db_user))
            print("host: {}".format(args.db_host))
            print("port: {}".format(args.db_port))
            print("pwd: {}".format(args.db_password))
            print("database: {}".format(args.database))
            #print("sslmode: {}".format(args.db_sslmode))
            print("**************************************************************************")
            conn = psycopg2.connect(user=args.db_user, host=args.db_host, port=args.db_port, password=args.db_password, dbname=args.database)
            error = ''
            print("CONNECTION SUCCESS!!!!")
            break
        except psycopg2.OperationalError as e:
            error = e
        else:
            conn.close()
        time.sleep(1)

    if error:
        print("**************************************************************************")
        print("Database connection failure: %s" % error, file=sys.stderr)
        print("**************************************************************************")
        sys.exit(1)