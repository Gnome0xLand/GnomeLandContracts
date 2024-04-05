
# GnomeLand Contracts

GnomeLand is a MultiChain indie game leveraging Layer0 cross-chain messaging and the gamification of  Concentrated Liquidity management.



## Contracts

| Contracts | Sepolia| 
| ------------- | ------------- 
| GnomeERC20  | 0x5e876B83Fd89d1a88FF69CeE8C5B173f73E82Ba5 |
| GnomeSJ741  | 0x6DE1d360A3DdD076555ac7f4307fA98EA0C541a9|
|GnomeFactory|0x7fCDc3303614b7aAEdd30167B8D2146B7Cd36e04|
|GnomeGamePlay|0xa7c7F741212aa3C9260F3F3e8Dc6e5969374DEEb|
|GnomeActions|0xd877d694f02CE9B7b43838c708d38e09097ad0ed|
|GnomeHook|---NOT DEPLOYED---|

## Main Functions

To interact with our game contracts you first need to either mint a Gnome on the GnomeFactory or SignUp a tokenId aquired from the UniV3 pool

```solidity
function mintGnome(userX,baseEmotion)
function mintGnomeReferral(code,userX,baseEmotion)
function boopGnome(boopedTokenId)
function gnomeAction(activity) 
```
    
## 🔗 Links

[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/)
