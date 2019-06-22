N, M = list(map(int, input().split()))
tmp=0
 
if N==1:
  print(M)
  tmp=1
else:
  for i in range(int(M**0.8)+1):
    k = i + N
    if M % k == 0:
      print(int(M/k))
      tmp=1
      break
 
if tmp==0:
  print(1)
