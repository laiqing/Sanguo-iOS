import sys

xp = []
for i in range(2,51):
	if (i<12):
		exp = 200
		addition = 800
		level = 0
		ratio = 200
		while (level<i):
			exp += addition
			ratio += ratio*6/100
			addition += (ratio/100)*100
			level += 1
	else:
		exp = 20600
		level = 11
		addition = 3100
		while (level<i):
			addition = addition*1.2
			exp += addition
			level += 1
	xp.append(int(round(exp)))
print xp
