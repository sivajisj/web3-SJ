// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;

contract SimpleStorage {

      uint256 myFavouriteNumber;

      struct Person{
        uint256 favouriteNumber;
        string name;
       
      }

      Person public sivaji = Person(23,"sid");

      Person[] public listOfPeople;

      mapping(string => uint256) public nameToFavouriteNume;
    //   listOfPeople[0] = ;
    function store(uint256 _favouriteNumber) public {
        myFavouriteNumber = _favouriteNumber;
    }

    function retrive() public  view returns(uint256){
        return myFavouriteNumber;
    }

    function addPerson(string memory _name, uint256 _favouriteNumber)public {
       Person memory newPerson = Person(_favouriteNumber,_name);
       listOfPeople.push(newPerson); 
       nameToFavouriteNume[_name] = _favouriteNumber;
    }
}
