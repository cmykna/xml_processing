saxon2 --ext=_QA.htm --output-dir=QA_xhtml --param="proof=clean" *.xml x:\PDR\ep\SPLPlus-QA-xhtml.xsl
cd QA_xhtml
normalize_markup --tagname_case=upper --attname_case=upper --strip_doctype --strip_comments --strip_pis *.htm
cd normalize_markup
saxon2 --ext=_LEGACY.htm --output-dir=LEGACY *.htm x:\PDR\ep\pdr_html.xsl
cd LEGACY
span_inq -oCLEANUP *.htm x:\PDR\ep\PDRlegacyCleanup.data

