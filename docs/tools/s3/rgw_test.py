#!/usr/bin/env python
import boto.s3.connection

access_key = 'E94D7427VZVE16ZV0F1O'
secret_key = 'rGJazagHx42BnhWhkAM6RO9UYZjaHwq4D1WvYVPD'

conn = boto.connect_s3(
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
        host='s3-amp.ackd.me', port=443,
        is_secure=True, calling_format=boto.s3.connection.OrdinaryCallingFormat(),
       )

insecure_conn = boto.connect_s3(
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
        host='192.168.44.204', port=7480,
        is_secure=False, calling_format=boto.s3.connection.OrdinaryCallingFormat(),
       )

print('using secure connection')
print('\ncreate test-bucket')
create_bucket = conn.create_bucket('test-bucket')
print('\nlist buckets')
for bucket in conn.get_all_buckets():
    print(bucket.name+" "+bucket.creation_date)
print('\ndelete test-bucket')
delete_bucket = conn.delete_bucket('test-bucket')
print('\nlist buckets')
for bucket in conn.get_all_buckets():
    print(bucket.name+" "+bucket.creation_date)

print('\nusing insecure connection')
print('\ncreate insecure-test-bucket')
create_insecure_bucket = insecure_conn.create_bucket('insecure-test-bucket')
print('\nlist buckets')
for bucket in insecure_conn.get_all_buckets():
    print(bucket.name+" "+bucket.creation_date)
print('\ndelete insecure-test-bucket')
delete_insecure_bucket = insecure_conn.delete_bucket('insecure-test-bucket')
print('\nlist buckets')
for bucket in insecure_conn.get_all_buckets():
    print(bucket.name+" "+bucket.creation_date)
