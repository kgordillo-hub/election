# Smart contract para auditoría de obras civiles
Aplicacion de interaccion con smart contract para votar por las obras civiles realizadas en un determinado lugar. 
Cuando se cumple un mínimo votos se transfiere al wallet del contratista el dinero pactado, de lo contrario no.

## Despliegue en Ganache

truffle migrate --reset

## Despliegue en Ropsten

truffle deploy --reset --network ropsten

## Correr aplicación

npm run dev

## Build With

* [Truffle](https://www.trufflesuite.com/) - Framework para smart contracts
* [Ganache](https://www.trufflesuite.com/ganache) - para montar nodo local de Blockchain
* [W3](https://github.com/ethereum/wiki/wiki/JavaScript-API#web3js-api-reference) - Librería para interacción web con smart contract
* [NodeJs](https://nodejs.org/es/) - Node js para correr la aplicación web

## Basados en

* [Dapp university](http://www.dappuniversity.com/articles/the-ultimate-ethereum-dapp-tutorial) - se usó como guía el tutorial indicado.

## License

This project is licensed under the The MIT License (MIT)
