// SPDX_License_Identifier: UMLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {EtherWallet} from '../src/Ether_Wallet.sol';

contract Ether_WalletTest is Test {
    EtherWallet public ether_wallet;

    fallback() external payable {}

    function setUp() public {
        ether_wallet = new EtherWallet();
    }

    function _send(uint256 amount) public {
        (bool ok,) = address(ether_wallet).call{value: amount}("");
        require(ok, "send ETH Failue");
    }

    function testFail_withdraw_othercall() public {
        vm.prank(address(1));
        ether_wallet.withdraw(1);
    }

    function testFail_withdraw_notEnoughAmount() public {
        //first, send some value to wallet;
        _send(2);

        ether_wallet.withdraw(ether_wallet.getBalance() + 1);
    }

    function test_withdraw_enoughAmount() public {
        //first, send some value to wallet;
        _send(5);

        uint256 walletBalanceBefore = address(ether_wallet).balance;
        uint256 ownerBalanceBefore = address(this).balance;

        console2.log("walletBB",walletBalanceBefore);
        console2.log("ownerBB", ownerBalanceBefore);

        ether_wallet.withdraw(1);

        uint256 walletBalanceAfter = address(ether_wallet).balance;
        uint256 ownerBalanceAfter = address(this).balance;

        console2.log("walletBA",walletBalanceAfter);
        console2.log("ownerBA", ownerBalanceAfter);

        assertEq(walletBalanceAfter, walletBalanceBefore - 1);
        assertEq(ownerBalanceAfter, ownerBalanceBefore + 1);
    }
}