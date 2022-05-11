"""contract.cairo test file."""

import pytest
from starkware.starknet.testing.starknet import Starknet

from tests.conftest import ERC4610, admin, deploy, user_one, owner, user1

@pytest.mark.asyncio
async def test_main(deploy):
    (admin, user_one, erc4610) = deploy

    await owner.send_transaction(admin,
                                 erc4610.contract_address,
                                 'mint',
                                 [user_one.contract_address, 1, 0])
    data = await owner.send_transaction(admin,
                                 erc4610.contract_address,
                                 'ownerOf',
                                 [1, 0])
    assert data.result.response[0] == user_one.contract_address
    await user1.send_transaction(user_one,
                                 erc4610.contract_address,
                                 'setDelegator',
                                 [admin.contract_address, 1, 0])
    data = await owner.send_transaction(admin,
                                 erc4610.contract_address,
                                 'delegatorOf',
                                 [1, 0])
    assert data.result.response[0] == admin.contract_address
    
