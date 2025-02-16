let profile = {

    org1admin: {
        "cryptoPath": "../Network/organizations/peerOrganizations/org1.office.com",
        "keyDirectoryPath": "../Network/organizations/peerOrganizations/org1.office.com/users/Admin@org1.office.com/msp/keystore/",
        "certPath": "../Network/organizations/peerOrganizations/org1.office.com/users/Admin@org1.office.com/msp/signcerts/cert.pem",
        "tlsCertPath": "../Network/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/ca.crt",
        "peerEndpoint": "localhost:7051",
        "peerHostAlias": "peer0.org1.office.com",
        "mspId": "org1-office-com"
    },
    org1auditor: {
        "cryptoPath": "../Network/organizations/peerOrganizations/org1.office.com",
        "keyDirectoryPath": "../Network/organizations/peerOrganizations/org1.office.com/users/Auditor@org1.office.com/msp/keystore/",
        "certPath": "../Network/organizations/peerOrganizations/org1.office.com/users/Auditor@org1.office.com/msp/signcerts/cert.pem",
        "tlsCertPath": "../Network/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/ca.crt",
        "peerEndpoint": "localhost:7051",
        "peerHostAlias": "peer0.org1.office.com",
        "mspId": "org1-office-com"
    },
    org1user: {
        "cryptoPath": "../Network/organizations/peerOrganizations/org1.office.com",
        "keyDirectoryPath": "../Network/organizations/peerOrganizations/org1.office.com/User/User@org1.office.com/msp/keystore/",
        "certPath": "../Network/organizations/peerOrganizations/org1.office.com/users/User@org1.office.com/msp/signcerts/cert.pem",
        "tlsCertPath": "../Network/organizations/peerOrganizations/org1.office.com/peers/peer0.org1.office.com/tls/ca.crt",
        "peerEndpoint": "localhost:7051",
        "peerHostAlias": "peer0.org1.office.com",
        "mspId": "org1-office-com"
    }
};

module.exports = { profile };
