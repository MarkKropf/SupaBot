# SupaBot

A Bot to do all things for its master based in Ruby
## Requirements
Nodes need to know what time it is... UTC

### Config File
Seed Node IP: 10.9.0.1
Seed Node Port: 443
Preshared Key: ASDGASET@Q$T
Version: 0.007
Default Route for Bot Comm: /CherBot/

### Node Communication
The node communication protocol is the method that all of the bots sync up their directory data over REST. There is no backend service required or any other processes outside of ruby required to make this function.

#### Joining the network
Each node attempts to connect to the seed node with information provided in its config file. A preshared key is currently used to ensure rogue nodes without the key can not join.

Upon connection with the Seed Node, the new node receives an entire copy of the directory. The seed node does not have to be the first node, but instead any node that has had a chance to sync up with a majority of other nodes data.

#### Directory Definition
GUID
PARENTGUID
Name
Type
[[Botlet Specifc Config]]
-- Connection Details
-- All kinds of goofy things based on the bot

HASH: A hash of all columns
PriorHASH: The has of the prior version
Updated Time: Time of last update

##### Node Specific
Node Created on: 10/10/10
At least one mode of comm
Possible comm channels are: BotComm, IRC, Twitter, e-mail, sms, facebook, etc

#### Global Config
Default Refresh Times
Preshared Key

#### Update the Network Shizzle
The network sync returns a list of hashes + guids to be compared
Based on Type
.. Node Definition: 5m or via sync request
.. Assets: 60m (who cares, right, I mean really?)
.. Global Config: 10m or via sync request
.. Comm Protocol Specific Time Adds/Subtracts

### Conflict Resolution (Low Priority) (Zach to re-invent vector clocks)
1. Updated Time
3. Prior Hash
2. Node Created Date
3. Kill all nodes