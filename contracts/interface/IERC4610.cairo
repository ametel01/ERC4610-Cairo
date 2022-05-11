%lang starknet

from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace IERC4610:
    # @dev Set or remove `delegator` for the owner.
    # The delegator has no direct permission, just an additional attribute.
    #
    # Requirements:
    #
    # - The `delegator` cannot be the caller.
    # - `tokenId` must exist.
    #
    # Emits an {SetDelegator} event.
    #
    func SetDelegator(delegator : felt, tokenId : Uint256):
    end

    # @dev Returns the delegator of the 'tokenId' token.
    #
    # Requirements:
    #
    # - `tokenId` must exist.
    #
    func delegatorOf(tokenId : Uint256) -> (delegator : felt):
    end

    # @dev Safely transfer 'tokeId' token from 'from' to 'to'
    # 'delegator' won't be cleared if 'reserved' is true.
    #
    # Requirements:
    #
    # - '_from' cannot be the zero address.
    # - '_to' cannot be the zero address.
    # - 'tokenId' must exists and be owned by 'from'.
    # - if the caller is not 'from', it must be approved to move this token by either {approve} or {setApprovalForAll}.
    # - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
    # - If `reserved` is true, it won't clear the `delegator`.
    #
    # Emits a {Transfer} event.
    #
    func safeTransferFrom(_from : felt, _to : felt, tokenId : felt, reserved : felt):
    end
end
