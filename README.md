# Progetto Smartcontract con Soldity - Information
<a name="readme-top"></a>

## Introduzione
Questo progetto implementa una piattaforma decentralizzata per la gestione e la verifica delle notizie tramite smart contract su blockchain. 
Utilizza due contratti: NewsManager.sol e NewsManagerLib.sol, distribuiti su una rete di test Ethereum.

## Sommario


- [Prerequisiti](#prerequisiti)
- [Repository GitHub](#repository-github)
- [Licenza](#licenza)
- [Contatti](#contatti)

## Prerequisiti

Per interagire con il contratto assicurati di avere Node.js e npm installati.
Web3.js e Ether.js sono due dei principali strumenti per interagire con Ethereum tramite Javascript, installabili tramite npm.

### Web3.js

Installa `web3.js` utilizzando npm:
```bash
npm install web3
```

### Configurazione

Crea un file `index.js` con il seguente codice per configurare l'accesso al tuo contratto su blockchain:

```javascript
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider('https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID'));

const newsManagerAddress = '0x...'; // Inserisci l'indirizzo del contratto NewsManager

const newsManagerABI = [/* ABI del contratto NewsManager */];

const newsManager = new web3.eth.Contract(newsManagerABI, newsManagerAddress);

async function getNewsDetails(newsAddress) {
    const details = await newsManager.methods.getNewsDetails(newsAddress).call();
    console.log(details);
}

getNewsDetails('0x...'); // Inserisci l'indirizzo della notizia
```

### Esecuzione del codice
Per eseguire il codice ed interagire con lo Smart Contract, utilizza il seguente comando:
```bash
node index.js
```
Questo script eseguirà la funzione per ottenere i dettagli di una specifica notizia sulla blockchain e stamperà le informazioni nella console.

Tutte le operazioni che richiedono una modifica dello stato del contratto (come l'aggiunta di validatori o l'invio di notizie) richiederanno la firma della transazione da parte di Metamask o un altro wallet compatibile. Verranno generati i dettagli della transazione, inclusi i costi di gas.

## Repository GitHub

- Repo GitHub: https://github.com/StefanoRimoldi/Progetto-Javascript-Basics
<p align="right">(<a href="#readme-top">back to top</a>)</p>





