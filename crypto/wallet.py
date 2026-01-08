
from xrpl import CryptoAlgorithm
from xrpl.wallet import generate_faucet_wallet, Wallet
from xrpl.models.requests import AccountInfo

from crypto.constants import CLIENT
from crypto.encryption import save_seed_to_file, retrieve_seed


# Initialize XRPL testnet CLIENT

# Folder to store seeds


def create_and_store_test_wallet(name: str, password: str) -> Wallet:
    pre_wallet = Wallet.create(algorithm=CryptoAlgorithm.SECP256K1)
    wallet = generate_faucet_wallet(CLIENT, wallet=pre_wallet)
    save_seed_to_file(name, wallet.seed, password)
    
    print(f"\n=== {name} Wallet ===")
    print(f"Classic Address: {wallet.classic_address}")
    print(f"Public Key: {wallet.public_key}")
    print(f"Private Key: {wallet.private_key}")
    print(f"Seed: {wallet.seed}")
    print(f"Password: {password}")
    print("====================\n")
    
    return wallet

def recreate_wallet_from_seed_file(name: str, password: str) -> Wallet:
    seed = retrieve_seed(name, password)
    return Wallet.from_seed(seed, algorithm=CryptoAlgorithm.SECP256K1)


def get_wallet_balance(address: str) -> float:
    """
    Retrieves the XRP balance of an account.
    Returns balance in XRP (float), not drops.
    """
    acct_info = AccountInfo(
        account=address,
        ledger_index="validated",
        strict=True
    )
    response = CLIENT.request(acct_info)
    drops = response.result["account_data"]["Balance"]  # in drops (1 XRP = 1,000,000 drops)
    return int(drops) / 1_000_000



