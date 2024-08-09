import random


def gcd(a, b):
    """Computes the GCD of two numbers using the Euclidean algorithm."""
    while b != 0:
        a, b = b, a % b
    return a


def compute_all_public_exp(phi_n):
    all_E = []
    for i in range(2, phi_n):
        if gcd(i, phi_n) == 1:
            all_E.append(i)
            print(f"Possible public exponent : {i}")
    print('-' * 50)
    E = all_E[1] # random.choice(all_E)
    print(f"Selected public exponent : {E}")
    print('-' * 50)
    return E


def compute_all_private_exp(phi_n, e):
    all_D = []
    for x in range(phi_n):
        t = 1 + (x * phi_n)
        if t % e == 0:
            d = t // e
            all_D.append(d)
            print(f"phi_n: {phi_n}, e: {e}, x: {x}, d: {d}")
    print('-' * 50)
    D = all_D[0] # random.choice(all_D)
    print(f"Selected private exponent : {D}")
    print('-' * 50)
    return D


def encrypt(cleartext, public_key_exp, n):
    c = pow(ord(cleartext), public_key_exp) % n
    print(f"Encrypted message: {cleartext}, c: {c}")
    return c


def decrypt(encrypt_text, private_key_exp, n):
    m = pow(encrypt_text, private_key_exp) % n
    print(f"Decrypted message: c: {encrypt_text}, m: {chr(int(m))}")
    return chr(int(m))


P = 11
Q = 17
N = P * Q
PHI_N = (P-1) * (Q-1)
E = compute_all_public_exp(PHI_N)
D = compute_all_private_exp(PHI_N, E)

clear_text = 'Hello World'
print(f"Clear Text: {clear_text}")
encrypted_text = []

for x in clear_text:
    encrypted_text.append(encrypt(x, E, N))
print('-' * 50)
print(f'Encrypted message: {encrypted_text}')
print('-' * 50)

decrypted_text = ''
for x in encrypted_text:
    decrypted_text += decrypt(x, D, N)
print('-' * 50)
print(f'Decrypted message: {decrypted_text}')
