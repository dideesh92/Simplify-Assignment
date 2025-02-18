# simplyfi Task
Hyperledger Fabric network and Chaincode
ABAC-Based Asset Management System

A blockchain-based asset management system built on **Hyperledger Fabric** with **Attribute-Based Access Control (ABAC)** for secure and efficient asset handling.

---

## 📌 Overview
This project implements **Hyperledger Fabric** with **ABAC policies** to control access and permissions for different user roles. The system ensures secure asset creation, updates, deletion, and retrieval.

### 👥 User Roles
- **Admin**: Full asset management capabilities.
- **Auditor**: Complete asset visibility.
- **User**: Access to owned assets only.

---

## ⚙️ Key Features
✅ **ABAC-Based Access Control** - Attribute-based policies for precise permission management.
✅ **Role-Based Authorization** - Controlled access for different user types.
✅ **Asset Lifecycle Management** - Complete asset creation, modification, and tracking.
✅ **RESTful API Interface** - Easy integration with external applications.
✅ **Real-time Asset Updates** - Immediate reflection of asset changes.

---

## 📋 Prerequisites
Ensure you have the following installed:
- **Docker**
- **Node.js**
- **Hyperledger Fabric Binaries**
- **Postman** (for API testing)

---

## 🏗️ Architecture
This system leverages **Hyperledger Fabric**'s permissioned blockchain to provide a secure and controlled environment for asset management.

| Operation  | Admin | Auditor | User  |
|------------|:-----:|:-------:|:-----:|
| **Create** | ✅   | ❌    | ❌   |
| **Read All** | ✅   | ✅    | ❌   |
| **Read Own** | ✅   | ✅    | ✅   |
| **Update** | ✅   | ❌    | ❌   |
| **Delete** | ✅   | ❌    | ❌   |

---

## 🛠️ Installation & Setup
### 🔹 Clone the Repository
```sh
git clone https://github.com/dideesh92/Simplify-Assignment.git
cd task-Simplify-Assignment
```

### 🔹 Set Up Network
```sh
cd Network
chmod +x startNetwork.sh
./startNetwork.sh
```

### 🔹 Configure Client
```sh
cd ../Client
npm install
node importIdentity.js
```

### 🔹 Start Server
```sh
cd Server
npm install
node index.js
```

---

## 🛠️ Troubleshooting
### 🔹 Network Issues
```sh
# Check running Docker containers
docker ps -a

# Restart network
./stopNetwork.sh && ./startNetwork.sh
```

### 🔹 Identity Issues
```sh
# Reimport identities
cd Client
node importIdentity.js

# Check Certificate Authority (CA) identities
fabric-ca-client identity list --tls.certfiles organizations/fabric-ca/organization1/ca-cert.pem
```

---

## 📜 License
This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

---

## 🎉 Acknowledgments
Special thanks to:
- **Hyperledger Fabric Community**
- **Node.js Community**
- **Docker Team**
