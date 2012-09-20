import re, glob
from implib.io import read_file, write_file
from implib.cmc import regexr

#--------------------------------------------------------------------------------
#Functions
#--------------------------------------------------------------------------------

def issue_info(f):
	# Extracts volume, issue, and month/year info from Penta mess
	regex = re.compile('\[cp14\]Volume ([0-9]+)\[hmp4\];pd\[hmp4\]Number ([0-9]+)\[hmp4\];pd\[hmp4\](.*?)\[qc')
	match = regex.search(f)
	id = match.groups()
	return id

def shortID(f):
	shortID = issue_info(f)
	sID = shortID[0] + ':' + shortID[1]
	return sID

def longID(f):
	longID = issue_info(f)
	lID = 'Volume ' + longID[0] + '&#x00B7; Number ' + longID[1] + '&#x00B7; ' + longID[2]
	return lID

#--------------------------------------------------------------------------------
#regexr list
#--------------------------------------------------------------------------------
cleanupL = [
#with "20"
('<1>20(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)\[cm',
r'<p><a href="\1.html" name="\1">\2</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\3</b></p>'),
('<1>20(\[cf.])(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)\[cm',
r'<p><a href="\2.html" a href="\2">\3</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\4</b></p>'),
('<1>20(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)',
r'<p><a href="\1.html" name="\1">\2</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\3</b></p>'),
('<1>20(\[cf.])(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)',
r'<p><a href="\2.html" name="\2">\3</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\4</b></p>'),
#without "20"
('<1>(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)\[cm',
r'<p><a href="\1.html" name="\1">\2</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\3</b></p>'),
('<1>(\[cf.])(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)\[cm',
r'<p><a href="\2.html" name="\2">\3</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\4</b></p>'),
('<1>(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)',
r'<p><a href="\1.html" name="\1">\2</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\3</b></p>'),
('<1>(\[cf.])(\d+)\[cm\n?(.+?)\[cm(.+?)\[cm(\d+)',
r'<p><a href="\2.html" name="\2">\3</a><br />\n&#x00A0;&#x00A0;&#x00A0;&#x00A0;<b>\4</b></p>'),
('<2>(.+?)\[cm',r'<h2>\1</h2>'),
('<%',r'<'),
('<%?&(.+?);>',r'&\1;'),
(';t\d',r''),
(';aa(.)',r'&\1acute;'),
(';au(.)',r'&\1uml;'),
(';et',r'&eth;'),
('\[om..\]',r''),
('\[hm(.+?)\]',r''),
('\[cf..?\]',r''),
('\[..',r''),
('<page.*?>', r''),
('<(/?)I>', r'<\1i>'),
('<(/?)B>', r'<\1b>'),
('<(/?)INF>', r'<\1sub>'),
('<(/?)SUB>', r'<\1sub>'),
('<(/?)SUP>', r'<\1sup>'),
('0\]-9\]', r'')
]

files = glob.glob('*toc')

for file in files:
	f = read_file(file)
	s_id = shortID(f)
	l_id = longID(f)
	toc = '<?xml version="1.0" encoding="iso-8859-1"?>\n' \
		  '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" ' \
		  '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n' \
		  '<html xmlns="http://www.w3.org/1999/xhtml">\n<head>\n<title>' \
		  'BSSA, Volume ' + s_id + '</title>\n</head>\n' \
		  '<body bgcolor="#FFFFFF" link="#0000FF" vlink="#FF0000" alink="#E6E6E6">' \
		  '\n<table cellpadding="20" cellspacing="0" width="500">\n<tr><td>\n' \
		  '<h2>Bulletin of the<br />Seismological Society of America</h2>\n' \
		  '<p><b><span style="font-size: larger">' + l_id + '</span></b></p>\n' \
		  '<h2>Contents</h2>\n'
	regex = re.compile('<pag>.*?\]<1>', re.DOTALL)
	f = regex.sub('<1>', f)
	f = regexr(cleanupL, f)
	toc = toc + f + '<hr />\n<table border="0" cellpadding="5" cellspacing="0">\n' \
		  '<tr>\n<td bgcolor="0000FF"><p>[ <a href="javascript:history.go(-1)">Back</a> ]</p>' \
		  '\n</td></tr></table>' \
		  '\n</td></tr></table>\n</body></html>'
	regex = re.compile('^.*ssa_e_logo.*$', re.MULTILINE)
	toc = regex.sub('', toc)
	namestr = 'ssa_toc' + file[3:5] + '-' + file[5] + '.html'
	write_file(namestr, toc)
