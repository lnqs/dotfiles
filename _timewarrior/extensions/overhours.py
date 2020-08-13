#!/usr/bin/env python3

from collections import defaultdict
from datetime import datetime, timedelta
from dateutil import tz
import json
import sys

WEEKDAYS = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']

DATEFORMAT = '%Y%m%dT%H%M%SZ'
DEFAULT_WORKING_DAYS = 'mon,tue,wed,thu,fri'
DEFAULT_HOURS_PER_WEEK = 40.0


def format_delta(delta):
    days = delta.days
    hours, reminder = divmod(delta.seconds, 3600)
    minutes, seconds = divmod(reminder, 60)
    return '{:2d}:{:02d}'.format(hours + days * 24, minutes)


def parse_data(input_stream):
    header = True
    configuration = dict()
    data = ''
    for line in input_stream:
        if header:
            if line == '\n':
                header = False
            else:
                fields = line.strip().split(': ', 2)
                if len(fields) == 2:
                    configuration[fields[0]] = fields[1]
                else:
                    configuration[fields[0]] = ''
        else:
            data += line

    return configuration, json.loads(data)


def calculate_overhours(config, data):
    working_days = [WEEKDAYS.index(d) for d in config.get('overhours.working_days', DEFAULT_WORKING_DAYS).split(',')]
    hours_per_week = float(config.get('overhours.hours_per_week', DEFAULT_HOURS_PER_WEEK))
    hours_per_day = hours_per_week / len(working_days)

    print('Working {} days a week for {} hours'.format(len(working_days), hours_per_week))

    # Get tracked durations per day
    days = defaultdict(timedelta)

    for span in data:
        start = datetime.strptime(span['start'], DATEFORMAT)

        if start.date() != datetime.now().date():
            end = datetime.strptime(span['end'], DATEFORMAT) if 'end' in span else datetime.utcnow()
            tracked = end - start
            days[start.date()] += tracked

    # Fill gaps
    cursor = sorted(days.keys())[0]
    while cursor < datetime.now().date():
        if cursor not in days:
            days[cursor] = timedelta(hours=hours_per_day)
        cursor += timedelta(days=1)

    # Print it!
    current_month = None

    for day in sorted(days.keys()):
        if day.month != current_month:
            print('\n# {:%B %Y}'.format(day))
            current_month = day.month

        if day.weekday() in working_days:
            print('{:%Y-%m-%d}: Worked for {} hours'.format(day, format_delta(days[day])))
        else:
            print('{:%Y-%m-%d}: Not a working day'.format(day))

    overtime = sum(days.values(), timedelta()) - timedelta(hours=len(days) * hours_per_day)
    print('\nTotal overtime: {} hours'.format(format_delta(overtime)))

if __name__ == '__main__':
    config, data = parse_data(sys.stdin)
    calculate_overhours(config, data)
