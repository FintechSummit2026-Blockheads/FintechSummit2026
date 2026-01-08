from crypto.encryption import decrypt_with_xrp_privkey, encrypt_with_xrp_pubkey
from crypto.wallet import create_and_store_test_wallet, get_wallet_balance, recreate_wallet_from_seed_file

if __name__ == "__main__":
    #print("Creating Alice wallet...")
    #alice_wallet = create_and_store_test_wallet("Alice", password="Alice")
    #print("Done!\n")
    
    # Example: Recreate Alice's wallet
    print("Recreating Alice's wallet from saved seed...")
    alice_recreated = recreate_wallet_from_seed_file("Alice", password="Alice")
    # print(get_wallet_balance(alice_recreated.classic_address))
    print(f"Recreated Alice Address: {alice_recreated.classic_address}")


    message = "Hello XRPL Wallet!".encode()
    print("Original:", message.decode())

    print("\nEncrypting...")
    print(alice_recreated.public_key)
    print(alice_recreated.private_key)
    encrypted = encrypt_with_xrp_pubkey(alice_recreated.public_key, message)
    print(f"Encrypted (base64): {encrypted[:50]}...")
    
    # Decrypt
    print("\nDecrypting...")
    decrypted = decrypt_with_xrp_privkey(alice_recreated.private_key, encrypted)
    print(f"Decrypted message: {decrypted.decode('utf-8')}")