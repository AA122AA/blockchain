// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.11;

contract User {
    struct DrivingLicence {
        string number;
        uint256 validity;
        string category;
    }

    struct User_str {
        address userAddr;
        string FIO;
        DrivingLicence dl;
        uint256 startDrive;
        uint256 accidentAmount;
        uint256 notPayedFinesAmount;
        uint256 insuranceFee;
        uint256 balance;
        bool isDPS;
    }

    struct Car_str {
        string category;
        uint256 price;
        uint256 age;
    }

    User_str[] usersArr;

    mapping(address => uint256) userIndexMap;
    mapping(address => Car_str[]) usersCars;
    mapping(string => DrivingLicence) drivingLicencePool;

    uint256 usersCount = 0;
    uint256 date;

    // ["000",2,"C"],["111",5,"B"],["222",8,"D"],["333",9,"C"],["444",3,"B"],["555",7,"E"],["666",2,"B"] - так передаются таплы
    constructor(
        DrivingLicence memory _dl0,
        DrivingLicence memory _dl1,
        DrivingLicence memory _dl2,
        DrivingLicence memory _dl3,
        DrivingLicence memory _dl4,
        DrivingLicence memory _dl5,
        DrivingLicence memory _dl6
    ) {
        drivingLicencePool[_dl0.number] = _dl0;
        drivingLicencePool[_dl1.number] = _dl1;
        drivingLicencePool[_dl2.number] = _dl2;
        drivingLicencePool[_dl3.number] = _dl3;
        drivingLicencePool[_dl4.number] = _dl4;
        drivingLicencePool[_dl5.number] = _dl5;
        drivingLicencePool[_dl6.number] = _dl6;
        date = block.timestamp;
    }

    modifier dlCheck(
        string memory _number,
        uint256 _validity,
        string memory _category
    ) {
        require(
            drivingLicencePool[_number].validity == _validity,
            "wrong validity"
        );
        require(
            keccak256(bytes(drivingLicencePool[_number].category)) ==
                keccak256(bytes(_category)),
            "wrong category"
        );
        _;
    }

    function createUser(
        string memory _FIO,
        uint256 _startDrive,
        uint256 _accidentAmount,
        uint256 _notPayedFinesAmount,
        uint256 _insuranceFee,
        uint256 _balance,
        bool _isDPS
    ) public {
        User_str memory _user = User_str(
            msg.sender,
            _FIO,
            DrivingLicence("0", 0, "0"),
            _startDrive,
            _accidentAmount,
            _notPayedFinesAmount,
            _insuranceFee,
            _balance,
            _isDPS
        );
        usersArr.push(_user);
        userIndexMap[msg.sender] = usersCount;
        usersCount += 1;
    }

    function createUser(
        User_str memory _user // ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "00", ["000", 2, "C"], 5, 0, 0, 6, 4, true] - такое надо передавать чтоб создавать юзера. 
    ) public dlCheck(_user.dl.number, _user.dl.validity, _user.dl.category) {
        usersArr.push(_user);
        userIndexMap[msg.sender] = usersCount;
        usersCount += 1;
    }

    function setDrivingLicence(
        string memory _number,
        uint256 _validity,
        string memory _category
    ) public dlCheck(_number, _validity, _category) {
        DrivingLicence memory _dl = DrivingLicence(
            _number,
            _validity,
            _category
        );
        uint256 index = userIndexMap[msg.sender];
        usersArr[index].dl = _dl;
    }

    function registerCar(
        string memory _carCategory,
        uint256 _price,
        uint256 _age
    ) public {
        require(
            keccak256(bytes(usersArr[userIndexMap[msg.sender]].dl.category)) ==
                keccak256(bytes(_carCategory)),
            "wrong category"
        );
        usersCars[msg.sender].push(Car_str(_carCategory, _price, _age));
    }

    function dlProlongation(type name) {
        require(date >= start + daysAfter * 1 days) // Надо номрльные даты для прав придумать + понять на сколько проделваются права + проверять по условию ТЗ
    }
}
