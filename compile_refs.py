#!/usr/bin/python

import subprocess, sys

name = "poster"
commands = [
    ['pdflatex', name + '.tex'],
    ['bibtex', name + '.aux'],
    ['pdflatex', name + '.tex'],
    ['pdflatex', name + '.tex']
]

for c in commands:
    subprocess.call(c)

