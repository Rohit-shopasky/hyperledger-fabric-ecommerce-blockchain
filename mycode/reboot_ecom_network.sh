set -ev

echo "Removing key from key store..."

rm -rf ./hfc-key-store



# Remove chaincode docker image

docker rmi -f dev-peer0.delivery1.example.com-ecom-1.0-5c635694408fa6b236c2c25d7c33c16d5f41085de5aad44c1a9dcb3aba9a1f93

docker-compose -f docker-compose.yml down

docker-compose up -d 

sleep 10

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@Delivery1.example.com/msp" peer0.Delivery1.example.com peer channel create -o orderer.example.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@Delivery1.example.com/msp" peer0.Delivery1.example.com peer channel join -b mychannel.block


docker cp peer0.Delivery1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/mychannel.block mychannel.block
docker cp mychannel.block peer0.Ecom1.example.com:/opt/gopath/src/github.com/hyperledger/fabric/
rm mychannel.block


docker exec -e "CORE_PEER_LOCALMSPID=EcomMSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@Ecom1.example.com/msp" peer0.Ecom1.example.com peer channel join -b mychannel.block


######################################################## Install chaincode #####################################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode install -n Ecom -v 1.0 -p "/opt/gopath/src/github.com/javascript/" -l "node"

################################################## Instanitate chaincode #######################################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n Ecom -l "node" -v 1.0 -c '{"Args":[]}' -P "OR ('DeliveryMSP.member','EcomMSP.member')"

sleep 10

################################### Initialize products in  Ecommerce Shop ###################################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"initLedger","Args":[]}'

sleep 5

########################################### Show all products of shop ################################################
 
docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"queryAllProducts","Args":[]}'


sleep 5


######################################### Buy Smartphone from the Ecommerce Platform ############################################


docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"buyProduct","Args":["Item0","Rohit","1"]}'

sleep 5
########################################  Buy T-Shirt from Ecommerce Platform ###################################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"buyProduct","Args":["Item2","Rohit","1"]}'

sleep 5
#######################################  Show All of my orders ###################################################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"myOrders","Args":["Rohit"]}'

sleep 5

######################################## Change Smartphone Order Status to "Dispatched" ##########################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"changeOrderStatus","Args":["1","Dispatched"]}'

sleep 5 

######################################## Change Smartphone Order Status to Delivered #############################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"changeOrderStatus","Args":["1","Delivered"]}'

sleep 5 
####################################### Show again my all orders #################################################################

docker exec -e "CORE_PEER_LOCALMSPID=DeliveryMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/Delivery1.example.com/users/Admin@Delivery1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n Ecom -c '{"function":"myOrders","Args":["Rohit"]}'


echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo
