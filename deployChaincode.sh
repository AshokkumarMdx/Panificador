export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_BROKER_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/ca.crt
export PEER0_FARMER_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
export PEER0_CEREALIST_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/ca.crt
export PEER0_MILLS_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/ca.crt
export PEER0_BAKER_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/baker.example.com/peers/peer0.baker.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

setGlobalsForPeer0Broker() {
    export CORE_PEER_LOCALMSPID="BrokerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BROKER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Broker(){
    export CORE_PEER_LOCALMSPID="BrokerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_BROKER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
}

setGlobalsForPeer0Farmer() {
    export CORE_PEER_LOCALMSPID="FarmerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1Farmer(){
    export CORE_PEER_LOCALMSPID="FarmerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_FARMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051

}


setGlobalsForPeer0Cerealist(){
    export CORE_PEER_LOCALMSPID="CerealistMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CEREALIST_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

}

setGlobalsForPeer1Cerealist(){
    export CORE_PEER_LOCALMSPID="CerealistMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_CEREALIST_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051

}

setGlobalsForPeer0Mills(){
    export CORE_PEER_LOCALMSPID="MillsMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MILLS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp
    export CORE_PEER_ADDRESS=localhost:13051

}

setGlobalsForPeer1Mills(){
    export CORE_PEER_LOCALMSPID="MillsMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_MILLS_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp
    export CORE_PEER_ADDRESS=localhost:14051

}


setGlobalsForPeer0Baker(){
    export CORE_PEER_LOCALMSPID="BakerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BAKER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/baker.example.com/users/Admin@baker.example.com/msp
    export CORE_PEER_ADDRESS=localhost:15051

}

setGlobalsForPeer1Baker(){
    export CORE_PEER_LOCALMSPID="BakerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_BAKER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/baker.example.com/users/Admin@baker.example.com/msp
    export CORE_PEER_ADDRESS=localhost:16051

}

presetup() {
    echo Vendoring Go dependencies ...
    #pushd ./artifacts/src/github.com/fabcar/go
    pushd ./artifacts/src/github.com/org
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
SEQUENCE="1"
#CC_SRC_PATH="./artifacts/src/github.com/fabcar/go"
CC_SRC_PATH="./artifacts/src/github.com/org"
CC_NAME="org"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0Broker
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0Broker
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.broker ===================== "

    setGlobalsForPeer0Farmer
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.farmer ===================== "

    setGlobalsForPeer0Cerealist
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.cerealist ===================== "

    setGlobalsForPeer0Mills
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.mills ===================== "

    setGlobalsForPeer0Baker
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.baker ===================== "


}


# installChaincode

queryInstalled() {
    setGlobalsForPeer0Broker
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.broker on channel ===================== "
}

# queryInstalled

approveForMyBroker() {
    setGlobalsForPeer0Broker
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}


checkCommitReadyness1() {
    setGlobalsForPeer0Broker
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

approveForMyFarmer() {
    setGlobalsForPeer0Farmer

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 2 ===================== "
}

# queryInstalled
# approveForMyFarmer

checkCommitReadyness2() {

    setGlobalsForPeer0Farmer
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 2 ===================== "
}

# checkCommitReadyness

approveForMyCerealist() {
    setGlobalsForPeer0Cerealist

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 3 ===================== "
}

# queryInstalled
# approveForMyCerealist

checkCommitReadyness3() {

    setGlobalsForPeer0Cerealist
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_CEREALIST_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 3 ===================== "
}

# checkCommitReadyness

approveForMyMills() {
    setGlobalsForPeer0Mills

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 4 ===================== "
}

# queryInstalled
# approveForMyMills

checkCommitReadyness4() {

    setGlobalsForPeer0Mills
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MILLS_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 4 ===================== "
}


# checkCommitReadyness

approveForMyBaker() {
    setGlobalsForPeer0Baker

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 5 ===================== "
}

# queryInstalled
# approveForMyMills

checkCommitReadyness5() {

    setGlobalsForPeer0Baker
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_BAKER_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 5 ===================== "
}

commitChaincodeDefination() {
    setGlobalsForPeer0Broker
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_BROKER_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_CEREALIST_CA \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MILLS_CA \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_BAKER_CA \
        --version ${VERSION} --sequence ${SEQUENCE} --init-required

}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0Broker
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0Broker
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_BROKER_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA \
         --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_CEREALIST_CA \
         --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MILLS_CA \
         --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_BAKER_CA \
         --isInit -c '{"Args":[]}'


}

# chaincodeInvokeInit

chaincodeInvoke() {
    setGlobalsForPeer0Broker

    # Create User
    peer chaincode invoke -o localhost:7050 \
	--ordererTLSHostnameOverride orderer.example.com \
	--tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_BROKER_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA   \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_CEREALIST_CA   \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_MILLS_CA   \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_BAKER_CA   \
        -c '{"function":"createOrg","Args":["{\"orgId\":\"broker\",\"orgName\":\"Infosys\",\"email\":\"1234\",\"phone\":\"888888888\",\"status\":\"Active\",\"orgAdminId\":\"user1\",\"role\":\"Operator\"}"]}'

        #-c '{"function":"Invoke","Args":[]}'

	echo ${CC_NAME}



}

# chaincodeInvoke

chaincodeInvokeDeleteAsset() {
    setGlobalsForPeer0Broker

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_BROKER_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA   \
        -c '{"function": "DeleteCarById","Args":["2"]}'

}

# chaincodeInvokeDeleteAsset

chaincodeQuery() {
    setGlobalsForPeer0Broker
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryOrgByID","Args":["broker"]}'

}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
presetup

packageChaincode
installChaincode
queryInstalled

approveForMyBroker
checkCommitReadyness1

approveForMyFarmer
checkCommitReadyness2

approveForMyCerealist
checkCommitReadyness3

approveForMyMills
checkCommitReadyness4

approveForMyBaker
checkCommitReadyness5

commitChaincodeDefination
queryCommitted

chaincodeInvokeInit
sleep 5
chaincodeInvoke
sleep 3
chaincodeQuery
