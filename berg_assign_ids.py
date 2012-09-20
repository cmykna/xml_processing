#!/usr/bin/env python
"""Berg serial numbering script."""

import sys, os, re
from implib.io import read_file, write_file, handle_args

## Initializations

bibcount = 0
divcount = 0
pcount = 0
TEIcount = 0
output_dir = 'serially_number'


## Replace functions.

def number_bibs(m):
	global bibcount
	bibcount = bibcount + 3
	return '''<bibl xml:id="bibl%s">''' % bibcount  ## <-- replace string

def number_divs(m):
	global divcount
	divcount = divcount + 3
	return '''<div xml:id="div%s">''' %divcount
	
def number_paras(m):
	global pcount
	pcount = pcount + 3
	return '''<p xml:id="p%s">''' %pcount
	
def number_roots(m):
	global TEIcount
	TEIcount = TEIcount + 3
	return '''<TEI xml:id="ch%s" xmlns="http://www.tei-c.org/ns/1.0">''' %TEIcount


## Main
files = handle_args(sys.argv[1:])

if not os.path.isdir(output_dir):
	os.mkdir(output_dir)

for file in files:
	# set counters to 0 (or a value) to make them reset to that value for each file
	# comment counters out to increment across files
	# (maybe add a command-line switch for this)
	#bibcount = 70
	#divcount = 110
	#pcount = 480
	s = read_file(file)
	s = re.sub(r'''<bibl>''',   ## <-- edit search regex! ## previous
			   number_bibs,
			   s)
	s = re.sub(r'''<div>''',number_divs,s)
	s = re.sub(r'''<p>''',number_paras,s)
	s = re.sub(r'''<TEI>''',number_roots,s)
	write_file(os.path.join(output_dir, file), s)

print '\n  TEIcount ended at %s.' % TEIcount
print '\n  Bibcount ended at %s.' % bibcount
print '\n  Divcount ended at %s.' % divcount
print '\n  Pcount ended at %s.' % pcount
