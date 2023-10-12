createcertificatesForBroker() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/broker.example.com/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.broker.example.com --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-broker-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-broker-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-broker-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-broker-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.broker.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.broker.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.broker.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.broker.example.com --id.name brokeradmin --id.secret brokeradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/msp --csr.hosts peer0.broker.example.com --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls --enrollment.profile tls --csr.hosts peer0.broker.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/broker.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/tlsca/tlsca.broker.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/broker.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer0.broker.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/ca/ca.broker.example.com-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/users/User1@broker.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/users/User1@broker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://brokeradmin:brokeradminpw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp/config.yaml

  #  Peer 1
  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/msp --csr.hosts peer1.broker.example.com --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls --enrollment.profile tls --csr.hosts peer1.broker.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/broker.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/tlsca/tlsca.broker.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/broker.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/peers/peer1.broker.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/broker.example.com/ca/ca.broker.example.com-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/users/User1@broker.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/users/User1@broker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://brokeradmin:brokeradminpw@localhost:7054 --caname ca.broker.example.com -M ${PWD}/../crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/broker/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/broker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/broker.example.com/users/Admin@broker.example.com/msp/config.yaml


}

# createcertificatesForBroker

createCertificatesForFarmer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/farmer.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/farmer.example.com/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.farmer.example.com --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.farmer.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.farmer.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.farmer.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.farmer.example.com --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/msp --csr.hosts peer0.farmer.example.com --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls --enrollment.profile tls --csr.hosts peer0.farmer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca/tlsca.farmer.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca/ca.farmer.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp/config.yaml

  # Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/msp --csr.hosts peer1.farmer.example.com --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls --enrollment.profile tls --csr.hosts peer1.farmer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca/tlsca.farmer.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca/ca.farmer.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp/config.yaml


}

# createCertificateForFarmer

createCertificatesForCerealist() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.cerealist.example.com --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-cerealist-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-cerealist-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-cerealist-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-cerealist-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.cerealist.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.cerealist.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.cerealist.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.cerealist.example.com --id.name cerealistadmin --id.secret cerealistadminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/msp --csr.hosts peer0.cerealist.example.com --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls --enrollment.profile tls --csr.hosts peer0.cerealist.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/tlsca/tlsca.cerealist.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer0.cerealist.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/ca/ca.cerealist.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/users/User1@cerealist.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/users/User1@cerealist.example.com/msp --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://cerealistadmin:cerealistadminpw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com/msp --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com/msp/config.yaml

  # Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/msp --csr.hosts peer1.cerealist.example.com --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls --enrollment.profile tls --csr.hosts peer1.cerealist.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/tlsca/tlsca.cerealist.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/peers/peer1.cerealist.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/ca/ca.cerealist.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/users/User1@cerealist.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/users/User1@cerealist.example.com/msp --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://cerealistadmin:cerealistadminpw@localhost:10054 --caname ca.cerealist.example.com -M ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com/msp --tls.certfiles ${PWD}/fabric-ca/cerealist/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/cerealist.example.com/users/Admin@cerealist.example.com/msp/config.yaml



}

# createCertificateForCerealist

createCertificatesForMills() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/mills.example.com/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca.mills.example.com --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mills-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mills-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mills-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-mills-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.mills.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.mills.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.mills.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.mills.example.com --id.name org4admin --id.secret org4adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/msp --csr.hosts peer0.mills.example.com --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls --enrollment.profile tls --csr.hosts peer0.mills.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/mills.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/tlsca/tlsca.mills.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/mills.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer0.mills.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/ca/ca.mills.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/users/User1@mills.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/users/User1@mills.example.com/msp --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://org4admin:org4adminpw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp/config.yaml

  # Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/msp --csr.hosts peer1.mills.example.com --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls --enrollment.profile tls --csr.hosts peer1.mills.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/mills.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/tlsca/tlsca.mills.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/mills.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/peers/peer1.mills.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/mills.example.com/ca/ca.mills.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/users/User1@mills.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/users/User1@mills.example.com/msp --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://org4admin:org4adminpw@localhost:11054 --caname ca.mills.example.com -M ${PWD}/../crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp --tls.certfiles ${PWD}/fabric-ca/mills/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/mills.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/mills.example.com/users/Admin@mills.example.com/msp/config.yaml

}

# createCertificateForMills

createCertificatesForBaker() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/Baker.example.com/


  fabric-ca-client enroll -u https://admin:adminpw@localhost:12054 --caname ca.Baker.example.com --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-Baker-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-Baker-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-Baker-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-Baker-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.Baker.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.Baker.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.Baker.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.Baker.example.com --id.name org5admin --id.secret org5adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/msp --csr.hosts peer0.Baker.example.com --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls --enrollment.profile tls --csr.hosts peer0.Baker.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/tlsca/tlsca.Baker.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer0.Baker.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/ca/ca.Baker.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/users/User1@Baker.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/users/User1@Baker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/users/Admin@Baker.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://org5admin:org5adminpw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/users/Admin@Baker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/users/Admin@Baker.example.com/msp/config.yaml

  # Peer 1
  echo
  echo "## Generate the peer1 msp"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/msp --csr.hosts peer1.Baker.example.com --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo

  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls --enrollment.profile tls --csr.hosts peer1.Baker.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/tlsca/tlsca.Baker.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/peers/peer1.Baker.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/ca/ca.Baker.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/users/User1@Baker.example.com

  echo
  echo "## Generate the user msp"
  echo

  fabric-ca-client enroll -u https://user1:user1pw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/users/User1@Baker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  mkdir -p ../crypto-config/peerOrganizations/Baker.example.com/users/Admin@Baker.example.com

  echo
  echo "## Generate the org admin msp"
  echo

  fabric-ca-client enroll -u https://org5admin:org5adminpw@localhost:12054 --caname ca.Baker.example.com -M ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/users/Admin@Baker.example.com/msp --tls.certfiles ${PWD}/fabric-ca/Baker/tls-cert.pem


  cp ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/Baker.example.com/users/Admin@Baker.example.com/msp/config.yaml



}

createCretificatesForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/example.com


  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  echo
  echo "Register orderer2"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  echo
  echo "Register orderer3"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/example.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/example.com/users
  mkdir -p ../crypto-config/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem


  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

# createCretificateForOrderer

sudo rm -rf ../crypto-config/*
# sudo rm -rf fabric-ca/*
createcertificatesForBroker
createCertificatesForFarmer
createCertificatesForCerealist
createCertificatesForMills
createCertificatesForBaker

createCretificatesForOrderer

