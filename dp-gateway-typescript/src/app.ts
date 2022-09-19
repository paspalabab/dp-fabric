/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

import assert from "assert";
import * as grpc from '@grpc/grpc-js';
import { connect, Contract, Identity, Signer, signers } from '@hyperledger/fabric-gateway';
import * as crypto from 'crypto';
import { promises as fs } from 'fs';
import * as path from 'path';
import { TextDecoder } from 'util';

const channelName = envOrDefault('CHANNEL_NAME', 'mychannel');
const chaincodeName = envOrDefault('CHAINCODE_NAME', 'basic');

let mspId: string;
// Path to crypto materials.
let cryptoPath: string;
// Path to user private key directory.
let keyDirectoryPath: string;
// Path to user certificate.
let certPath: string;
// Path to peer tls certificate.
let tlsCertPath: string;
// Gateway peer endpoint.
let peerEndpoint: string;
// Gateway peer SSL host name override.
let peerHostAlias: string;

function setGlobalOrg1(): void {
    mspId = envOrDefault('MSP_ID', 'Org1MSP');

    // Path to crypto materials.
    cryptoPath = envOrDefault('CRYPTO_PATH', path.resolve(__dirname, '..', '..','host1', 'org1', 'organizations', 'peerOrganizations', 'org1.example.com'));

    // Path to user private key directory.
    keyDirectoryPath = envOrDefault('KEY_DIRECTORY_PATH', path.resolve(cryptoPath, 'users', 'User1@org1.example.com', 'msp', 'keystore'));

    // Path to user certificate.
    certPath = envOrDefault('CERT_PATH', path.resolve(cryptoPath, 'users', 'User1@org1.example.com', 'msp', 'signcerts', 'cert.pem'));

    // Path to peer tls certificate.
    tlsCertPath = envOrDefault('TLS_CERT_PATH', path.resolve(cryptoPath, 'peers', 'peer0.org1.example.com', 'tls', 'ca.crt'));

    // Gateway peer endpoint.
    peerEndpoint = envOrDefault('PEER_ENDPOINT', 'localhost:8501');

    // Gateway peer SSL host name override.
    peerHostAlias = envOrDefault('PEER_HOST_ALIAS', 'peer0.org1.example.com');

}

function setGlobalOrg2(): void {
    mspId = envOrDefault('MSP_ID', 'Org2MSP');

    // Path to crypto materials.
    cryptoPath = envOrDefault('CRYPTO_PATH', path.resolve(__dirname, '..', '..','host2', 'org2', 'organizations', 'peerOrganizations', 'org2.example.com'));

    // Path to user private key directory.
    keyDirectoryPath = envOrDefault('KEY_DIRECTORY_PATH', path.resolve(cryptoPath, 'users', 'User1@org2.example.com', 'msp', 'keystore'));

    // Path to user certificate.
    certPath = envOrDefault('CERT_PATH', path.resolve(cryptoPath, 'users', 'User1@org2.example.com', 'msp', 'signcerts', 'cert.pem'));

    // Path to peer tls certificate.
    tlsCertPath = envOrDefault('TLS_CERT_PATH', path.resolve(cryptoPath, 'peers', 'peer0.org2.example.com', 'tls', 'ca.crt'));

    // Gateway peer endpoint.
    peerEndpoint = envOrDefault('PEER_ENDPOINT', 'localhost:8511');

    // Gateway peer SSL host name override.
    peerHostAlias = envOrDefault('PEER_HOST_ALIAS', 'peer0.org2.example.com');
}

const utf8Decoder = new TextDecoder();
const assetId = `asset${Date.now()}`;

describe('dp planet tests...', () => {
    let contract: any;

    const tokenid1 = 'token1-' + Math.random().toString(16).substr(2, 14);
    const tokenid2 = 'token2-' + Math.random().toString(16).substr(2, 14);
    const tokenid3 = 'token3-' + Math.random().toString(16).substr(2, 14);
    const tokenid4 = 'token4-' + Math.random().toString(16).substr(2, 14);
    const tokenid5 = 'token5-' + Math.random().toString(16).substr(2, 14);
    const tokenid6 = 'token6-' + Math.random().toString(16).substr(2, 14);

    const user1 = 'user1-' + Math.random().toString(16).substr(2, 14);
    const user2 = 'user2-' + Math.random().toString(16).substr(2, 14);
    const user3 = 'user3-' + Math.random().toString(16).substr(2, 14);
    const user4 = 'user4-' + Math.random().toString(16).substr(2, 14);
    const user5 = 'user5-' + Math.random().toString(16).substr(2, 14);
    const user6 = 'user6-' + Math.random().toString(16).substr(2, 14);

    const urlPrefix = 'http://resource.path.';
    const url1 = urlPrefix + tokenid1;
    const url2 = urlPrefix + tokenid2;
    const url3 = urlPrefix + tokenid3;
    const url4 = urlPrefix + tokenid4;
    const url5 = urlPrefix + tokenid5;
    const url6 = urlPrefix + tokenid6;

    // before(async () => {
    //     setGlobalOrg1();
    //     contract = await establishConn();
    // });

    it(' mint test tokens for different users from ORG1', async () => {
        setGlobalOrg1();
        contract = await establishConn();

        //mint new tokens
        await MintWithTokenURI(contract, tokenid1,url1,user1);
        await MintWithTokenURI(contract, tokenid2,url2,user2);
        await MintWithTokenURI(contract, tokenid3,url3,user3);
        await MintWithTokenURI(contract, tokenid4,url4,user4);
        await MintWithTokenURI(contract, tokenid5,url5,user5);

        //check the owners
        let owner1: string;
        let owner2: string;
        let owner3: string;
        let owner4: string;
        let owner5: string;
        try {
            owner1 = await OwnerOf(contract, tokenid1);
        } catch (e: any){
            console.log(e);
        }
        try {
            owner2 = await OwnerOf(contract, tokenid2);
        } catch (e: any){
            console.log(e);
        }
        try {
            owner3 = await OwnerOf(contract, tokenid3);
        } catch (e: any){
            console.log(e);
        }
        try {
            owner4 = await OwnerOf(contract, tokenid4);
        } catch (e: any){
            console.log(e);
        }
        try {
            owner5 = await OwnerOf(contract, tokenid5);
        } catch (e: any){
            console.log(e);
        }
        
        assert.equal(owner1, user1); 
        assert.equal(owner2, user2); 
        assert.equal(owner3, user3); 
        assert.equal(owner4, user4); 
        assert.equal(owner5, user5); 

        //check urls
        let tokenurl1: string;
        let tokenurl2: string;
        let tokenurl3: string;
        let tokenurl4: string;
        let tokenurl5: string;        
        try {
            tokenurl1 = await TokenURI(contract, tokenid1);
        } catch (e: any){
            console.log(e);
        }
        try {
            tokenurl2 = await TokenURI(contract, tokenid2);
        } catch (e: any){
            console.log(e);
        }
        try {
            tokenurl3 = await TokenURI(contract, tokenid3);
        } catch (e: any){
            console.log(e);
        }
        try {
            tokenurl4 = await TokenURI(contract, tokenid4);
        } catch (e: any){
            console.log(e);
        }
        try {
            tokenurl5 = await TokenURI(contract, tokenid5);
        } catch (e: any){
            console.log(e);
        }

        assert.equal(tokenurl1, url1); 
        assert.equal(tokenurl2, url2); 
        assert.equal(tokenurl3, url3); 
        assert.equal(tokenurl4, url4); 
        assert.equal(tokenurl5, url5); 

        //check balances
        let balance1: number = await BalanceOf(contract, user1);
        let balance2: number = await BalanceOf(contract, user2);
        let balance3: number = await BalanceOf(contract, user3);
        let balance4: number = await BalanceOf(contract, user4);
        let balance5: number = await BalanceOf(contract, user5);

        assert.equal(balance1, 1); 
        assert.equal(balance2, 1); 
        assert.equal(balance3, 1); 
        assert.equal(balance4, 1); 
        assert.equal(balance5, 1); 

    });

    it(' mint test tokens from ORG2 prohibited', async () => {
        setGlobalOrg2();
        contract = await establishConn();

        //mint new tokens
        try {
            await MintWithTokenURI(contract, tokenid6, url6, user6);
            assert.fail();
        } catch (e: any){
            console.log('err messages:', e.details[0].message);
            assert.equal(e.details[0].message, 'chaincode response 500, client is not authorized to mint NFT token');
        }

        //check the owners
        let owner6: string;
        try {
            owner6 = await OwnerOf(contract, tokenid6);
            assert.fail();
        } catch (e: any){
            console.log('err messages:', e.details[0].message);
        }
      
        //check urls
        let tokenurl6: string;      
        try {
            tokenurl6 = await TokenURI(contract, tokenid6);
            assert.fail();
        } catch (e: any){
            console.log('err messages:', e.details[0].message);
        }

        //check balances
        let balance6: number = await BalanceOf(contract, user6);

        assert.equal(balance6, 0); 

    });    

    it('burn the tokens of some users and gather  all tokens to a single user after burning by transfering remaining tokens', async () => {
        setGlobalOrg1();
        contract = await establishConn();

        //burn the tokens of some users
        await Burn(contract, tokenid1,user1);
        await Burn(contract, tokenid2,user2);

        //gather all tokens to one user after burning by transfering remaining tokens
        await TransferFrom(contract,tokenid3,user3, user5);
        await TransferFrom(contract,tokenid4,user4, user5); 

        //check the owners
        let owner1: string;
        let owner2: string;
        let owner3: string;
        let owner4: string;
        let owner5: string;
        try {
            owner1 = await OwnerOf(contract, tokenid1);
            assert.fail();
        } catch (e: any){
            console.log('err messages:', e.details[0].message);
        }
        try {
            owner2 = await OwnerOf(contract, tokenid2);
            assert.fail();
        } catch (e: any){
            console.log('err messages:', e.details[0].message);
        }
        try {
            owner3 = await OwnerOf(contract, tokenid3);
        } catch (e: any){
            console.log(e);
        }
        try {
            owner4 = await OwnerOf(contract, tokenid4);
        } catch (e: any){
            console.log(e);
        }
        try {
            owner5 = await OwnerOf(contract, tokenid5);
        } catch (e: any){
            console.log(e);
        }
        
        assert.equal(owner3, user5); 
        assert.equal(owner4, user5); 
        assert.equal(owner5, user5); 

        //check urls
        let tokenurl1: string;
        let tokenurl2: string;
        let tokenurl3: string;
        let tokenurl4: string;
        let tokenurl5: string;        
        try {
            tokenurl1 = await TokenURI(contract, tokenid1);
            assert.fail();
        } catch (e: any){
            console.log('err messages:', e.details[0].message);
        }
        try {
            tokenurl2 = await TokenURI(contract, tokenid2);
            assert.fail();
        } catch (e: any){
            console.log('err messages:', e.details[0].message);
        }
        try {
            tokenurl3 = await TokenURI(contract, tokenid3);
        } catch (e: any){
            console.log(e);
        }
        try {
            tokenurl4 = await TokenURI(contract, tokenid4);
        } catch (e: any){
            console.log(e);
        }
        try {
            tokenurl5 = await TokenURI(contract, tokenid5);
        } catch (e: any){
            console.log(e);
        }

        assert.equal(tokenurl3, url3); 
        assert.equal(tokenurl4, url4); 
        assert.equal(tokenurl5, url5); 

        //check balances
        let balance1: number = await BalanceOf(contract, user1);
        let balance2: number = await BalanceOf(contract, user2);
        let balance3: number = await BalanceOf(contract, user3);
        let balance4: number = await BalanceOf(contract, user4);
        let balance5: number = await BalanceOf(contract, user5);

        assert.equal(balance1, 0);
        assert.equal(balance2, 0);
        assert.equal(balance3, 0);
        assert.equal(balance4, 0);
        assert.equal(balance5, 3);

    }); 

    it('used for test only, will be deleted later after familiarization of invokation', async () => {
        setGlobalOrg1();
        contract = await establishConn();

        // Initialize a set of asset data on the ledger using the chaincode 'InitLedger' function.
        await initLedger(contract);

        // Return all the current assets on the ledger.
        await getAllAssets(contract);

        // Create a new asset on the ledger.
        await createAsset(contract);

        // Update an existing asset asynchronously.
        await transferAssetAsync(contract);

        // Get the asset details by assetID.
        await readAssetByID(contract);

        // Update an asset which does not exist.
        await updateNonExistentAsset(contract);

    });     

});


// async function main(): Promise<void> {

//     await displayInputParameters();

//     // The gRPC client connection should be shared by all Gateway connections to this endpoint.
//     const client = await newGrpcConnection();

//     const gateway = connect({
//         client,
//         identity: await newIdentity(),
//         signer: await newSigner(),
//         // Default timeouts for different gRPC calls
//         evaluateOptions: () => {
//             return { deadline: Date.now() + 5000 }; // 5 seconds
//         },
//         endorseOptions: () => {
//             return { deadline: Date.now() + 15000 }; // 15 seconds
//         },
//         submitOptions: () => {
//             return { deadline: Date.now() + 5000 }; // 5 seconds
//         },
//         commitStatusOptions: () => {
//             return { deadline: Date.now() + 60000 }; // 1 minute
//         },
//     });

//     try {
//         // Get a network instance representing the channel where the smart contract is deployed.
//         const network = gateway.getNetwork(channelName);

//         // Get the smart contract from the network.
//         const contract = network.getContract(chaincodeName);

//         // // Initialize a set of asset data on the ledger using the chaincode 'InitLedger' function.
//         // await initLedger(contract);

//         // // Return all the current assets on the ledger.
//         // await getAllAssets(contract);

//         // // Create a new asset on the ledger.
//         // await createAsset(contract);

//         // // Update an existing asset asynchronously.
//         // await transferAssetAsync(contract);

//         // // Get the asset details by assetID.
//         // await readAssetByID(contract);

//         // // Update an asset which does not exist.
//         // await updateNonExistentAsset(contract)
//     } finally {
//         gateway.close();
//         client.close();
//     }
// }

// main().catch(error => {
//     console.error('******** FAILED to run the application:', error);
//     process.exitCode = 1;
// });

async function newGrpcConnection(paraTlsCertPath: string): Promise<grpc.Client> {
    const tlsRootCert = await fs.readFile(paraTlsCertPath);
    const tlsCredentials = grpc.credentials.createSsl(tlsRootCert);
    return new grpc.Client(peerEndpoint, tlsCredentials, {
        'grpc.ssl_target_name_override': peerHostAlias,
    });
}

async function newIdentity(paraCertPath: string, paraMspId: string): Promise<Identity> {
    const credentials = await fs.readFile(paraCertPath);
    return { mspId: paraMspId, credentials };
}

async function newSigner(parakeyDirectoryPath:string): Promise<Signer> {
    const files = await fs.readdir(parakeyDirectoryPath);
    const keyPath = path.resolve(parakeyDirectoryPath, files[0]);
    const privateKeyPem = await fs.readFile(keyPath);
    const privateKey = crypto.createPrivateKey(privateKeyPem);
    return signers.newPrivateKeySigner(privateKey);
}

async function BalanceOf(contract: Contract, owner: string): Promise<number> {
    console.log('\n--> Evaluate Transaction: get BalanceOf', owner);

    const resultBytes = await contract.evaluateTransaction('BalanceOf', owner);

    const resultJson = JSON.stringify(utf8Decoder.decode(resultBytes));
    const result = Number(JSON.parse(resultJson));
    console.log('*** Result:', result);

    return result;
}

async function OwnerOf(contract: Contract, tokenId: string): Promise<string> {
    console.log('\n--> Evaluate Transaction: get OwnerOf', tokenId);

    const resultBytes = await contract.evaluateTransaction('OwnerOf', tokenId);

    const resultJson = JSON.stringify(utf8Decoder.decode(resultBytes));
    const result = JSON.parse(resultJson);
    console.log('*** Result:', result);

    return result;
}

async function TokenURI(contract: Contract, tokenId: string): Promise<string> {
    console.log('\n--> Evaluate Transaction: get TokenURI', tokenId);

    const resultBytes = await contract.evaluateTransaction('TokenURI', tokenId);

    const resultJson = JSON.stringify(utf8Decoder.decode(resultBytes));
    const result = JSON.parse(resultJson);
    console.log('*** Result:', result);

    return result;
}

async function MintWithTokenURI(contract: Contract, tokenId: string, tokenURI: string, minter: string): Promise<void> {
    console.log('\n--> Submit Transaction: MintWithTokenURI of', tokenId);

    await contract.submitTransaction(
        'MintWithTokenURI',
        tokenId,
        tokenURI,
        minter,
    );
    console.log('*** Transaction committed successfully');
}

async function Burn(contract: Contract, tokenId: string, minter: string): Promise<void> {
    console.log('\n--> Submit Transaction: Burn', tokenId);

    await contract.submitTransaction(
        'Burn',
        tokenId,
        minter,
    );
    console.log('*** Transaction committed successfully');
}

async function TransferFrom(contract: Contract, tokenId: string, from: string, to: string): Promise<void> {
    console.log('\n--> Submit Transaction: Transfer of', tokenId);

    await contract.submitTransaction(
        'TransferFrom',
        from,
        to,
        tokenId,
    );
    console.log('*** Transaction committed successfully');
}


/**
 * This type of transaction would typically only be run once by an application the first time it was started after its
 * initial deployment. A new version of the chaincode deployed later would likely not need to run an "init" function.
 */
async function initLedger(contract: Contract): Promise<void> {
    console.log('\n--> Submit Transaction: InitLedger, function creates the initial set of assets on the ledger');

    await contract.submitTransaction('InitLedger');

    console.log('*** Transaction committed successfully');
}

/**
 * Evaluate a transaction to query ledger state.
 */
async function getAllAssets(contract: Contract): Promise<void> {
    console.log('\n--> Evaluate Transaction: GetAllAssets, function returns all the current assets on the ledger');

    const resultBytes = await contract.evaluateTransaction('GetAllAssets');

    const resultJson = utf8Decoder.decode(resultBytes);
    const result = JSON.parse(resultJson);
    console.log('*** Result:', result);
}

/**
 * Submit a transaction synchronously, blocking until it has been committed to the ledger.
 */
async function createAsset(contract: Contract): Promise<void> {
    console.log('\n--> Submit Transaction: CreateAsset, creates new asset with ID, Color, Size, Owner and AppraisedValue arguments');

    await contract.submitTransaction(
        'CreateAsset',
        assetId,
        'yellow',
        '5',
        'Tom',
        '1300',
    );

    console.log('*** Transaction committed successfully');
}

/**
 * Submit transaction asynchronously, allowing the application to process the smart contract response (e.g. update a UI)
 * while waiting for the commit notification.
 */
async function transferAssetAsync(contract: Contract): Promise<void> {
    console.log('\n--> Async Submit Transaction: TransferAsset, updates existing asset owner');

    const commit = await contract.submitAsync('TransferAsset', {
        arguments: [assetId, 'Saptha'],
    });
    const oldOwner = utf8Decoder.decode(commit.getResult());

    console.log(`*** Successfully submitted transaction to transfer ownership from ${oldOwner} to Saptha`);
    console.log('*** Waiting for transaction commit');

    const status = await commit.getStatus();
    if (!status.successful) {
        throw new Error(`Transaction ${status.transactionId} failed to commit with status code ${status.code}`);
    }

    console.log('*** Transaction committed successfully');
}

async function readAssetByID(contract: Contract): Promise<void> {
    console.log('\n--> Evaluate Transaction: ReadAsset, function returns asset attributes');

    const resultBytes = await contract.evaluateTransaction('ReadAsset', assetId);

    const resultJson = utf8Decoder.decode(resultBytes);
    const result = JSON.parse(resultJson);
    console.log('*** Result:', result);
}

/**
 * submitTransaction() will throw an error containing details of any error responses from the smart contract.
 */
async function updateNonExistentAsset(contract: Contract): Promise<void>{
    console.log('\n--> Submit Transaction: UpdateAsset asset70, asset70 does not exist and should return an error');

    try {
        await contract.submitTransaction(
            'UpdateAsset',
            'asset70',
            'blue',
            '5',
            'Tomoko',
            '300',
        );
        console.log('******** FAILED to return an error');
    } catch (error) {
        console.log('*** Successfully caught the error: \n', error);
    }
}

/**
 * envOrDefault() will return the value of an environment variable, or a default value if the variable is undefined.
 */
function envOrDefault(key: string, defaultValue: string): string {
    return process.env[key] || defaultValue;
}

/**
 * displayInputParameters() will print the global scope parameters used by the main driver routine.
 */
async function displayInputParameters(): Promise<void> {
    console.log(`channelName:       ${channelName}`);
    console.log(`chaincodeName:     ${chaincodeName}`);
    console.log(`mspId:             ${mspId}`);
    console.log(`cryptoPath:        ${cryptoPath}`);
    console.log(`keyDirectoryPath:  ${keyDirectoryPath}`);
    console.log(`certPath:          ${certPath}`);
    console.log(`tlsCertPath:       ${tlsCertPath}`);
    console.log(`peerEndpoint:      ${peerEndpoint}`);
    console.log(`peerHostAlias:     ${peerHostAlias}`);
}

async function establishConn(): Promise<any> {
    displayInputParameters();
    // The gRPC client connection should be shared by all Gateway connections to this endpoint.
    const client = await newGrpcConnection(tlsCertPath);

    const gateway = connect({
        client,
        identity: await newIdentity(certPath, mspId),
        signer: await newSigner(keyDirectoryPath),
        // Default timeouts for different gRPC calls
        evaluateOptions: () => {
            return { deadline: Date.now() + 5000 }; // 5 seconds
        },
        endorseOptions: () => {
            return { deadline: Date.now() + 15000 }; // 15 seconds
        },
        submitOptions: () => {
            return { deadline: Date.now() + 5000 }; // 5 seconds
        },
        commitStatusOptions: () => {
            return { deadline: Date.now() + 60000 }; // 1 minute
        },
    });

    // Get a network instance representing the channel where the smart contract is deployed.
    const network = gateway.getNetwork(channelName);

    // Get the smart contract from the network.
    const contract = network.getContract(chaincodeName);  
    return contract; 
}