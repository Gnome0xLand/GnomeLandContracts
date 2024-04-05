
# GnomeLand Contracts

GnomeLand is a MultiChain indie game leveraging Layer0 cross-chain messaging and the gamification of  Concentrated Liquidity management.




## Demo

Insert gif or link to demo

## Contracts

| Contracts | ETH/ARB/BASE Sepolia| 
| ------------- | ------------- 
| GnomeERC20  | 0x369517bc8ed5Ff2De105692791a05955992A529a |
| GnomeSJ741  | 0xcEF49967c42734bd7c1C13c9744838161F4268b9|
|GnomeFactory|0xA1C25486F90501a5AD8A3FE792E9b48C9814Bd2D|
|GnomeGamePlay|0xc494e91E327322421dF7391E61f5C5D48AFEeb66|
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

