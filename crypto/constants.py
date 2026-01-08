from pathlib import Path
from xrpl.clients import JsonRpcClient

CLIENT = JsonRpcClient("https://s.altnet.rippletest.net:51234")

SEED_FOLDER = Path("seed")
SEED_FOLDER.mkdir(exist_ok=True)