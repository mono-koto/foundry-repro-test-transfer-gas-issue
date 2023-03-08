// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract Foo {
    receive() external payable {}
    fallback() external payable {}
}

contract ProxyEthReceiveLocalOnlyTest is Test {
    function testTransferToProxy() public {
        address payable proxy = payable(new ERC1967Proxy(address(new Foo()), ""));
        proxy.transfer(1 ether);
        assertEq(address(proxy).balance, 1 ether);
    }

    function testTransferToClone() public {
        address payable clone = payable(Clones.clone(address(new Foo())));
        clone.transfer(1 ether);
    }
}

contract ProxyEthReceiveSetupTest is Test {
    address payable proxy;
    address payable clone;

    function setUp() public {
        proxy = payable(new ERC1967Proxy(address(new Foo()), ""));
        clone = payable(Clones.clone(address(new Foo())));
    }

    function testTransferToProxy() public {
        proxy.transfer(1 ether);
        assertEq(address(proxy).balance, 1 ether);
    }

    function testTransferToClone() public {
        clone.transfer(1 ether);
    }
}
