export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
export PEER0_ORG4_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt

export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=gschannel

setGlobalsForOrderer(){
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

setGlobalsForPeer0Org1(){
   export CORE_PEER_LOCALMSPID="Org1MSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
   export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer1Org1(){
   export CORE_PEER_LOCALMSPID="Org1MSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
   export CORE_PEER_ADDRESS=localhost:8051

}

setGlobalsForPeer0Org3(){
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051

}

setGlobalsForPeer1Org3(){
    export CORE_PEER_LOCALMSPID="Org3MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_ADDRESS=localhost:12051

}

setGlobalsForPeer0Org4(){
   export CORE_PEER_LOCALMSPID="Org4MSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
   export CORE_PEER_ADDRESS=localhost:13051

}

setGlobalsForPeer1Org4(){
   export CORE_PEER_LOCALMSPID="Org4MSP"
   export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG4_CA
   export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
   export CORE_PEER_ADDRESS=localhost:14051

}



createChannel(){
#    rm -rf ./channel-artifacts/*
    rm -rf ./channel-artifacts/gschannel.block
    setGlobalsForPeer0Org1

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
   setGlobalsForPeer0Org1
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

   sleep 2
   setGlobalsForPeer1Org1
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block


    sleep 2
    setGlobalsForPeer0Org3
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    sleep 2
    setGlobalsForPeer1Org3
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

   sleep 2
   setGlobalsForPeer0Org4
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

   sleep 2
   setGlobalsForPeer1Org4
   peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

#    sleep 2
#    setGlobalsForPeer0Org5
#    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

#    sleep 2
#    setGlobalsForPeer1Org5
#    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block


}
# joinChannel

updateAnchorPeers(){
   setGlobalsForPeer0Org1
   peer channel update -o localhost:7050 \
   --ordererTLSHostnameOverride orderer.example.com \
   -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_GS.tx \
   --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    setGlobalsForPeer0Org3
    peer channel update -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.example.com \
    -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_GS.tx \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

   setGlobalsForPeer0Org4
   peer channel update -o localhost:7050 \
   --ordererTLSHostnameOverride orderer.example.com \
   -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors_GS.tx \
   --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA


}

# updateAnchorPeers


removeOldCrypto

createChannel
sleep 4
joinChannel
sleep 3
updateAnchorPeers