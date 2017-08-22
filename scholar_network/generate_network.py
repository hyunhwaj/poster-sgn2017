from itertools import combinations
from collections import defaultdict

G = defaultdict( int )
with open("input.txt", "r") as inp:
    lines = inp.readlines()
    n = len(lines)
    for line in lines:
        name = line.strip().split("; ")
        for a, b in combinations(name, 2):
            if a > b: a, b = b, a
            G[(a,b)] += 1

with open("network.tsv", "w") as oup:
    oup.write("Source\tTarget\tWeight\n")
    for node, weight in G.items():
        oup.write("{}\t{}\t{}\n".format(node[0], node[1], weight*1./n))
