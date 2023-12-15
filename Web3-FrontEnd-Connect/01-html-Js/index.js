const {ethers} = require("ethers")
const connectBtn = document.getElementById("connect")
async  function connect() {
      if (typeof window.ethereum !== "undefined") {
          console.log("we see metamask!!");
         await ethereum.request({ method: "eth_requestAccounts" })
      }
  }

async function execute(){
   // address
   // contract ABI
   // function
   // node connection
}

module.exports = {
    connect , execute
}