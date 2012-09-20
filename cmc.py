"""
Random useful functions, compiled by CMC.

Created 9/3/2003
"""
import pre as re
from implib.caseconv import convert_case

def regexr(searchlist, searchstring):
	"""
	Accepts an arbitrary length list of tuples containing
	regular expressions, and runs them on the specified string.
	Tuples are of the form (search, replace). Also understands
	the "\L(spam)\=" style of case conversion, seen in span_inq.
	Only does lowercase for the time being, because I'm a lazy bum.
	"""
	for (search, replace) in searchlist:
		# Handle regex flags in search expressions
		find_flag = re.compile(r'\(\?s\)(.*)')
		search = find_flag.sub(r'\1, re.DOTALL', search)
		# Handle case conversion flags in replace expressions
		find_case_conv = re.compile(r'\\L(.*)\\=')
		replace = find_case_conv.sub(r'<convert_case case="lowercase">\1</convert_case>',replace)
		regex = re.compile(search)
		# Now do the actual substitutions and case conversion
		searchstring = regex.sub(replace, searchstring)
		searchstring = convert_case(searchstring)
	return searchstring

def GetMultTagContent(TagName, String):
	'''Returns a list containing the content of each example of a particular
	element(TagName) in a particular string (String).'''

	L = []
	RegEx = r"<%s.*?>(.*?)</%s.*?>" % (TagName, TagName)
	TAG = re.compile(RegEx, re.DOTALL)
	Match = TAG.search(String)
	while Match:
		Content = Match.group(1)
		INDEX = Match.end()
		L.append(Content)
		Match = TAG.search(String, INDEX)
	return L

def GetMultTag(TagName, String):
	'''Return a list containing each example of a particular
	element(TagName) in a particular string (String).'''
	
	L = []
	RegEx = r"(<%s.*?>.*?</%s>)" % (TagName, TagName)
	TAG = re.compile(RegEx, re.DOTALL)
	Match = TAG.search(String)
	while Match:
		Content = Match.group(1)
		INDEX = Match.end()
		L.append(Content)
		Match = TAG.search(String, INDEX)
	return L

def GetTagContent(TagName, String):
	'''Return a string containing the content of a particular element (TagName)
	in a particular string (String).'''
	
	L = GetMultTagContent(TagName, String)
	Len = len(L)
	if Len == 0:
		return ""
	elif Len == 1:
		return L[0]
	else:
		print "Found %s '<%s>'s but expected only one." % (Len, TagName)
		raise KeyboardInterrupt

def GetAttributeContent(TagName, Attribute, String):
	'''Returns a string containing the value assigned 
	to an attribute(Attribute)  in a particular tag (TagName),
	found in a particular string (String).'''

	S = ''
	RegEx = r'<%s.*?%s\s?=\s?"([^>]*?)"[^>]*?>' % (TagName, Attribute)
	TAG = re.compile(RegEx, re.DOTALL)
	Match = TAG.search(String)
	return Match.group(1)

def lf_ents():
	glyphlist=[
("aumle","","aumle","",""),
("acarongr","","acarongr",10,11),
("adaacgr","#x1F05","adaacgr",10,11),
("adagr","#x1F01","adagr",10,11),
("agrgr","#x1F70","agrgr",10,11),
("aivrgr","","aivrgr",10,10),
("aivrypogr","","aivrypogr",10,13),
("apsacgr","#x1F04","apsacgr",10,11),
("Apsgr","#x1F08","apsgrUC",13,12),
("apsgr","#x1F00","apsgr",10,11),
("apsgrgr","#x1F02","apsgrgr",10,11),
("archival","","archival",15,15),    # last set
("asterisks","","asterisks",17,12),
("aypogr","#x1FB3","aypogr",10,10),
("betav","#x03D0","betav",6,10),
("bepsi","","bepsi","",""),
("edaacgr","#x1F15","edaacgr",8,11),
("edagr","#x1F11","edagr",8,11),
("eecarongr","","eecarongr",10,14),
("eedagr","#x1F21","eedagr",9,14),
("eegrgr","#x1F74","eegrgr",9,14),
("eeivrgr","","eeivrgr",9,13),
("eepsgrgr","#x1F22","eepsgrgr",9,14),
("eepsivrgr","","eepsivrgr",9,16),
("eeypogr","#x1FC3","eeypogr",9,10),
("egrgr","#x1F72","egrgr",8,11),
("epegr","","epegr",8,10),
("epsacgr","#x1F14","epsacgr",8,11),
("epsgr","#x1F10","epsgr",8,11),
("frac13","","frac13",13,11),
("frac23","","frac23",14,11),
("frac56","","frac56",14,11),
("icarongr","","icarongr",7,10),
("icaronpsgr","","icaronpsgr",7,10),
("idagr","#x1F31","idagr",6,11),
("igrgr","#x1F76","igrgr",6,11),
("iivrgr","","iivrgr",7,9),
("ipsacgr","#x1F34","ipsacgr",7,10),
("ipsgr","#x1F30","ipsgr",6,11),
("ipsgrgr","#x1F32","ipsgrgr",7,10),
("ipsivrgr","","ipsivrgr",8,13),
("ivrgr","#x1FD0","ivrgr",7,10),
("nacgr","","nacgr",9,11),
("npegr","","npegr",9,10),
("npsgr","","npsgr",9,11),
("odaacgr","#x1F45","odaacgr",8,11),
("odagr","#x1F41","odagr",8,11),
("odagrgr","#x1F43","odagrgr",8,11),
("ogrgr","#x1F78","ogrgr",8,11),
("ohcarongr","","ohcarongr",11,11),
("ohcaronypogr","","ohcaronypogr",11,13),
("ohdaacgr","#x1F65","ohdaacgr",11,11),
("ohdagr","#x1F61","ohdagr",11,11),
("ohivrgr","","ohivrgr",11,10),
("ohpegr","#x1FF6","ohpegr",11,10),
("ohpsgr","#x1F60","ohpsgr",11,11),
("ohypogr","#x1FF3","ohypogr",11,10),
("opsgr","#x1F40","opsgr",8,11),
("oumle","","oumle","",""),
("oypogr","","oypogr",8,10),
("phiv","#x03D5","phiv",9,11),
("sfrown","#x2639","sfrown",11,9),
("thetav","#x03D1","thetav",8,10),
("ucarondagr","","ucarondagr",9,14),
("udaacgr","#x1F55","udaacgr",9,11),
("udagr","#x1F51","udagr",9,11),
("ugrgr","#x1F7A","ugrgr",9,11),
("uivrgr","","uivrgr",9,10),
("upsgr","#x1F50","upsgr",9,11),
("uumle","","uumle","",""),
("uvrgr","#x1FE0","uvrgr",9,10),    # below added 7-02-2003last set
("ohcircgr","","ohcircgr",11,11),
("ncircgr","","ncircgr",9,11),
("eecircgr","","eecircgr",9,14),
("icircgr","","icircgr",7,11),
("ohcircdagr","","ohcircdagr",11,13),
("acircgr","","acircgr",10,11),
("icircpsgr","","icircpsgr",8,14),
("ncircpsgr","","ncircpsgr",9,12),
("eecircdotgr","","eecircdotgr",9,14),
("ohcircpsdotgr","","ohcircpsdotgr",11,16),
("ohcircpsgr","","ohcircpsgr",11,13),
("ohcircdotgr","","ohcircdotgr",11,14),
("iumlacgr","","iumlacgr",6,13),
("rhocedgr","","rhocedgr",6,12),
("Eedavagr","#x1F2D","eedavagrUC",18,13), # added 7.31.2003
("adavagr","#x1F03","adavagr",10,11),
("idaoxgr","#x1F35","idaoxgr",7,11),
("ipspergr","#x1F36","ipspergr",8,14),
("eepsgr","#x1F20","eepsgr",9,14),
("eepspergr","#x1F26","eepspergr",9,17),
("eedaoxgr","#x1F25","eedaoxgr",9,14),
("rhodagr","#x1FE5","rhodagr",8,13),
("ohpspergr","#x1F66","ohpspergr",11,14),
("opsoxgr","#x1F44","opsoxgr",8,11),
("Adagr","#x1F09","adagrUC",13,12),
("eedapergr","#x1F27","eedapergr",9,17), # added 8.01.2003 (happy 24th, cmc!)
("Odagr","#x1F49","odagrUC",14,12),
("eedavagr","#x1F23","eedavagr",9,14),
("ohvagr","#x1F7C","ohvagr",11,11),
("Odaoxgr","#x1F4D","odaoxgrUC",16,12),
("opsvagr","#x1F42","opsvagr",8,10),
("udavagr","#x1F53","udavagr",9,11),
("ohpsypogr","#x1FA0","ohpsypogr",11,14),
("eepsoxgr","#x1F24","eepsoxgr",9,14),
("Edagr","#x1F19","edagrUC",14,12),
("Epsgr","#x1F18","epsgrUC",14,12),
("Ohpsgr","#x1F68","ohpsgrUC",13,12),
("upsoxgr","#x1F54","upsoxgr",9,11),
("uperigr","#x1FE6","uperigr",9,10),
("mtilde","","mtilde",13,10), # added 8.21.2003
("stilde","","stilde",8,10),
("stigma","#x03DB","stigma",8,9),
("kappav","#x03F0","kappav",7,9)
]
	return glyphlist