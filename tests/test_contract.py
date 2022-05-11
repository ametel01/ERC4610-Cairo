"""contract.cairo test file."""

import pytest
from starkware.starknet.testing.starknet import Starknet

from tests.conftest import ERC4610, admin, deploy, user_one

@pytest.mark.asyncio
async def test_increase_balance(deploy):
    admin, user_one, erc4610 = deploy()

    
