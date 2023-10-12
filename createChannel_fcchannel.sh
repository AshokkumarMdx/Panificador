export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_FARMER_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
export PEER0_CEREALIST_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=fcchannel

setGlobalsForOrderer(){
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

setGlobalsForPeer0Farmer(){
    export CORE_PEER_LOCALMSPID="FarmerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMER_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

}

setGlobalsForPeer1Farmer(){
    export CORE_PEER_LOCALMSPID="FarmerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_FARMER_CA
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
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CEREALIST_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051

}

createChannel(){
#    rm -rf ./channel-artifacts/*
    rm -rf ./channel-artifacts/fcchannel.block
    setGlobalsForPeer0Farmer

    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# createChannel

removeOldCrypto(){
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-org1/*
}


joinChannel(){

#    sleep 2
    setGlobalsForPeer0Farmer
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    sleep 2
    setGlobalsForPeer1Farmer
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    sleep 2
    setGlobalsForPeer0Cerealist
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    sleep 2
    setGlobalsForPeer1Cerealist
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block




}
# joinChannel

updateAnchorPeers(){

    setGlobalsForPeer0Farmer
    peer channel update -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_FC.tx \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    setGlobalsForPeer0Cerealist
    peer channel update -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_FC.tx \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}


removeOldCrypto

createChannel
sleep 4
joinChannel
sleep 3
updateAnchorPeers
