Steps:

Clone the repo

git clone https://github.com/mdxdealstryker/PANIFICADOR-HL-BC.git

Run Certificates Authority Services for all Orgs

cd artifacts/channel/create-certificates

docker-compose up -d

Create Cryptomaterials for all organizations
cd artifacts/channel/create-certificates

./create-certificates.sh

Create Channel Artifacts using Org MSP
cd artifacts/channel

./create-artifacts.sh

Run the docker images which is artifacts

cd artifacts/

docker-compose up -d

cd to main folder

Create Channel and join peers

./createChannel.sh

./createChannel_GC.sh

Deploy Chaincode

./deployChaincode.sh

./deployChaincode_GC.sh

----------
To stop the application

cd artifacts/

docker-compose down

cd artifacts/channel/create-certificates

docker-compose down

In case need to prune dockers

docker system prune -a

docker system prune --volumes -f





