
# Delete existing artifacts
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"
echo $CHANNEL_NAME

# Grain Commercial Channel
GC_CHANNEL_NAME="gcchannel"
echo $GC_CHANNEL_NAME

# Grain Operations Channel
GOP_CHANNEL_NAME="gopchannel"
echo $GOP_CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$CHANNEL_NAME.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for Org1MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

echo "#######    Generating anchor peer update for Org3MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP

echo "#######    Generating anchor peer update for Org4MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org4MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org4MSP

echo "#######    Generating anchor peer update for Org5MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./Org5MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org5MSP


# Generate channel configuration block for Grain Commercial
configtxgen -profile GC_Channel -configPath . -outputCreateChannelTx ./$GC_CHANNEL_NAME.tx -channelID $GC_CHANNEL_NAME

echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile GC_Channel -configPath . -outputAnchorPeersUpdate ./Org2MSPanchors_GC.tx -channelID $GC_CHANNEL_NAME -asOrg Org2MSP

echo "#######    Generating anchor peer update for Org3MSP  ##########"
configtxgen -profile GC_Channel -configPath . -outputAnchorPeersUpdate ./Org3MSPanchors_GC.tx -channelID $GC_CHANNEL_NAME -asOrg Org3MSP


# Generate channel configuration block for Grain Commercial
configtxgen -profile GOP_Channel -configPath . -outputCreateChannelTx ./$GOP_CHANNEL_NAME.tx -channelID $GOP_CHANNEL_NAME

echo "#######    Generating anchor peer update for Org1MSP  ##########"
configtxgen -profile GOP_Channel -configPath . -outputAnchorPeersUpdate ./Org1MSPanchors_GOP.tx -channelID $GOP_CHANNEL_NAME -asOrg Org1MSP

echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile GOP_Channel -configPath . -outputAnchorPeersUpdate ./Org2MSPanchors_GOP.tx -channelID $GOP_CHANNEL_NAME -asOrg Org2MSP

echo "#######    Generating anchor peer update for Org3MSP  ##########"
configtxgen -profile GOP_Channel -configPath . -outputAnchorPeersUpdate ./Org3MSPanchors_GOP.tx -channelID $GOP_CHANNEL_NAME -asOrg Org3MSP
