// SPDX-License-Identifier: GPL-3.0
// LockModule#Lock - 0x5FbDB2315678afecb367f032d93F642f64180aa3
pragma solidity >=0.8.2 <0.9.0;

contract Lock {

    struct Access {
        address user;
        bool access;

    }

    mapping(address =>string[]) values;
    mapping(address =>mapping (address=>bool)) ownerships;
    mapping(address => Access[]) accessList;
    mapping(address => mapping (address => bool)) previousData;
   

    function add (address _user, string memory _url) public  {
        values[_user].push(_url);
    }

    function allow (address _user) public  {
        ownerships[msg.sender][_user] = true;
        if(previousData[msg.sender][_user]){
            for (uint i=0; i<accessList[msg.sender].length; ++i){
                if ( accessList[msg.sender][i].user == _user) {
                        accessList[msg.sender][i].access = true;
                } 
            }
        }
        else{
            accessList[msg.sender].push(Access(_user,true));
            previousData[msg.sender][_user] = true;
        }
    }


    function disallow(address _user) public {
        ownerships[msg.sender][_user] = false;
        for (uint i=0; i<accessList[msg.sender].length; ++i){
            if ( accessList[msg.sender][i].user == _user) {
               accessList[msg.sender][i].access=false;
            } 
        }
    }   

    function display(address _user) external  view returns (string[] memory){
        require(_user == msg.sender || ownerships[_user][msg.sender],"You have not access to view");
        return  values[_user];
    }


    function shareAccess() public view  returns(Access[] memory){
        return accessList[msg.sender];
    }


}