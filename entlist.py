
import time
from implib.io import read_file, write_file

glyphlist=[
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
("bepsi","","bepsi",8,7),
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
("kappav","#x03F0","kappav",7,9),
("eecircypogr","","eecircypogr",9,14),
("ndaivgr","","ndaivgr",9,12),
("icircdagr","","icircdagr",7,15),
("ncircdagr","","ncircdagr",9,14),
("eecircdagr","","eecircdagr",9,18),
("ohypogivrgr","","ohypogivrgr",11,13),
("eedaypogivrgr","","eedaypogivrgr",9,17),
("eeypogivrgr","","eeypogivrgr",9,13),
("ohdaivrypogr","","ohdaivrypogr",11,16),
("eepsivrypogr","","eepsivrypogr",9,17),
("apsiivrgr","","apsiivrgr",10,14),
("upsiivrgr","","upsiivrgr",9,14),
("bar1","","bar1",9,11),
("bar2","","bar2",9,11),
("bar3","","bar3",9,11),
("bar4","","bar4",9,11),
("bar8","","bar8",9,11),
("bar9","","bar9",9,11),
("bar27","","bar27",13,11),
("eoxgr","#x1F73","eoxgr",8,11),
("rhopsgr","#x1FE4","rhopsgr",8,13),
("ipergr","#x1FD6","ipergr",8,10),
("udaivrgr","","udaivrgr",9,13),
("idaivrgr","","idaivrgr",8,13),
("eedaivrgr","","eedaivrgr",9,16),
("ohdaivrgr","","ohdaivrgr",11,13),
("ohbargr","","ohbargr",11,9),
("ohpsoxgr","#x1F64","ohpsoxgr",11,11),## added 11.13.03
("ohoxypogr","#x1FF4","ohoxypogr",9,14),
("idavagr","#x1F33","idavagr",7,11),
("edavagr","#x1F13","edavagr",8,11),
("aoxypogr","#x1FB4","aoxypogr",10,11),
("apsgrUC","#x1F08","apsgrUC",13,12),
("idivagr","#x1FD2","idivagr",7,11),
("epsvagr","#x1F12","epsvagr",8,11),
("ohpsgrUC","#x1F48","ohpsgrUC",14,12),
("ohpsvaypogr","#x1FA2","ohpsvaypogr",11,14),
("ohpsvagr","#x1F62","ohpsvagr",11,11),
("apsoxgrUC","#x1F0C","apsoxgrUC",14,11),
("eeoxypogr","#x1FC4","eeoxypogr",9,14),
("edaoxgrUC","#x1F1D","edaoxgrUC",15,13),
("idagrUC","#x1F39","idagrUC",10,12),
("epsoxgrUC","#x1F1C","epsoxgrUC",16,13),
("ipsgrUC","#x1F38","ipsgrUC",10,13),
("rdagrUC","#x1FEC","rdagrUC",13,11),
("eedagrUC","#x1F29","eedagrUC",16,12),
("ioxgr","#x1F77","ioxgr",6,11),
("apsvagrUC","#x1F0A","apsvagrUC",15,11),
("apsoxypogr","#x1F84","apsoxypogr",10,14),
("ipsoxgrUC","#x1F3C","ipsoxgrUC",12,13)
]

t = time.ctime()
tStr = '(Generated ' + t + ')'
css = '<style type="text/css">\n<!--\ntable { font-family: Arial, sans-serif;\n' \
      '       font-size: 10pt; }\ntd { background: #cccccc } \n--></style>'

html_str = '<html>\n<head>\n<title>LF/OLL Glyph List ' + tStr + '</title>\n' + css + '</head>' \
           '\n<body>\n' + str(len(glyphlist)) + '<table align="center" cellpadding="2">\n<tr bgcolor="gray">\n\t<th>Entity Name</th>\n\t<th>' \
           'Unicode code point (hex)</th>\n\t<th>Glyph name</th>\n\t<th>Image</th>\n\t<th>Dimensions</th>' \
           '\n</tr>'

glyphlist.sort()

for glyph in glyphlist:
	n = glyph[0]
	hx = glyph[1]
	gn = glyph[2]
	w = glyph[3]
	h = glyph[4]
	w2 = glyph[3]*2
	h2 = glyph[4]*2

	glyph_str = '''
<tr>
	<td>%(n)s</td>
	<td>%(hx)s</td>
	<td>%(gn)s.png</td>
	<td><img src="S:\\projects\\lf_temp\\various_resources\\special_characters\\latest_glyphs\\%(gn)s.png" alt="%(gn)s" width="%(w)s" height="%(h)s">
	&nbsp;<img src="S:\\projects\\lf_temp\\various_resources\\special_characters\\latest_glyphs\\%(gn)s.png" alt="%(gn)s" width="%(w2)s" height="%(h2)s"></td>
	<td>%(w)sx%(h)s</td>
</tr>''' % vars()

	html_str = html_str + glyph_str
    

html_str = html_str + '\n</table>\n</body>\n</html>'
write_file('glyphlist.htm', html_str)


    
    



