// SPDX-License-Identifier: T
/*

░██████╗░███╗░░██╗░█████╗░███╗░░░███╗███████╗██╗░░░░░░█████╗░███╗░░██╗██████╗░
██╔════╝░████╗░██║██╔══██╗████╗░████║██╔════╝██║░░░░░██╔══██╗████╗░██║██╔══██╗
██║░░██╗░██╔██╗██║██║░░██║██╔████╔██║█████╗░░██║░░░░░███████║██╔██╗██║██║░░██║
██║░░╚██╗██║╚████║██║░░██║██║╚██╔╝██║██╔══╝░░██║░░░░░██╔══██║██║╚████║██║░░██║
╚██████╔╝██║░╚███║╚█████╔╝██║░╚═╝░██║███████╗███████╗██║░░██║██║░╚███║██████╔╝
░╚═════╝░╚═╝░░╚══╝░╚════╝░╚═╝░░░░░╚═╝╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░

                                   ╓╓╓▄▄▄▓▓█▓▓▓▓▀▀▀▀▀▀▓█
                             ╓▄██▀╙╙░░░░░░░░░░░░░░░░╠╬║█
                        ╓▄▓▀╙░░░░░░░░░░░░░░░░░░░░░░╠╠╠║▌
                     ╓█╩░░░░░░░░░░░░░░░░░░░░░░░░░░╠╠╠╠║▌
                   ▄█▒░░░░░░░░░░░░░▒▄██████▄▄░░░░░╠╠╠╠║▌
                 ╓██▀▀▀╙╙╚▀░░░░░▄██╩░░░░░░░░╙▀█▄▒░╠╠╠╠╬█
              ╓▓▀╙░░░░░░░░░░░░░╚╩░░░░░░░░░░░░░░╙▀█╠╠╠╠╬▓
             ▄╩░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╠╠╠╠╠║▌
            ║██▓▓▓▓▓▄▄▒░░░░░░░░░░░▄▄██▓█▄▄▒░░░░░░░╠╠╠╠╠╬█
           ╔▀         ╙▀▀█▓▄▄▄██▀╙       └╙▀█▄▒░░░╠╠╠╠╠╠║▌
          ║█▀▀╙╙╙▀▀▓▄╖       ▄▄▓▓▓▓╗▄▄╓      ╙╙█▄▒░╠╠╠╠╠╬█
        ╓▀   ╓╓╓╓╓╓   ╙█▄ ▄▀╙          ╙▀▓▄      ╙▀▓▒▒╠╠╠║▌
        ▐██████████╙╙▀█▄ ╙█▄▓████████▀▀╗▄           █▀███╬█
        █║██████▌ ██    ╙██╓███████╙▀█   └▀╗╓       ║▒   ╙╙▓
       ╒▌╫███████╦╫█     ║ ╫███████╓▄█▌     └█╕     ║▌    ▀█▀▀
        █╚██████████    ╓╣ ║██████████▒    ╔▀╙      ║▒     └█
       ┌╣█╣████████╓╓▄▓▓▒▄█▄║████████▌╓╗╗▀╙        ╓█        ╚▄
       │█▄╗▀▀╙      ╙▀╙         ╙▀▀██▒            ▄█          ╙▄
     █▒                               ╙▀▀▀▀╠█▌╓▄▓▀             ║
      ╙█╓           ╓╓                   ╓██╩║▌                ║
       ╓╣███▄▄▄▄▓██╬╬╠╬███▄▄▄▄╓╓╓╓╓▄▄▄▓█╬╬▒░░╠█             ╔ ┌█
      ╓▌  ▀█╬╬▒╠╠╠╠░▒░░░╠╠╠╚╚╚╩╠╠╠╠╬███▀╩░░░▄█        ▓      █▀
     ╒▌   ╘█░╚╚╚╚╚▀▀▀▀▀▀▀▀▀▀▀▀▀▀╚╚╚░░░░░░▄█▀╙         ║      ▐▌
     ╟     └▀█▄▒▒▒░░░░░░░░░░░▒▒▒▒▒▄▄█▓╝▀╙                    ▐▌
     ║░        ╙╙▀▀▀▀▀▀▀▀▀▀▀▀▀▀╙╙                        ╓   █
      █                                                  ▓ ╓█
      ║▌   ╔                                            ╔█▀
       █   ╚▄                              ╓╩          ╔▀
       ╚▌   ╙                             ▓▀         ╓█╙
        ╙▌          ▐                  ╓═    ▄    ╓▄▀╙
          ▀▄        ╙▒                      ▄██▄█▀
            ╙▀▄╓║▄   └                    ▄╩
                ╙▀█                   ╓▄▀▀
                   ▀▓        ▄▄▓▀▀▀▀╙
                     └▀╗▄╓▄▀╙
    
GnomeLand GNOME  
https://www.gnomeland.money/
https://twitter.com/Gnome0xLand



*/
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IGnomeURI {
    function tokenURI(uint256 id) external view returns (string memory);
}

contract Gnomes is ERC721 {
    IGnomeURI public gnomeURI;

    mapping(uint256 => uint256) public levels;
    mapping(uint256 => string) public levelURI;
    mapping(address => bool) public isAuth;
    mapping(uint256 => bool) public isDed;
    mapping(address => uint256) public gnomeTokenId;
    mapping(uint256 => address) public tokenIdGnome;
    mapping(uint256 => string) public gnomeX_usr;
    mapping(uint256 => uint256) public xp; //Experience Points
    mapping(uint256 => uint256) public hp; //Health Points
    mapping(address => uint256) public lastAtackTimeStamp;
    uint256 public _tokenIdCounter = 0;
    uint256 public totalSupplyOnChain = 0;
    uint256 public maxSupply = 1111;
    address public owner;

    constructor() ERC721("GnomeLand", "Gnomes") {
        owner = msg.sender;
    }

    // Modifier to restrict access to owner only
    modifier onlyAuth() {
        require(msg.sender == owner || isAuth[msg.sender], "Caller is not the authorized");
        _;
    }

    function setIsAuth(address gnome, bool isAuthorized) external onlyAuth {
        isAuth[gnome] = isAuthorized;
    }

    function mint(address gnome) public onlyAuth returns (uint256) {
        require(maxSupply > _tokenIdCounter, "Max mint Reached");
        uint256 newTokenId = _tokenIdCounter;

        _mint(gnome, newTokenId);
        levels[newTokenId] = 0; // Start at level 0
        xp[newTokenId] = 0;
        hp[newTokenId] = 100;
        gnomeTokenId[gnome] = newTokenId;
        tokenIdGnome[newTokenId] = gnome;
        _tokenIdCounter++;
        totalSupplyOnChain++;
        return newTokenId;
    }

    function SummonDedGnome(address gnome, uint256 _tokenId) public onlyAuth returns (uint256) {
        require(isDed[_tokenId], "gnome not ded");
        _mint(gnome, _tokenId);
        hp[_tokenId] = 100;
        gnomeTokenId[gnome] = _tokenId;

        totalSupplyOnChain++;
        return _tokenId;
    }

    function bridgeGnome(address gnome, uint256 _tokenId) public onlyAuth returns (uint256) {
        _mint(gnome, _tokenId);
        hp[_tokenId] = 100;
        gnomeTokenId[gnome] = _tokenId;
        _tokenIdCounter++;
        totalSupplyOnChain++;
        return _tokenId;
    }

    function setXP(uint256 tokenId, uint256 _XP) public onlyAuth {
        xp[tokenId] = _XP;
    }

    function setHP(uint256 tokenId, uint256 _HP) public onlyAuth {
        hp[tokenId] = _HP;
        if (_HP <= 0) _burn(tokenId);
    }

    function levelUp(uint256 tokenId) public onlyAuth {
        levels[tokenId]++;
    }

    function levelDown(uint256 tokenId) public onlyAuth {
        levels[tokenId]--;
    }

    function setLevel(uint256 tokenId, uint256 level) public onlyAuth {
        levels[tokenId] = level;
    }

    function setLevelURI(uint256 level, string memory svgString) public onlyAuth {
        levelURI[level] = svgString;
    }

    function setTimeStamp(address gnome, uint256 _lastAtackTimeStamp) public onlyAuth {
        lastAtackTimeStamp[gnome] = _lastAtackTimeStamp;
    }

    function getURIForLevel(uint256 level) public view returns (string memory) {
        return levelURI[level];
    }

    function getAttackTimeStamp(address gnome) public view returns (uint256) {
        return lastAtackTimeStamp[gnome];
    }

    function getXP(uint256 tokenId) public view returns (uint256) {
        return xp[tokenId];
    }

    function getHP(uint256 tokenId) public view returns (uint256) {
        return hp[tokenId];
    }

    function getLevels(uint256 tokenId) public view returns (uint256) {
        return levels[tokenId];
    }

    function getTokenId() public view returns (uint256) {
        return _tokenIdCounter;
    }

    function getGnomeId(address _gnome) public view returns (uint256) {
        return gnomeTokenId[_gnome];
    }

    function getIdGnome(uint256 _id) public view returns (address) {
        return tokenIdGnome[_id];
    }

    function signUp(uint256 _id, string memory _Xusr) public returns (address) {
        require(ownerOf(_id) == msg.sender, "Not Auth");
        gnomeTokenId[ownerOf(_id)] = _id;
        tokenIdGnome[_id] = msg.sender;
        gnomeX_usr[_id] = _Xusr;

        return tokenIdGnome[_id];
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return gnomeURI.tokenURI(id);
    }

    function totalSupply() public view returns (uint256) {
        return totalSupplyOnChain;
    }

    function burnGnome(uint256 _id) external onlyAuth {
        _burn(_id);
        totalSupplyOnChain--;
        isDed[_id] = true;
        delete gnomeTokenId[ownerOf(_id)];
        delete tokenIdGnome[_id];
    }

    // Helper function to convert uint256 to string
    function toString(uint256 value) internal pure returns (string memory) {
        // Convert a uint256 to a string
        // Implementation otted for brevity
    }

    function setGnomeUri(IGnomeURI _renderer) external onlyAuth {
        gnomeURI = _renderer;
    }
}
