"use client"
import Image from 'next/image'
import styles from './page.module.css'
import { useState } from 'react'

export default function Home() {

  const [isConnected,setIsConnected] = useState(false);
  const [provider, setProvider] = useState()

  async function connect(){
       
       if(typeof window.ethereum != 'undefined'){

           try {
             
            await ethereum.request({
              method: "eth_requestAccounts"
            });

            setIsConnected(true);
            let connectedProvider = new ethers.providers.Web3Provider(
              window.ethereum
            )
            setProvider(connectedProvider)
             
           } catch (error) {
            console.log(error);
           }
       } 
       
  }
  return (
    <main className={styles.main}>

     
   <button onClick={connect}>
    connect
   </button>
      
       
    </main>
  )
}
