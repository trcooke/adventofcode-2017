file = open("input")

towers = {}
for line in file:
    l = line.split("->")
    [name, weight] = l[0].split()
    if len(l) == 1:
        towers[name] = (int(weight.strip("()")), [])
    else:
        above = map(lambda x: x.strip(), l[1].split(","))
        towers[name] = (int(weight.strip("()")), above)

ts = towers.keys()
abos = []
for t in towers:
    for a in towers[t][1]:
        abos.append(a)

print filter(lambda x: x not in abos, ts)
