export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_BROKER_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/ca.crt
export PEER0_CEREALIST_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/ca.crt
export PEER0_MILLS_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/ca.crt

export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=bcmchannel

setGlobalsForOrderer(){
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

setGlobalsForPeer0Broker(){
   export CORE_PEER_LOCALMSPID="BrokerMSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BROKER_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp
   export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Broker(){
   export CORE_PEER_LOCALMSPID="BrokerMSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BROKER_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp
   export CORE_PEER_ADDRESS=localhost:8051

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

setGlobalsForPeer0Mills(){
   export CORE_PEER_LOCALMSPID="MillsMSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MILLS_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp
   export CORE_PEER_ADDRESS=localhost:13051

}

setGlobalsForPeer1Mills(){
   export CORE_PEER_LOCALMSPID="MillsMSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MILLS_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp
   export CORE_PEER_ADDRESS=localhost:14051

}



createChannel(){
#    rm -rf ./channel-artifacts/*
    rm -rf ./channel-artifacts/bcmchannel.block
    setGlobalsForPeer0Broker

    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

# createChannel

removeOldCrypto(){
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-broker/*
}


joinChannel(){
   setGlobalsForPeer0Broker
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

   sleep 2
   setGlobalsForPeer1Broker
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block


    sleep 2
    setGlobalsForPeer0Cerealist
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    sleep 2
    setGlobalsForPeer1Cerealist
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

   sleep 2
   setGlobalsForPeer0Mills
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

   sleep 2
   setGlobalsForPeer1Mills
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block


}
# joinChannel

updateAnchorPeers(){
   setGlobalsForPeer0Broker
   peer channel update -o localhost:7050 \
   --ordererTLSHostnameOverride orderer.example.com \
   -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_BCM.tx \
   --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    setGlobalsForPeer0Cerealist
    peer channel update -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_BCM.tx \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

   setGlobalsForPeer0Mills
   peer channel update -o localhost:7050 \
   --ordererTLSHostnameOverride orderer.example.com \
   -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_BCM.tx \
   --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA


}

# updateAnchorPeers


removeOldCrypto

createChannel
sleep 4
joinChannel
sleep 3
updateAnchorPeers
