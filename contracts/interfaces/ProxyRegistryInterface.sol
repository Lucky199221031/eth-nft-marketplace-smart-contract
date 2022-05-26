// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

interface ProxyRegistryInterface {
    function proxies(address addr) external view returns (address);
}
