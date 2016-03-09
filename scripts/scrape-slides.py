#!/usr/bin/env python
import os
import sys
import re

"""
re.findall(r"\.exercise\[([^\]]*)\]", slide, re.DOTALL)

This script extracts blocks surrounded by ```.
"""
if __name__ == '__main__':
    with open(sys.argv[1]) as f:
        #data = f.read().split("---")
        data = filter(None, re.split("^[\-]{2,}$", f.read(), flags=re.MULTILINE))
    slide_number = 0
    for raw_slide in data:
        slide_number += 1
        slide = raw_slide.split('\n')
        title, body = slide[2], slide[2:]
        exercises = []
        for line in slide:
            line = line.strip(' ')
            if line.startswith("<br/>"):
                if '`' in line:
                    commands = [x for x in line.split("`")]# if x not in ['<br/>', '']]
                    exercises.extend(commands[1::2])
            if ".exercise[" in line:
                i = raw_slide.index(".exercise[") + 10
                exercises.extend(raw_slide[i:].split("```")[1::2])
        if not exercises:
            continue
        print("# ~~~~~~ [{}] {} ~~~~~~ #".format(slide_number, title))
        for exercise in exercises:
            e = "\n".join([line[2:] if line.startswith('  ') else line for line in exercise.split('\n')])
            e = e.strip('\n')
            print(e)
        print
