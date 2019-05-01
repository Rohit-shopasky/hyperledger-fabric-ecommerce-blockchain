# hyperledger-fabric-ecommerce-blockchain

This is a small blockchain network of Ecommerce platform and Delivery Platform. In which a customer buy products from ecommerce 
platform. After that Ecommerce platfrom transfer ordered product to Ecommerce platfrom. Ecommerce platfrom deliver that product 
to the customer. 

## Network Components
   This network consists of 
   
   2 CAs
   
   A Solo Orderer
   
   2 Peers (1 peer per org)
   
## Artifacts
 Crypto materials are already generated using cryptogen tool.
 An Orderer genesis block (genesis.block) and channel configuration transaction 
 (mychannel.tx) has been pre generated using the **configtxgen** tool from Hyperledger Fabric and placed within the artifacts folder.
 
 ## Start the network
   To start the network. I have made a start script. It automatically starts the network and invoke some predefined commands.
    
    $ cd hyperledger-fabric-ecommerce-blockchain/mycode
   
   Run the start script
   
    $ ./start_ecom_network.sh 

You can see Node.js chaincode and edit it.
   
To reboot network 

    $ ./reboot_ecom_network.sh
   
   
   Thats all. This network is in development mode. Please do not use it in Production.
   

 
