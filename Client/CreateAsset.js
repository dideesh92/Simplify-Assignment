const ClientApplication = require('./client');

let userClient = new ClientApplication();
userClient.submitTxn(
    "org1admin",
    "orgchannel",
    "Asset",
    "CreateAsset",
    "Asset-100",
    "org1user",
    "4000"
).then(result => {
    console.log(new TextDecoder().decode(result));
    console.log(" Asset successfully created");
}).catch(error => {
    console.error(" Failed to submit transaction:", error);
});
