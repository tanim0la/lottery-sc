    // SPDX-License-Identifier: MIT
     
    pragma solidity ^0.8.9;
     
    contract Lottery {
        address public manager;
        address public winner;
        address payable[] public players;
        
        constructor() {
            manager = msg.sender;
        }
        
        function enter() public payable {
            require(msg.value > .01 ether);
            players.push(payable(msg.sender));
        }
        
        function random() private view returns (uint) {
            return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
        }
        
        function pickWinner() public restricted {
            uint index = random() % players.length;
            winner = players[index];
            players[index].transfer(address(this).balance);
            players = new address payable[](0);
        }

        function getWinner() public view returns (address) {
            return winner;
        }
        
        modifier restricted() {
            require(msg.sender == manager);
            _;
        }
        
        function getPlayers() public view returns (address payable[] memory) {
            return players;
        }
    }   