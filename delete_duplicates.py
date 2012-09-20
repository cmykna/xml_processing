from implib.io import read_file, write_file
import re, sys
f = read_file(sys.argv[1])
split = re.compile(r'^.*?$', re.MULTILINE)
l = split.findall(f)

for item in l:
	while l.count(item) > 1:
		l.remove(item)

s = ''
for item in l:
	s = s + item + '\n'
	
write_file(sys.argv[2], s)