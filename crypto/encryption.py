
import os
import base64
from ecies import encrypt, decrypt
from coincurve import PublicKey, PrivateKey

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from crypto.constants import SEED_FOLDER

# 1. Encrypt/Decrypt for accessing wallet seed stored locally
def _get_key(password: str, salt: bytes) -> bytes:
    """Helper to derive a cryptographic key from a password and salt."""
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=480000,
    )
    return base64.urlsafe_b64encode(kdf.derive(password.encode()))

def save_seed_to_file(name: str, seed: str, password: str):
    salt = os.urandom(16) 
    
    key = _get_key(password, salt)
    f = Fernet(key)
    encrypted_data = f.encrypt(seed.encode())
    
    with open(SEED_FOLDER / f"{name}.txt", "wb") as file:
        file.write(salt + encrypted_data)
    print(f"Seed successfully encrypted and saved to", str(SEED_FOLDER / f"{name}.txt"))

def retrieve_seed(name: str, password: str) -> str:
    if not os.path.exists(SEED_FOLDER / f"{name}.txt"):
        raise FileNotFoundError("No seed file found.")

    with open(SEED_FOLDER / f"{name}.txt", "rb") as file:
        file_content = file.read()
        
    salt = file_content[:16]
    encrypted_data = file_content[16:]
    
    key = _get_key(password, salt)
    f = Fernet(key)
    
    try:
        decrypted_seed = f.decrypt(encrypted_data)
        return decrypted_seed.decode()
    except Exception:
        return "Error: Wrong password or corrupted file."


# 2. Encrypt/Decrypt with keys for fulfilment fields in DateDB
def encrypt_with_xrp_pubkey(wallet_pubkey_hex: str, plaintext: bytes) -> str:
    pubkey_hex = wallet_pubkey_hex.replace('0x', '').replace('0X', '')
    pubkey_bytes = bytes.fromhex(pubkey_hex)
    
    pubkey = PublicKey(pubkey_bytes)
    uncompressed_pubkey = pubkey.format(compressed=False)
    
    encrypted = encrypt(uncompressed_pubkey, plaintext)
    return base64.b64encode(encrypted).decode('utf-8')

def decrypt_with_xrp_privkey(wallet_privkey_hex: str, encrypted_str: str) -> bytes:    
    privkey_hex = wallet_privkey_hex.replace('0x', '').replace('0X', '')
    privkey_bytes = bytes.fromhex(privkey_hex)
    
    if len(privkey_bytes) == 33 and privkey_bytes[0] == 0x00:
        privkey_bytes = privkey_bytes[1:]
    
    privkey = PrivateKey(privkey_bytes)
    
    encrypted_bytes = base64.b64decode(encrypted_str)
    plaintext = decrypt(privkey.secret, encrypted_bytes)
    return plaintext
