// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SHRescue} from '@src/SHRescue.sol';
import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import {IERC1155} from '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';

abstract contract SHRescueV2 is SHRescue {
  function rescueBatchERC721(
    address token,
    uint256[] calldata _ids,
    address recipient
  ) external onlyOwner {
    require(recipient != address(0), 'SHRescue: invalid recipient');
    for (uint256 i = 0; i < _ids.length; i++) {
      IERC721(token).transferFrom(address(this), recipient, _ids[i]);
    }
  }

  function rescueBatchERC1155(
    address token,
    uint256[] calldata ids,
    uint256[] memory amounts,
    bytes calldata data,
    address recipient
  ) external onlyOwner {
    require(recipient != address(0), 'SHRescue: invalid recipient');
    require(ids.length == amounts.length, 'SHRescue: invalid array length');
    for (uint256 i = 0; i < ids.length; ++i) {
      if (amounts[i] == 0) amounts[i] = IERC1155(token).balanceOf(address(this), ids[i]);
    }
    IERC1155(token).safeBatchTransferFrom(address(this), recipient, ids, amounts, data);
  }
}
