N, M = map(int, input().split())
ks = [list(map(int, input().split())) for i in range(M)]
p = list(map(int, input().split()))
k = []
s = []
for i in range(M):
    k.append(ks[i][0])
    s.append(ks[i][1:])
A = [i for i in range(1, 11)]
count = 0
for i in range(1 << N):
    B = []
    flag = True
    for j in range(10):
        if (i >> j) & 1:
            B.append(A[j] * ((i >> j) & 1))
    for x in range(M):
        c = 0
        for y in range(k[x]):
            if s[x][y] in B:
                c += 1
        if c % 2 != p[x]:
            flag = False
            break
    if flag:
        count += 1
print(count)
