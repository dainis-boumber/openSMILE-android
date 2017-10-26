import os
import glob
import sys
#this file must be run once if default sources are used. It will ease your life greatly, although you will still need to fix a few things manually
cppList = glob.glob("src/*.cpp")
hppList = glob.glob("src/*.hpp")

for cppFile in cppList:
	f = open(cppFile, "r+")
	s = f.read()
	indexOfLastInclude = s.rfind("#include")
	if indexOfLastInclude >= 0:
		endLine = s.find("\n", indexOfLastInclude)
		f.seek(0)
		if s.find("getline") >= 0:
			modified = s[:endLine] + "\n#include <getline.h>\n\n#ifdef _N\n#undef _N\n#endif\n\n" + s[endLine:]
			modified = modified.replace("getline","senguard_getline")
			f.write(modified)
		else:
			f.write(s[:endLine] + "\n\n#ifdef _N\n#undef _N\n#endif\n\n" + s[endLine:])
	f.close()

for hppFile in hppList:
	f = open(hppFile, "r+")
	s = f.read()
	indexOfLastInclude = s.rfind("#include")
	if indexOfLastInclude >= 0:
		endLine = s.find("\n", indexOfLastInclude)
		f.seek(0)
		if s.find("getline") >= 0:
			modified = s[:endLine] + "\n#include <getline.h>\n\n#ifdef _N\n#undef _N\n#endif\n\n" + s[endLine:]
			modified = modified.replace("getline","senguard_getline")
			f.write(modified)
		else:
			f.write(s[:endLine] + "\n\n#ifdef _N\n#undef _N\n#endif\n\n" + s[endLine:])
	f.close()
