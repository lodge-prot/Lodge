H, W, K = map(int, input().split())
mod = 10 ** 9 + 7
A = [[0] * (W + 2) for i in range(H + 1)]
A[0][1] = 1
def multiple(N):
    temp = [1, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
    return (temp[N + 1])

for i in range(1, H + 1):
    for j in range(1, W + 2):
        if j < 1 or j > W:
            A[i][j] = 0
        else:
            A[i][j] = (A[i - 1][j - 1] * (multiple(j - 2) * multiple(W - j)) +
                       A[i - 1][j] * (multiple(j - 1) * multiple(W - j)) +
                       A[i - 1][j + 1] * (multiple(j - 1) * multiple(W - j - 1))) % mod
print(A[H][K])
