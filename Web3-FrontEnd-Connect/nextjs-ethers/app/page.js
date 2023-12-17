"use client";
import React from 'react';
import { Web3Provider } from '@ethersproject/providers'; // Correct import statement
import { ethers } from "ethers";
import { useEffect, useState } from "react";

export default function Home() {
  const [isConnected, setIsConnected] = useState(false);
  const [hasMetamask, setHasMetamask] = useState(false);
  const [signer, setSigner] = useState(undefined);

  useEffect(() => {
    if (typeof window.ethereum !== "undefined") {
      setHasMetamask(true);
    }
  });

  async function connect() {
    if (typeof window.ethereum !== 'undefined') {
      try {
        await ethereum.request({
          method: 'eth_requestAccounts',
        });

        setIsConnected(true);
        let connectedProvider =new Web3Provider(window.ethereum);
        setSigner(connectedProvider.getSigner());
      } catch (error) {
        setIsConnected(false);
        console.log(error);
      }
    }
  }


  async function execute() {
    if (typeof window.ethereum !== "undefined") {
     const contractAddress = "0xbF0676079a18eaE5b44C69c21E1684b9EA58FadA";
      const abi = [{
          "inputs": [{ "internalType": "string", "name": "_name", "type": "string" },
          { "internalType": "uint256", "name": "_favoriteNumber", "type": "uint256" }],
          "name": "addPerson", "outputs": [],
          "stateMutability": "nonpayable", "type": "function"
      },
      {
          "inputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
          "name": "listOfPeople", "outputs": [{ "internalType": "uint256", "name": "favoriteNumber", "type": "uint256" },
          { "internalType": "string", "name": "name", "type": "string" }], "stateMutability": "view", "type": "function"
      },
      {
          "inputs": [{ "internalType": "string", "name": "", "type": "string" }],
          "name": "nameToFavoriteNumber", "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
          "stateMutability": "view", "type": "function"
      }, {
          "inputs": [], "name": "retrieve",
          "outputs": [{ "internalType": "uint256", "name": "", "type": "uint256" }],
          "stateMutability": "view", "type": "function"
      },
      {
          "inputs": [{ "internalType": "uint256", "name": "_favoriteNumber", "type": "uint256" }],
          "name": "store", "outputs": [], "stateMutability": "nonpayable", "type": "function"
      }];
      const provider = new Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(contractAddress, abi, signer);
      try {
        await contract.store(42);
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Please install MetaMask");
    }
  }
  return (
    <div>
      {hasMetamask ? (
        isConnected ? (
          "Connected! "
        ) : (
          <button onClick={() => connect()}>Connect</button>
        )
      ) : (
        "Please install metamask"
      )}

      {isConnected ? <button onClick={() => execute()}>Execute</button> : ""}
    </div>
  );
}
