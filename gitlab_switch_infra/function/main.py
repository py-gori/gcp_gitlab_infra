#! /usr/bin/python

import base64
import datetime
import json
import logging
import os
import sys
from jsonschema import validate, ValidationError
from googleapiclient.discovery import build

JSON_SCHEMA = json.load(
    open('./schema.json'))

PROJECT = os.environ.get('GCP_PROJECT')
compute = build('compute', 'v1')

def gce_instance_switch(data, context):
    if 'data' not in data:
        sys.exit(1)

    payload = json.loads(base64.b64decode(data['data']).decode('utf-8'))

    try:
        validate(payload, JSON_SCHEMA)
    except ValidationError as e:
        m = 'Invalid JSON - {0}'.format(e.message)
        logging.error(m)
        sys.exit(1)

    switch = payload['switch']
    zone   = payload['zone']
    target = payload['target']

    if switch == 'off':
        logging.info('instance stop process execute')
        compute.instances().stop(project=PROJECT, zone=zone, instance=target).execute()
        logging.info('instance stop process complete')
    elif switch == 'on':
        logging.info('instance start process execute')
        compute.instances().start(project=PROJECT, zone=zone, instance=target).execute()
        logging.info('instance start process complete')
