Steps:

**Clone the repository**

git clone https://github.com/mdxdealstryker/PANIFICADOR-HL-BC.git

**Run Certificates Authority Services for all Orgs**

cd artifacts/channel/create-certificate

docker-compose up -d

**Create Cryptomaterials for all organizations**

cd artifacts/channel/create-certificates

./create-certificates.sh 

**Create Channel Artifacts using Org MSP**

cd artifacts/channel

./create-artifacts.sh 

**Run the docker images which is artifacts**

cd artifacts/

docker-compose up -d

cd to main folder

**Create Channel and join peers**

**(For Common Channel)**

./createChannel.sh   

**(For Grain Commercial Channel: Farmer-Ceralista)**

./createChannel_GC.sh      

**(For Grain Operations Channel: Broker-Farmer-Ceralista)**
 
./createChannel_GOP.sh    

**(For Flour Channel (Stored Grain Channel): Broker-Ceralisa-Mill)**

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

cd artifacts/channel/create-certificates

docker-compose down

In case need to prune dockers

docker system prune -a

docker system prune --volumes -f





