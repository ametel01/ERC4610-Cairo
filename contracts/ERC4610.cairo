%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

@storage_var
func _name() -> (name : felt):
end

@storage_var
func _symbol() -> (symbol : felt):
end

@storage_var
func _tokenId_to_delegator(tokeId : Uint256) -> (delegator : felt):
end

@storage_var
func _tokenId_to_owner(tokeId : Uint256) -> (owner : felt):
end
