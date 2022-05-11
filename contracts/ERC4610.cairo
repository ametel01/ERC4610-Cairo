%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.introspection.ERC165 import ERC165_supports_interface
from openzeppelin.token.erc721.library import (
    ERC721_balanceOf,
    ERC721_ownerOf,
    ERC721_name,
    ERC721_symbol,
    ERC721_tokenURI,
    ERC721_approve,
    ERC721_getApproved,
    ERC721_setApprovalForAll,
    ERC721_isApprovedForAll,
    ERC721_transferFrom,
    ERC721_safeTransferFrom,
)

const IERC4610_ID = 0x7f3a4126
const IERC721_ID = 0x80ac58cd
const IERC721_METADATA_ID = 0x5b5e139f
const TRUE = 1
const FALSE = 0

@storage_var
func _name() -> (name : felt):
end

@storage_var
func _symbol() -> (symbol : felt):
end

@storage_var
func _delegators(tokeId : Uint256) -> (delegator : felt):
end

@storage_var
func _owners(tokeId : Uint256) -> (owner : felt):
end

@storage_var
func _balances(address : felt) -> (balance : Uint256):
end

@storage_var
func _tokenApprovals(tokeId : Uint256) -> (address : felt):
end

@storage_var
func _operatorApprovals(owner : felt, operator : felt) -> (isApproved : felt):
end

# @dev  Initializes the contract by setting a 'name' and a 'symbol' to tho token collection.
#
@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    name : felt, symbol : felt
):
    _name.write(name)
    _symbol.write(symbol)
    return ()
end

@external
func SupportsInterface{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    interfaceId : felt
) -> (success : felt):
    if interfaceId == IERC721_ID:
        return (TRUE)
    end
    if interfaceId == IERC721_METADATA_ID:
        return (TRUE)
    end
    if interfaceId == IERC4610_ID:
        return (TRUE)
    end
    let (success) = ERC165_supports_interface(interfaceId)
    return (FALSE)
end

func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
    let (name) = ERC721_name()
    return (name)
end

@view
func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (symbol : felt):
    let (symbol) = ERC721_symbol()
    return (symbol)
end

@view
func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(owner : felt) -> (
    balance : Uint256
):
    let (balance : Uint256) = ERC721_balanceOf(owner)
    return (balance)
end

@view
func ownerOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (owner : felt):
    let (owner : felt) = ERC721_ownerOf(tokenId)
    return (owner)
end

@view
func tokenURI{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (tokenURI : felt):
    let (tokenURI : felt) = ERC721_tokenURI(tokenId)
    return (tokenURI)
end

@view
func getApproved{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (approved : felt):
    let (approved : felt) = ERC721_getApproved(tokenId)
    return (approved)
end

@view
func isApprovedForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    owner : felt, operator : felt
) -> (isApproved : felt):
    let (isApproved : felt) = ERC721_isApprovedForAll(owner, operator)
    return (isApproved)
end

@view
func delegatorOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    tokenId : Uint256
) -> (address : felt):
    let (owner) = _owners.read(tokenId)
    with_attr error_message("ERC4610: delegated query for nonexistent token"):
        assert_not_zero(owner)
    end
    let (delegator) = _delegators.read(tokenId)
    return (delegator)
end

##########################################################################################
#                                   EXTERNALS                                            #
##########################################################################################

@external
func approve{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    to : felt, tokenId : Uint256
):
    ERC721_approve(to, tokenId)
    return ()
end

@external
func setApprovalForAll{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    operator : felt, approved : felt
):
    ERC721_setApprovalForAll(operator, approved)
    return ()
end

@external
func setDelegator{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    delegator : felt, tokenId : Uint256
):
    let (owner) = _owners.read(tokenId)
    let (caller) = get_caller_address()
    if owner == caller:
        _delegators.write(tokenId, delegator)
        return ()
    end
    let (approved) = isApprovedForAll(owner, caller)
    with_attr error_message("ERC4610: setDelegator caller is not owner nor approved for all"):
        assert approved = TRUE
    end
    return ()
end

@external
func transferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    from_ : felt, to : felt, tokenId : Uint256
):
    ERC721_transferFrom(from_, to, tokenId)
    return ()
end

@external
func safeTransferFrom{pedersen_ptr : HashBuiltin*, syscall_ptr : felt*, range_check_ptr}(
    from_ : felt, to : felt, tokenId : Uint256, data_len : felt, data : felt*
):
    ERC721_safeTransferFrom(from_, to, tokenId, data_len, data)
    return ()
end
