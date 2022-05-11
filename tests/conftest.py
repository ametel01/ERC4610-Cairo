import os

import pytest
import pytest_asyncio
from starkware.starknet.testing.starknet import Starknet
from starkware.starknet.testing.contract import StarknetContract
from tests.utils import Signer

ERC4610_FILE = os.path.join("contracts", "ERC4610.cairo")
ACCOUNT_FILE = os.path.join("tests", "utils", "Account.cairo")
owner = Signer(123456789987654321)
user1 = Signer(11111111111111111)

@pytest_asyncio.fixture
async def starknet():
    return await Starknet.empty()

@pytest_asyncio.fixture
async def admin(starknet: Starknet) -> StarknetContract:
    return await starknet.deploy(
        source=ACCOUNT_FILE,
        constructor_calldata=[owner.public_key])


@pytest_asyncio.fixture
async def user_one(starknet: StarknetContract) -> StarknetContract:
    return await starknet.deploy(
        source=ACCOUNT_FILE,
        constructor_calldata=[user1.public_key])

@pytest_asyncio.fixture
async def ERC4610(starknet: StarknetContract) -> StarknetContract:
    return await starknet.deploy(
        source=ERC4610_FILE,
        constructor_calldata=[0x54657374, 0x546573744e4654])

@pytest_asyncio.fixture
async def deploy(admin, user_one, ERC4610):
    return(admin, user_one, ERC4610)