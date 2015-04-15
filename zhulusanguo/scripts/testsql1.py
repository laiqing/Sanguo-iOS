#coding=utf-8

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import sqlite3
import json

#f = open('heroes.json')
#herodata = json.loads(f.read())
#f.close()

liu = {"1":0,"2":0,"3":0,"4":0,"5":0}

#for hero in herodata:
#	if hero["city"]==52:
#		if hero["troopType"]==1:
#			liu["1"] += hero["troopCount"]
#		elif hero["troopType"]==2:
#			liu["2"] += hero["troopCount"]
#		elif hero["troopType"]==3:
#			liu["3"] += hero["troopCount"]
#		elif hero["troopType"]==4:
#			liu["4"] += hero["troopCount"]
#		elif hero["troopType"]==5:
#			liu["5"] += hero["troopCount"]

#print "liu"
#print liu

db = sqlite3.connect("sanguo.db")
cu = db.cursor()

#f = open("c.txt","w")
cu.execute("select cname,tower1,tower2,tower3,tower4 from city order by id ASC")
res = cu.fetchall()
for r in res:
	print r #f.write("@\""+r[0]+"\",")

#f.close()
cu.close()
db.close()