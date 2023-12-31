Steps:

**Clone the repository**

git clone https://github.com/AshokkumarMdx/Panificador.git

**Run Certificates Authority Services for all Orgs**

cd artifacts/channel/create-certificate-with-ca

docker-compose up -d

**Create Cryptomaterials for all organizations**

cd artifacts/channel/create-certificate-with-ca

./create-certificate-with-ca.sh

**Create Channel Artifacts using Org MSP**

cd artifacts/channel

./create-artifacts.sh 

**Run the docker images which is artifacts**

cd artifacts/

docker-compose up -d

cd to main folder

**Create Channel and join peers**

**(For Broker-Farmer-Ceralista-Mill-Baker Channels)**

./createChannel.sh   

**(For Grain Commercial Channel: Farmer-Ceralista)**

./createChannel_GC.sh      

**(For Grain Operations Channel: Broker-Farmer-Ceralista)**
 
./createChannel_GOP.sh    

**(For Flour Channel (Stored Grain Channel): Broker-Ceralista-Mill)**

./createChannel_GS.sh      

**Deploy Chaincode**

**(For All Orgs Chaincode)**

./deployChaincode.sh             

**(For Grain Commercial Channel: Farmer-Ceralista)**

./deployChaincode_GC.sh          

**(For Grain Operations Channel: Broker-Farmer-Ceralista)**

./deployChaincode_GOP.sh         

**(For Flour Channel (Stored Grain Channel): Broker-Ceralisa-Mill)**
 
./deployChaincode_GS.sh         

----------
**To stop the application**

cd artifacts/

docker-compose down

cd artifacts/channel/create-certificate-with-ca

docker-compose down

In case need to prune dockers

docker system prune -a

docker system prune --volumes -f





