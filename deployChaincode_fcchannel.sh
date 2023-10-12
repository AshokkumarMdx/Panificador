export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_FARMER_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
export PEER0_CEREALIST_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=fcchannel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

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



presetup() {
    echo Vendoring Go dependencies ...
    #pushd ./artifacts/src/github.com/fabcar/go
    pushd ./artifacts/src/github.com/org
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME="fcchannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
SEQUENCE="1"
#CC_SRC_PATH="./artifacts/src/github.com/fabcar/go"
CC_SRC_PATH="./artifacts/src/github.com/org"
CC_NAME="orggc"

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0Farmer
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged ===================== "
}
# packageChaincode

installChaincode() {

    setGlobalsForPeer0Farmer
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.farmer ===================== "

    setGlobalsForPeer0Cerealist
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.cerealist ===================== "


}


# installChaincode

queryInstalled() {
    setGlobalsForPeer0Farmer
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled

approveForMyOrg1() {
    setGlobalsForPeer0Org1
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
    setGlobalsForPeer0Org1
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

approveForMyOrg4() {
    setGlobalsForPeer0Org4

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 4 ===================== "
}

# queryInstalled
# approveForMyOrg4

checkCommitReadyness4() {

    setGlobalsForPeer0Org4
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 4 ===================== "
}


# checkCommitReadyness

approveForMyOrg5() {
    setGlobalsForPeer0Org5

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${SEQUENCE}

    echo "===================== chaincode approved from org 5 ===================== "
}

# queryInstalled
# approveForMyOrg4

checkCommitReadyness5() {

    setGlobalsForPeer0Org5
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_ORG5_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 5 ===================== "
}

commitChaincodeDefination() {
    setGlobalsForPeer0Farmer
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_CEREALIST_CA \
        --version ${VERSION} --sequence ${SEQUENCE} --init-required

#        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
#        --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA \
#        --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_ORG5_CA \
}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0Farmer
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0Farmer
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA \
         --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_CEREALIST_CA \
         --isInit -c '{"Args":[]}'

#        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
#         --peerAddresses localhost:13051 --tlsRootCertFiles $PEER0_ORG4_CA \
#         --peerAddresses localhost:15051 --tlsRootCertFiles $PEER0_ORG5_CA \
    #	 --isInit -c '{"function":"Init","Args":[]}'
    #    --isInit -c '{"Args":[]}'

}

# chaincodeInvokeInit

chaincodeInvoke() {
    setGlobalsForPeer0Farmer

    # Create User
    peer chaincode invoke -o localhost:7050 \
	--ordererTLSHostnameOverride orderer.example.com \
	--tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_FARMER_CA   \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_CEREALIST_CA   \
        -c '{"function":"createOrg","Args":["{\"orgId\":\"org1\",\"orgName\":\"Infosys\",\"email\":\"1234\",\"phone\":\"888888888\",\"status\":\"Active\",\"orgAdminId\":\"user1\",\"role\":\"Operator\"}"]}'



	echo ${CC_NAME}



}
# chaincodeInvoke

chaincodeInvokeDeleteAsset() {
    setGlobalsForPeer0Farmer

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_FARMER_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_CEREALIST_CA   \
        -c '{"function": "DeleteCarById","Args":["2"]}'

}

# chaincodeInvokeDeleteAsset

chaincodeQuery() {
    setGlobalsForPeer0Farmer
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryOrgByID","Args":["org1"]}'

}



packageChaincode
installChaincode
queryInstalled

approveForMyFarmer
checkCommitReadyness2

approveForMyCerealist
checkCommitReadyness3

commitChaincodeDefination
queryCommitted

chaincodeInvokeInit
sleep 5
chaincodeInvoke
sleep 3
chaincodeQuery
