import json
import re
import time

#st = r'[{"id":0,"ename":"add_iron","cname":"yelian","passive":1,"skillIcon":"addiron"}]'
print "current:",time.clock()
f = open('cityinfo.json')
citydata = json.loads(f.read())
f.close()
print "after read city:",time.clock()

f1 = open('heroes.json')
herodata = json.loads(f1.read())
f1.close()
print "after read hero:",time.clock()

for hero in herodata:
	#get the city id , check if the city in the city data , it's owner == hero's owner
	hid = hero["id"]
	hcid = hero["defaultCity"]
	howner = hero["owner"]
	for city in citydata:
		cid = city["id"]
		cowner = city["flag"]
		if hcid==cid:
			#found
			if howner!=cowner:
				print hid,howner,"wrong city"
			break
print "after hero loop check city:",time.clock()