// SPDX-License-Identifier: UNLICENSE
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {AngelMatter} from "src/AngelMatter.sol";
import {Research} from "src/Research.sol";
import {Antigraviton} from "src/Antigraviton.sol";
import {ERC1155TokenReceiver} from "lib/solmate/src/tokens/ERC1155.sol";

contract AMTest is Test, ERC1155TokenReceiver {
    address constant ETHFS_MAINNET = 0x9746fD0A77829E12F8A9DBe70D7a322412325B91;
    uint256 constant PRICE = 0.0333 ether;
    uint256 constant COLLISION = 3333333;

    address owner = address(1);
    address notOwner = address(2);

    uint256 startTime;

    AngelMatter am;
    Research research;
    Antigraviton anti;

    function setUp() public {
        startTime = 1;
        am = new AngelMatter(ETHFS_MAINNET, owner, startTime);
        research = am.research();
        anti = am.anti();

        vm.deal(address(this), 1000 ether);
    }

    function xtestURI() public {
        am.mint{value: PRICE}(1);
        console2.log(am.tokenURI(1));
    }

    function testMint(uint256 amount) public {
        vm.assume(amount <= 3333 && amount > 0);
        am.mint{value: PRICE * amount}(amount);
        assert(am.balanceOf(address(this)) == amount);
    }

    function testMintAll() public {
        am.mint{value: PRICE * 3333}(3333);
        assert(am.balanceOf(address(this)) == 3333);
    }

    function testMintRevertTime(uint256 amount) public {
        vm.assume(amount <= 3333);
        vm.warp(startTime - 1);

        vm.expectRevert();
        am.mint{value: PRICE * amount}(amount);
    }

    function testMintRevertSupply(uint256 amount) public {
        vm.assume(amount <= 3333);
        am.mint{value: PRICE * amount}(amount);

        uint256 oneMore = 3333 - amount + 1;

        vm.expectRevert();
        am.mint{value: PRICE * oneMore}(oneMore);
    }

    function testMintRevertPrice(uint256 amount) public {
        vm.assume(amount <= 3333);

        vm.expectRevert();
        am.mint{value: PRICE * amount - 1}(amount);
    }

    function testWithdraw() public {
        testMintAll();
        uint256 prevBal = owner.balance;
        uint256 expectedBal = prevBal + (PRICE * 3333);
        vm.prank(owner);
        am.withdraw();
        uint256 postBal = owner.balance;
        assertEq(postBal, expectedBal);
    }

    function testWithdrawRevertNotOwner() public {
        testMintAll();
        vm.prank(notOwner);
        vm.expectRevert();
        am.withdraw();
    }

    function testVirtualBalance(uint256 warp) public {
        vm.assume(warp > startTime && warp < 32000000000);
        am.mint{value: PRICE}(1);
        vm.warp(warp);

        uint256 vb = am.virtualAnti(1);
        uint256 expected = (warp - startTime) * 1 ether;

        assertEq(vb, expected);
    }

    function testClaimAnti(uint256 warp) public {
        vm.assume(warp > startTime && warp < 32000000000);
        am.mint{value: PRICE}(1);
        vm.warp(warp);

        am.claimAnti(1);

        uint256 bal = anti.balanceOf(address(this));
        uint256 expected = (warp - startTime) * 1 ether;

        assertEq(bal, expected);
    }

    function testClaimAntiRevertNotOwner() public {
        am.mint{value: PRICE}(1);

        vm.prank(notOwner);
        vm.expectRevert();
        am.claimAnti(1);
    }

    function testClaimAntiAccounting(uint256 warp) public {
        vm.assume(warp < 32000000000);
        am.mint{value: PRICE}(1);
        vm.warp(startTime + warp);

        am.claimAnti(1);

        uint256 bal = anti.balanceOf(address(this));
        uint256 expected = warp * 1 ether;

        assertEq(bal, expected);

        vm.warp(startTime + (warp * 2));

        bal = anti.balanceOf(address(this));
        uint256 vb = am.virtualAnti(1);

        assertEq(bal, vb);
        assertEq(vb, am.claimed(1));

        am.claimAnti(1);

        expected = warp * 2 ether;

        assertEq(bal * 2, expected);
    }

    function testCollisionVB() public {
        am.mint{value: PRICE}(1);
        vm.warp(startTime + COLLISION);
        am.collide(1, "TEST");

        uint256 bal = anti.balanceOf(address(this));
        uint256 vb = am.virtualAnti(1);
        assertEq(bal, 0);
        assertEq(vb, 0);

        assertEq(research.balanceOf(address(this), 1), 1);
    }

    function testCollisionCB() public {
        am.mint{value: PRICE}(1);
        vm.warp(startTime + COLLISION);
        am.claimAnti(1);
        am.collide(1, "TEST");

        uint256 bal = anti.balanceOf(address(this));
        uint256 vb = am.virtualAnti(1);
        assertEq(bal, 0);
        assertEq(vb, 0);

        assertEq(research.balanceOf(address(this), 1), 1);
    }

    function testCollisionMix() public {
        am.mint{value: PRICE}(1);
        vm.warp(startTime + COLLISION - 1000000);
        am.claimAnti(1);
        vm.warp(startTime + COLLISION);

        uint256 bal = anti.balanceOf(address(this));
        uint256 vb = am.virtualAnti(1);

        assertEq(bal, 2333333 ether);
        assertEq(vb, 1000000 ether);

        am.collide(1, "TEST");

        bal = anti.balanceOf(address(this));
        vb = am.virtualAnti(1);
        assertEq(bal, 0);
        assertEq(vb, 0);

        assertEq(research.balanceOf(address(this), 1), 1);
    }

    function testCollisionRevertBalance() public {
        am.mint{value: PRICE}(1);
        vm.warp(startTime + COLLISION - 1);

        vm.expectRevert();
        am.collide(1, "TEST");
    }

    function testCollisionRevertNotOwner() public {
        am.mint{value: PRICE}(1);
        vm.warp(startTime + COLLISION);

        vm.prank(notOwner);
        vm.expectRevert();
        am.collide(1, "TEST");
    }

    function testCollisionStep() public {
        am.mint{value: PRICE}(1);
        vm.warp(startTime + COLLISION * 2);
        am.collide(1, "TEST");
        am.collide(1, "TEST");

        assertEq(research.balanceOf(address(this), 1), 1);
        assertEq(research.balanceOf(address(this), 2), 1);
    }

    function testObserve() public {
        am.mint{value: PRICE}(1);
        uint256[][] memory arr = _fillArr(true);
        am.observe(1, arr);

        string memory actual = am.prism(1);
        string
            memory expected = "[[0,1,2,3,4],[1,2,3,4,5],[1,2,3,4,5],[1,2,3,4,5],[1,2,3,4,5]]";

        assertEq(
            keccak256(abi.encode(actual)),
            keccak256(abi.encode(expected))
        );
    }

    function testObserveRevertBadNumber() public {
        am.mint{value: PRICE}(1);
        uint256[][] memory arr = _fillArr(true);
        arr[0][0] = 6;
        vm.expectRevert();
        am.observe(1, arr);
    }

    function testObserveRevertBadLength() public {
        am.mint{value: PRICE}(1);

        uint256[] memory arr1 = new uint256[](2);
        uint256[] memory arr2 = new uint256[](2);
        uint256[][] memory arr = new uint256[][](2);
        arr[0] = arr1;
        arr[1] = arr2;

        vm.expectRevert();
        am.observe(1, arr);
    }

    function testInvert() public {
        am.mint{value: PRICE}(1);
        uint8 pre = am.spin(1);
        am.invert(1);
        uint8 post = am.spin(1);

        if (pre > 0) {
            assertEq(post, 0);
        } else {
            assertEq(post, 1);
        }
    }

    function testInvertRevertNotOwner() public {
        am.mint{value: PRICE}(1);
        vm.prank(notOwner);
        vm.expectRevert();
        am.invert(1);
    }

    function testLevel(uint256 amount) public {
        vm.assume(amount < 101);
        am.mint{value: PRICE}(1);
        _boofTransfer(amount);

        assertEq(am.level(1), amount);
    }

    function testMaxLevel() public {
        am.mint{value: PRICE}(1);
        _boofTransfer(101);

        assertEq(am.level(1), 100);
    }

    function testRedacted() public {
        am.mint{value: PRICE}(1);
        am.observe(1, _fillArr(false));
        _boofTransfer(100);
        vm.warp(startTime + 5169601);

        am.xe(1);
        assertEq(am.redacted(1), 1);

        vm.expectRevert();
        am.xe(1);

        am.collide(1, "TEST");
        assertEq(research.balanceOf(address(this), 0), 1);
        assertEq(research.balanceOf(address(this), 1), 1);
        assertEq(am.redacted(1), 0);
    }

    function testRedactedRevertTime() public {
        am.mint{value: PRICE}(1);
        am.observe(1, _fillArr(false));
        _boofTransfer(100);

        vm.warp(startTime + 5169599);
        vm.expectRevert();
        am.xe(1);

        vm.warp(startTime + 5256000);
        vm.expectRevert();
        am.xe(1);
    }

    function testRedactedRevertArr() public {
        am.mint{value: PRICE}(1);
        am.observe(1, _fillArr(true));
        _boofTransfer(100);
        vm.warp(startTime + 5169601);

        vm.expectRevert();
        am.xe(1);
    }

    function testRedactedRevertLevel() public {
        am.mint{value: PRICE}(1);
        am.observe(1, _fillArr(false));
        _boofTransfer(99);
        vm.warp(startTime + 5169601);

        vm.expectRevert();
        am.xe(1);
    }

    function _fillArr(
        bool fill
    ) internal pure returns (uint256[][] memory arr) {
        uint256[] memory arr1 = new uint256[](5);
        uint256[] memory arr2 = new uint256[](5);
        uint256[] memory arr3 = new uint256[](5);
        uint256[] memory arr4 = new uint256[](5);
        uint256[] memory arr5 = new uint256[](5);

        if (fill) {
            for (uint256 i; i < 5; i++) {
                arr1[i] = i;
                arr2[i] = i + 1;
                arr3[i] = i + 1;
                arr4[i] = i + 1;
                arr5[i] = i + 1;
            }
        }

        arr = new uint256[][](5);
        arr[0] = arr1;
        arr[1] = arr2;
        arr[2] = arr3;
        arr[3] = arr4;
        arr[4] = arr5;
    }

    function _boofTransfer(uint256 amount) internal {
        address boof = address(69);
        for (uint256 i; i < amount; i++) {
            if (am.ownerOf(1) == address(this)) {
                am.transferFrom(address(this), boof, 1);
            } else {
                vm.prank(boof);
                am.transferFrom(boof, address(this), 1);
            }
        }
    }
}
