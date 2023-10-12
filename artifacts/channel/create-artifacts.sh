
# Delete existing artifacts
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"
echo $CHANNEL_NAME

# Grain Commercial Channel
FC_CHANNEL_NAME="fcchannel"
echo $FC_CHANNEL_NAME

# Grain Operations Channel
BFC_CHANNEL_NAME="bfcchannel"
echo $BFC_CHANNEL_NAME

# Grain Stored Channel
BCM_CHANNEL_NAME="bcmchannel"
echo $BCM_CHANNEL_NAME


# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$CHANNEL_NAME.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for BrokerMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./BrokerMSPanchors.tx -channelID $CHANNEL_NAME -asOrg BrokerMSP

echo "#######    Generating anchor peer update for FarmerMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./FarmerMSPanchors.tx -channelID $CHANNEL_NAME -asOrg FarmerMSP

echo "#######    Generating anchor peer update for CerealistMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./CerealistMSPanchors.tx -channelID $CHANNEL_NAME -asOrg CerealistMSP

echo "#######    Generating anchor peer update for MillsMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./MillsMSPanchors.tx -channelID $CHANNEL_NAME -asOrg MillsMSP

echo "#######    Generating anchor peer update for BakerMSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./BakerMSPanchors.tx -channelID $CHANNEL_NAME -asOrg BakerMSP


# Generate channel configuration block for Grain Commercial
configtxgen -profile FC_Channel -configPath . -outputCreateChannelTx ./$FC_CHANNEL_NAME.tx -channelID $FC_CHANNEL_NAME

echo "#######    Generating anchor peer update for FarmerMSP  ##########"
configtxgen -profile FC_Channel -configPath . -outputAnchorPeersUpdate ./FarmerMSPanchors_FC.tx -channelID $FC_CHANNEL_NAME -asOrg FarmerMSP

echo "#######    Generating anchor peer update for CerealistMSP  ##########"
configtxgen -profile FC_Channel -configPath . -outputAnchorPeersUpdate ./CerealistMSPanchors_FC.tx -channelID $FC_CHANNEL_NAME -asOrg CerealistMSP


# Generate channel configuration block for Grain Commercial
configtxgen -profile BFC_Channel -configPath . -outputCreateChannelTx ./$BFC_CHANNEL_NAME.tx -channelID $BFC_CHANNEL_NAME

echo "#######    Generating anchor peer update for BrokerMSP  ##########"
configtxgen -profile BFC_Channel -configPath . -outputAnchorPeersUpdate ./BrokerMSPanchors_BFC.tx -channelID $BFC_CHANNEL_NAME -asOrg BrokerMSP

echo "#######    Generating anchor peer update for FarmerMSP  ##########"
configtxgen -profile BFC_Channel -configPath . -outputAnchorPeersUpdate ./FarmerMSPanchors_BFC.tx -channelID $BFC_CHANNEL_NAME -asOrg FarmerMSP

echo "#######    Generating anchor peer update for CerealistMSP  ##########"
configtxgen -profile BFC_Channel -configPath . -outputAnchorPeersUpdate ./CerealistMSPanchors_BFC.tx -channelID $BFC_CHANNEL_NAME -asOrg CerealistMSP


# Generate channel configuration block for Grain Srored
configtxgen -profile BCM_Channel -configPath . -outputCreateChannelTx ./$BCM_CHANNEL_NAME.tx -channelID $BCM_CHANNEL_NAME

echo "#######    Generating anchor peer update for BrokerMSP  ##########"
configtxgen -profile BCM_Channel -configPath . -outputAnchorPeersUpdate ./BrokerMSPanchors_BCM.tx -channelID $BCM_CHANNEL_NAME -asOrg BrokerMSP

echo "#######    Generating anchor peer update for CerealistMSP  ##########"
configtxgen -profile BCM_Channel -configPath . -outputAnchorPeersUpdate ./CerealistMSPanchors_BCM.tx -channelID $BCM_CHANNEL_NAME -asOrg CerealistMSP

echo "#######    Generating anchor peer update for MillsMSP  ##########"
configtxgen -profile BCM_Channel -configPath . -outputAnchorPeersUpdate ./MillsMSPanchors_BCM.tx -channelID $BCM_CHANNEL_NAME -asOrg MillsMSP
