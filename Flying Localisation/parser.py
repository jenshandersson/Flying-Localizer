from __future__ import print_function
import os, ast, json

string_filename = "Localizable.strings"

def parse_file(fname):
	f = open(fname)
	lines = f.readlines()
	strings = {}
	for line in lines:
		parts = line.split('=')
		if len(parts) != 2:
			continue
		key = ast.literal_eval(parts[0].strip())
		value = ast.literal_eval(parts[1].strip(' ;'))
		strings[key] = value
	f.close()
	return strings

all_dirs = os.walk('.').next()[1]

lang_dirs = [dir for dir in all_dirs if dir.endswith('lproj')]


response = {}
for lang in lang_dirs:
	code = lang.split('.')[0]
	fname = "%s/%s" % (lang, string_filename)
	strings = parse_file(fname)
	response[code] = strings

f = open('response.json', "w")
print(json.dumps(response), file=f)
f.close()

