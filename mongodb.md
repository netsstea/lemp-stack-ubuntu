# How to install MongoDB on ubuntu 16.04

**Last update**: 7/4/2017, tested on Ubuntu 16.04

1. [Install Essential libraries](#install-essential-library)
2. [Install Jenkins](#install-jenkins)
    1. [Setting up Jenkins](#setting-up-jenkins)


### #Install Essential Libraries
```sh
sudo apt-get update
sudo apt-get install build-essential tcl
```

### #Install MongoDB

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod
sudo systemctl enable mongod
```

### Sercuring MongoDB

#### Step 1 — Adding an Administrative User
To add our user, we'll connect to the Mongo shell:
```sh
mongo
```
The output when we use the Mongo shell warns us that access control is not enabled for the database and that read/write access to data and configuration is unrestricted.

Output
```sh
MongoDB shell version v3.4.2
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.2
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
        http://docs.mongodb.org/
Questions? Try the support group
        http://groups.google.com/group/mongodb-user
Server has startup warnings:
2017-02-21T19:10:42.446+0000 I STORAGE  [initandlisten]
2017-02-21T19:10:42.446+0000 I STORAGE  [initandlisten] ** WARNING: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine
2017-02-21T19:10:42.446+0000 I STORAGE  [initandlisten] **          See http://dochub.mongodb.org/core/prodnotes-filesystem
2017-02-21T19:10:42.534+0000 I CONTROL  [initandlisten]
2017-02-21T19:10:42.534+0000 I CONTROL  [initandlisten] ** WARNING: Access control is not enabled for the database.
2017-02-21T19:10:42.534+0000 I CONTROL  [initandlisten] **          Read and write access to data and configuration is unrestricted.
2017-02-21T19:10:42.534+0000 I CONTROL  [initandlisten]
>
```

We're free to choose the name for the administrative user since the privilege level comes from the assignment of the role userAdminAnyDatabase. The database, admin designates where the credentials are stored. You can learn more about authentication in the MongoDB Security Authentication section.

Set the username of your choice and be sure to pick your own secure password and substitute them in the command below:
```sh
use admin
db.createUser(
  {
    user: "AdminDemon",
    pwd: "AdminDemon'sSecurePassword",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)
```
When we issue the db.createUser command, the shell will prepend three dots before each line until the command is complete. After that, we should receive feedback like the following when the user has been added.

Output
```sh
> use admin
```
switched to db admin
```sh
> db.createUser(
    {
        user: "AdminDemon",
        pwd: "AdminDemon'sSecurePassword",
        roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
    }
)

Successfully added user: {
        "user" : "AdminDemon",
        "roles" : [
                {
                        "role" : "userAdminAnyDatabase",
                        "db" : "admin"
                }
        ]
}
```
Type 'exit' and press ENTER or use CTRL+C to leave the client.

At this point, our user will be allowed to enter credentials, but they will not be required to do so until we enable authentication and restart the MongoDB daemon.

#### Step 2 — Enabling Authentication
Authentication is enabled in the mongod.conf file. Once we enable it and restart mongod, users still will be able to connect to Mongo without authenticating, but they will be required to provide a username and password before they can interact.

Let's open the configuration file:
```sh
sudo vim /etc/mongod.conf
```
In the #security section, we'll remove the hash in front of security to enable the stanza. Then we'll add the authorization setting. When we're done, the lines should look like the excerpt below:
`mongodb.conf`
```sh
 . . .
security:
  authorization: "enabled"
 . . . 
 ```
Note that the “security” line has no spaces at the beginning, and the “authorization” line must be indented with two spaces

Once we've saved and exited the file, we'll restart the daemon:
```sh
sudo systemctl restart mongod
```
If we've made an error in the configuration, the dameon won't start. Since systemctl doesn't provide output, we'll use its status option to be sure that it did:.

```sh
sudo systemctl status mongod
```
If we see Active: active (running) in the output and it ends with something like the text below, we can be sure the restart command was successful:

Output
```sh
Jan 23 19:15:42 MongoHost systemd[1]: Started High-performance, schema-free document-oriented database.
Having verified the daemon is up, let's test authentication.
```
#### Step 3 — Verifying that Unauthenticated Users are Restricted
First, let's connect without credentials to verify that our actions are restricted:
```sh
mongo 
```
Now that we've enabled authentication, all of the earlier warnings are resolved.

Output
```sh
MongoDB shell version v3.4.2
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.2
```
We're connected to the test database. We'll test that our access is restricted with the show dbs command:

```sh
show dbs
```
Output
```sh
2017-02-21T19:20:42.919+0000 E QUERY    [thread1] Error: listDatabases failed:{
        "ok" : 0,
        "errmsg" : "not authorized on admin to execute command { listDatabases: 1.0 }",
        "code" : 13,
        "codeName" : "Unauthorized"
 . . . 
 ```
We wouldn't be able to create users or similarily privileged tasks without authenticating.

Let's exit the shell to proceed:
```sh
exit
```
Next, we'll make sure our Administrative user does have access.

#### Step 4 — Verifying the Administrative User's Access
We'll connect as our administrator with the -u option to supply a username and -p to be prompted for a password. We will also need to supply the database where we stored the user's authentication credentials with the --authenticationDatabase option.
```sh
mongo -u AdminDemon -p --authenticationDatabase admin
```
We'll be prompted for the password, so supply it. Once we enter the correct password, we'll be dropped into the shell, where we can issue the show dbs command:

Output
```sh
MongoDB shell version v3.4.2
Enter password:
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.4.2

>
```
Rather than being denied access, we should see the available databases:
```sh
show dbs
```
Output
```sh
admin  0.000GB
local  0.000GB
```
Type `exit` or press `CTRL+C` to exit.