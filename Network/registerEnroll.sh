#!/bin/bash

function createOrg1() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org1.office.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.office.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-org1 --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/org1.office.com/msp/config.yaml"

  # Copy org1's CA Certs
  mkdir -p "${PWD}/organizations/peerOrganizations/org1.office.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/org1.office.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/org1.office.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/org1.office.com/tlsca/tlsca.org1.office.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/org1.office.com/ca"
  cp "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" "${PWD}/organizations/peerOrganizations/org1.office.com/ca/ca.org1.office.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-org1 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

 echo "Registering a Regular User in Org1"

fabric-ca-client register --caname ca-org1 --id.name org1user --id.secret org1userpw  --id.type client  --id.attrs "role=user:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"

echo "Registering the Org1 Auditor"
fabric-ca-client register --caname ca-org1 --id.name org1auditor --id.secret org1auditorpw --id.type client --id.attrs "role=auditor:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
{ set +x; } 2>/dev/null

 echo "Registering the Org1 Admin"
fabric-ca-client register --caname ca-org1 --id.name org1admin --id.secret org1adminpw --id.type admin --id.attrs "role=admin:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"


{ set +x; } 2>/dev/null


  # Enroll peer0
  echo "Generating the peer0 MSP"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/msp/config.yaml"

  # Generate TLS certificates for peer0
  echo "Generating the peer0 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 \
    --caname ca-org1 \
    -M "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.org1.office.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/server.key"

  # Enroll peer1
  echo "Generating the peer1 MSP"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/msp/config.yaml"

  # Generate TLS certificates for peer1
  echo "Generating the peer1 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-org1 -M "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/tls" --enrollment.profile tls --csr.hosts peer1.org1.office.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/org1.office.com/peers/peer1.org1.office.com/tls/server.key"

  # Enroll user1
      echo "Enrolling a Regular User in Org1"
   fabric-ca-client enroll -u https://org1user:org1userpw@localhost:7054  --caname ca-org1 --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/org1.office.com/users/User@org1.office.com/msp"  --enrollment.attrs "role"

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/org1.office.com/users/User@org1.office.com/msp/"
  # Enroll auditor
     echo "Enrolling the Org1 Auditor"
      set -x
fabric-ca-client enroll -u https://org1auditor:org1auditorpw@localhost:7054 --caname ca-org1 --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" --mspdir "${PWD}/organizations/peerOrganizations/org1.office.com/users/Auditor@org1.office.com/msp" --enrollment.attrs "role"
   { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org1.office.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/org1.office.com/users/Auditor@org1.office.com/msp/"
  
  # Enroll org admin
    echo "Enrolling the Org1 Admin"
      set -x
fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca-org1 --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem" --mspdir "${PWD}/organizations/peerOrganizations/org1.office.com/users/Admin@org1.office.com/msp" --enrollment.attrs "role"     
 { set +x; } 2>/dev/null

 cp "${PWD}/organizations/peerOrganizations/org1.office.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/org1.office.com/users/Admin@org1.office.com/msp/"

}

function createOrg2() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/org2.office.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.office.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-org2 --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-org2.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/org2.office.com/msp/config.yaml"

  # Copy org2's CA Certs
  mkdir -p "${PWD}/organizations/peerOrganizations/org2.office.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/org2.office.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/org2.office.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/org2.office.com/tlsca/tlsca.org2.office.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/org2.office.com/ca"
  cp "${PWD}/organizations/fabric-ca/org2/ca-cert.pem" "${PWD}/organizations/peerOrganizations/org2.office.com/ca/ca.org2.office.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-org2 --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

    echo "Registering a Regular User in Org2"
        set -x
        fabric-ca-client register --caname ca-org2  --id.name org2user --id.secret org2userpw --id.type client   --id.attrs "role=user:ecert"  --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
        { set +x; } 2>/dev/null  

    echo "Registering the Org2 Auditor"
    set -x 
    fabric-ca-client register --caname ca-org2 --id.name org2auditor  --id.secret org2auditorpw  --id.type client --id.attrs "role=auditor:ecert" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
    { set +x; } 2>/dev/null

    echo "Registering the Org2 Admin"
      set -x 
      fabric-ca-client register --caname ca-org2  --id.name org2admin --id.secret org2adminpw  --id.type admin  --id.attrs "role=admin:ecert"  --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
    { set +x; } 2>/dev/null




  # Enroll peer0
  echo "Generating the peer0 MSP"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/msp/config.yaml"

  # Generate TLS certificates for peer0
  echo "Generating the peer0 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 \
    --caname ca-org2 \
    -M "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.org2.office.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer0.org2.office.com/tls/server.key"

  # Enroll peer1
  echo "Generating the peer1 MSP"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/msp/config.yaml"

  # Generate TLS certificates for peer1
  echo "Generating the peer1 TLS certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-org2 -M "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/tls" --enrollment.profile tls --csr.hosts peer1.org2.office.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/tls/tlscacerts/"* \
     "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/tls/ca.crt"

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/tls/signcerts/"* \
     "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/tls/server.crt"

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/tls/keystore/"* \
     "${PWD}/organizations/peerOrganizations/org2.office.com/peers/peer1.org2.office.com/tls/server.key"

  # Enroll user1
      echo "Enrolling a Regular User in Org2"
    set -x
fabric-ca-client enroll -u https://org2user:org2userpw@localhost:8054  --caname ca-org2  --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/org2.office.com/users/User@org2.office.com/msp"

   { set +x; } 2>/dev/null

     cp "${PWD}/organizations/peerOrganizations/org2.office.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/org2.office.com/users/User@org2.office.com/msp/"

  # Enroll auditor
     echo "Enrolling the Org2 Auditor"
      set -x
fabric-ca-client enroll -u https://org2auditor:org2auditorpw@localhost:8054  --caname ca-org2  --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/org2.office.com/users/Auditor@org2.office.com/msp" 
  
   cp "${PWD}/organizations/peerOrganizations/org2.office.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/org2.office.com/users/Auditor@org2.office.com/msp/"
 
  # Enroll org admin
    echo "Enrolling the Org2 Admin"
      set -x
fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054  --caname ca-org2  --tls.certfiles "${PWD}/organizations/fabric-ca/org2/ca-cert.pem"  --mspdir "${PWD}/organizations/peerOrganizations/org2.office.com/users/Admin@org2.office.com/msp" 

  cp "${PWD}/organizations/peerOrganizations/org2.office.com/msp/config.yaml" \
     "${PWD}/organizations/peerOrganizations/org2.office.com/users/Admin@org2.office.com/msp/"
}






function createOrderer() {
  echo "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/office.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/office.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

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
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/office.com/msp/config.yaml"


  # Copy orderer org's CA cert to orderer org's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/office.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/office.com/msp/tlscacerts/tlsca.office.com-cert.pem"

  # Copy orderer org's CA cert to orderer org's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/ordererOrganizations/office.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/office.com/tlsca/tlsca.office.com-cert.pem"

  echo "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the orderer msp"
  set -x
fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/office.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/msp/config.yaml"

  echo "Generating the orderer-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls" --enrollment.profile tls --csr.hosts orderer.office.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
  cp "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls/server.key"

  # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/office.com/orderers/orderer.office.com/msp/tlscacerts/tlsca.office.com-cert.pem"

  echo "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/office.com/users/Admin@office.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/office.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/office.com/users/Admin@office.com/msp/config.yaml"
}

createOrg1
createOrg2

createOrderer
