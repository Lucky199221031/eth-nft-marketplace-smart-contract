// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "./interfaces/ProxyRegistryInterface.sol";

contract Custom721 is ERC721Enumerable {
    uint256 public totalMinted;
    mapping(uint256 => string) private tokenUris;
    address private proxyRegistry;

    constructor(
        string memory name,
        string memory symbol,
        address proxy
    ) ERC721(name, symbol) {
        totalMinted = 0;
        proxyRegistry = proxy;
    }

    function mint(string memory uri, uint256 cnt) external {
        uint256 i;
        for (i = 0; i < cnt; ++i) {
            _safeMint(msg.sender, ++totalMinted);
            tokenUris[totalMinted] = uri;
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return tokenUris[tokenId];
    }

    function _isProxyForUser(address _user, address _address)
        internal
        view
        virtual
        returns (bool)
    {
        if (proxyRegistry == address(0)) {
            return false;
        }
        return
            address(ProxyRegistryInterface(proxyRegistry).proxies(_user)) ==
            _address;
    }

    function isApprovedForAll(address _owner, address _operator)
        public
        view
        override
        returns (bool isOperator)
    {
        if (_isProxyForUser(_owner, _operator)) {
            return true;
        }

        return super.isApprovedForAll(_owner, _operator);
    }
}
