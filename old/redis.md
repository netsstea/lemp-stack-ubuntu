# How to install Redis on ubuntu 16.04

**Last update**: 7/4/2017, tested on Ubuntu 16.04

1. [Install Essential libraries](#install-essential-library)
2. [Install Jenkins](#install-jenkins)
    1. [Setting up Jenkins](#setting-up-jenkins)


### #Install Essential Libraries
```sh
sudo apt-get update
sudo apt-get install build-essential tcl
```

### #Install Redis
Download, Compile, and Install Redis
Next, we can begin to build Redis.
```sh
cd /tmp
```
Now, download the latest stable version of Redis. This is always available at a stable download URL:
```sh
wget -O http://download.redis.io/redis-stable.tar.gz
```
Unpack the tarball by typing:
```sh
tar xzvf redis-stable.tar.gz
```
Move into the Redis source directory structure that was just extracted:

```sh
cd redis-stable
```

#### Build and Install Redis

Now, we can compile the Redis binaries by typing:
```sh
make && sudo make install
```

#### Configure Redis
Now that Redis is installed, we can begin to configure it.

To start off, we need to create a configuration directory. We will use the conventional `/etc/redis directory`, which can be created by typing:
```sh
sudo mkdir /etc/redis
```
Now, copy over the sample Redis configuration file included in the Redis source archive:

```sh
sudo cp /tmp/redis-stable/redis.conf /etc/redis
```
Next, we can open the file to adjust a few items in the configuration:
```sh
sudo vim /etc/redis/redis.conf
```
In the file, find the supervised directive. Currently, this is set to no. Since we are running an operating system that uses the systemd init system, we can change this to systemd:

```sh
/etc/redis/redis.conf
. . .

# If you run Redis from upstart or systemd, Redis can interact with your
# supervision tree. Options:
#   supervised no      - no supervision interaction
#   supervised upstart - signal upstart by putting Redis into SIGSTOP mode
#   supervised systemd - signal systemd by writing READY=1 to $NOTIFY_SOCKET
#   supervised auto    - detect upstart or systemd method based on
#                        UPSTART_JOB or NOTIFY_SOCKET environment variables
# Note: these supervision methods only signal "process is ready."
#       They do not enable continuous liveness pings back to your supervisor.
supervised systemd

. . .
```
Next, find the dir directory. This option specifies the directory that Redis will use to dump persistent data. We need to pick a location that Redis will have write permission and that isn't viewable by normal users.

We will use the /var/lib/redis directory for this, which we will create in a moment:
```sh
/etc/redis/redis.conf
. . .

# The working directory.
#
# The DB will be written inside this directory, with the filename specified
# above using the 'dbfilename' configuration directive.
#
# The Append Only File will also be created inside this directory.
#
# Note that you must specify a directory here, not a file name.
dir /var/lib/redis

. . .
```
Save and close the file when you are finished.

Create a Redis systemd Unit File
Next, we can create a systemd unit file so that the init system can manage the Redis process.

Create and open the `/etc/systemd/system/redis.service` file to get started:
```sh
sudo vim /etc/systemd/system/redis.service
```
Inside, we can begin the [Unit] section by adding a description and defining a requirement that networking be available before starting this service:

`/etc/systemd/system/redis.service`
```sh
[Unit]
Description=Redis In-Memory Data Store
After=network.target
```
In the [Service] section, we need to specify the service's behavior. For security purposes, we should not run our service as root. We should use a dedicated user and group, which we will call redis for simplicity. We will create these momentarily.

To start the service, we just need to call the redis-server binary, pointed at our configuration. To stop it, we can use the Redis shutdown command, which can be executed with the redis-cli binary. Also, since we want Redis to recover from failures when possible, we will set the Restart directive to "always":

`/etc/systemd/system/redis.service`
```sh
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always
```
Finally, in the [Install] section, we can define the systemd target that the service should attach to if enabled (configured to start at boot):

`/etc/systemd/system/redis.service`
```sh
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
```

Save and close the file when you are finished.

Create the Redis User, Group and Directories
Now, we just have to create the user, group, and directory that we referenced in the previous two files.

Begin by creating the redis user and group. This can be done in a single command by typing:
```sh
sudo adduser --system --group --no-create-home redis
```
Now, we can create the `/var/lib/redis` directory by typing:

```sh
sudo mkdir /var/lib/redis
```
We should give the redis user and group ownership over this directory:

`sudo chown redis:redis /var/lib/redis`
Adjust the permissions so that regular users cannot access this location:

```sh
sudo chmod 770 /var/lib/redis
```
Start and Test Redis
Now, we are ready to start the Redis server.

Start the Redis Service

Start up the systemd service by typing:
```sh
sudo systemctl start redis
```
Check that the service had no errors by running:

`sudo systemctl status redis`
You should see something that looks like this:
Output
```sh
● redis.service - Redis Server
   Loaded: loaded (/etc/systemd/system/redis.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2016-05-11 14:38:08 EDT; 1min 43s ago
  Process: 3115 ExecStop=/usr/local/bin/redis-cli shutdown (code=exited, status=0/SUCCESS)
 Main PID: 3124 (redis-server)
    Tasks: 3 (limit: 512)
   Memory: 864.0K
      CPU: 179ms
   CGroup: /system.slice/redis.service
           └─3124 /usr/local/bin/redis-server 127.0.0.1:6379       

. . .
```
Test the Redis Instance Functionality

To test that your service is functioning correctly, connect to the Redis server with the command-line client:
```sh
redis-cli
```
In the prompt that follows, test connectivity by typing:
```sh
ping
```
You should see:
```sh
Output
PONG
```
Check that you can set keys by typing:

```sh
set test "It's working!"
```

Output
```sh
OK
```
Now, retrieve the value by typing:

```sh
get test
```
You should be able to retrieve the value we stored:

Output
```sh
"It's working!"
```
Exit the Redis prompt to get back to the shell:

```sh
exit
```
As a final test, let's restart the Redis instance:

```sh
sudo systemctl restart redis
```
Now, connect with the client again and confirm that your test value is still available:
```sh
redis-cli
get test
```
The value of your key should still be accessible:

Output
```sh
"It's working!"
```
Back out into the shell again when you are finished:

```sh
exit
```
Enable Redis to Start at Boot

If all of your tests worked, and you would like to start Redis automatically when your server boots, you can enable the systemd service.

To do so, type:
```sh
sudo systemctl enable redis
```