# Progetto Smartcontract con Solidity - Information
<a name="readme-top"></a>

## Introduzione
Questo progetto implementa una piattaforma decentralizzata per la gestione e la verifica delle notizie tramite smart contract su blockchain. 
Utilizza due contratti: NewsManager.sol e NewsManagerLib.sol, distribuiti su una rete di test Ethereum.

## Sommario
- [Vantaggi della piattaforma](#vantaggi-della-piattaforma)
- [Funzionalità principali](#funzionalità-principali)
- [Installazione](#installazione)
  - [Prerequisiti](#prerequisiti)
  - [Link utili](#link-utili)
  - [Web3.js](#web3js)
  - [Ether.js](#ethersjs)
- [Deploy su blockchain](#deploy-su-blockchain)
- [Repository GitHub](#repository-github)
- [Indirizzi Contratto](#indirizzi-contratto)
- [Contatti](#contatti)


## Vantaggi della piattaforma
Grazie agli smart contracts garantiamo trasparenza, sicurezza e incentivazione dei validatori per confermare l'affidabilità delle informazioni.
Le operazioni sono automatizzate e tracciate, riducendo il rischio di manipolazioni e frodi, offrendo un sistema affidabile per la distribuzione e verifica delle notizie in maniera decentralizzata. Ideale per aziende che gestiscono contenuti sensibili, il sistema incentiva la qualità e la fiducia nell'informazione.

## Funzionalità principali
La piattaforma offre funzionalità avanzate per la gestione delle notizie e dei validatori. 
Gli amministratori possono aggiungere nuove notizie con parametri specifici come il nome, la data di scadenza e il numero minimo di validazioni richieste. 
Inoltre, possono gestire i validatori, aggiungendo nuovi membri, impostando ricompense e rimuovendo quelli non più necessari. 
Il sistema permette di monitorare lo stato delle notizie, verificando se sono state validate o se sono ancora in attesa di conferma.

## Installazione

Qui di seguito i passaggi per configurare e avviare il progetto localmente come:
1. Download del repository.
2. Installazione delle dipendenze.
3. Configurazione.

## Prerequisiti

Per interagire con il contratto assicurati di avere Node.js e npm installati.
Web3.js e Ether.js sono due dei principali strumenti per interagire con Ethereum tramite Javascript, installabili tramite npm.

## Link utili

- **Node.js**  
  Installato dalla pagina ufficiale [Node.js](https://nodejs.org)
- **NPM**  
  Incluso con l'installazione di Node.js
- **Metamask**  
  Estensione del browser [Metamask](https://metamask.io/)
- **Web3.js**  
  Libreria Web3 installata tramite `npm install web3`
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Installazione delle dipendenze
### Web3.js

Installa `web3.js` utilizzando npm:
```bash
npm install web3
```

### Configurazione con index.js

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
### Ethers.js
In alternativa a Web3.js, puoi utilizzare Ethers.js per interagire con gli smart contract:
```bash
npm install ethers
```
### Configurazione con Ethers.js
Crea un file `index.js` con il seguente codice per configurare l'accesso al tuo contratto su blockchain:
```bash
const { ethers } = require('ethers');
const provider = new ethers.JsonRpcProvider('https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID');

const newsManagerAddress = '0x...'; // Inserisci l'indirizzo del contratto NewsManager
const newsManagerABI = [/* ABI del contratto NewsManager */];

const newsManager = new ethers.Contract(newsManagerAddress, newsManagerABI, provider);

async function getNewsDetails(newsAddress) {
    try {
        const details = await newsManager.getNewsDetails(newsAddress);
        console.log(details);
    } catch (error) {
        console.error('Errore:', error);
    }
}

getNewsDetails('0x...'); // Inserisci l'indirizzo della notizia //
```


### Esecuzione del codice
Per eseguire il codice ed interagire con lo Smart Contract, utilizza il seguente comando:
```bash
node index.js
```
Questo script eseguirà la funzione per ottenere i dettagli di una specifica notizia sulla blockchain e stamperà le informazioni nella console.

Tutte le operazioni che richiedono una modifica dello stato del contratto (come l'aggiunta di validatori o l'invio di notizie) richiederanno la firma della transazione da parte di Metamask o un altro wallet compatibile. Verranno generati i dettagli della transazione, inclusi i costi di gas.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Deploy su blockchain
Per distribuire il contratto su una rete blockchain, segui questi passaggi:
```bash
1. Apri Remix IDE e carica i tuoi file `.sol`.
2. Seleziona `Injected Web3` e collega Metamask.
3. Compila e distribuisci il contratto su una rete di test come Sepolia.
4. Verifica la transazione e il contratto su Etherscan (https://etherscan.io).
```



## Repository GitHub

- Repo GitHub: https://github.com/StefanoRimoldi/Smartcontract-con-Solidity-Start2Impact.git
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Indirizzi Contratto
Indirizzi del contratto e della libreria pubblicati su rete di test Sepolia

NewsManager.sol
0x01f48A31ED374Fc2563BB68fC2916D40cead6A08

NewsManagerLib.sol
0xf0a27cac62C38d96807769B4C76a614080Ce1C87

## Contatti
- Email: rimoldistefano@gmail.com
- Linkedin: www.linkedin.com/in/stefano-rimoldi

<p align="right">(<a href="#readme-top">back to top</a>)</p>





