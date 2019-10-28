#!/usr/bin/env python
#
#
# Copyright 2016 Jeff Bush
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

import re

#
# Pull some basic metrics out of the report files and print them
#

speed_re = re.compile('(?P<speed>[0-9\.]+) MHz')
with open('output_files/de2_115.sta.rpt') as f:
    foundSection = False
    for line in f:
        if foundSection:
            got = speed_re.search(line)
            if got:
                print('Fmax ' + got.group('speed') + 'MHz')
                break
        elif line.find('; Slow 1200mV 85C Model Fmax Summary') != -1:
            foundSection = True

count_re = re.compile('(?P<num>[0-9,]+)')
with open('output_files/de2_115.fit.rpt') as f:
    for line in f:
        if line.find('Total logic elements') != -1:
            got = count_re.search(line)
            if got:
                print(got.group('num') + ' Logic elements')
                break
