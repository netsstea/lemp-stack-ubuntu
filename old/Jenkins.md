# How to install Jenkins on ubuntu 16.04

**Last update**: 7/4/2017, tested on Ubuntu 16.04

1. [Install Essential libraries](#install-essential-library)
2. [Install Jenkins](#install-jenkins)
    1. [Setting up Jenkins](#setting-up-jenkins)


### #Install Essential Libraries

Jenkins require java 8 (please verify java version after you have installed successfully java with commands below)

```sh
sudo apt-get update
sudo apt-get install build-essential
sudo apt-get install python-software-properties 
sudo apt-get install openjdk-8*
```

### #Install Jenkins

```sh
wget --no-check-certificate -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
```
Create jenkins pkg source

```sh
sudo vim /etc/apt/sources.list.d/jenkins.list
```
put source content
```sh
deb http://pkg.jenkins.io/debian-stable binary/
```
And then update source list and install jenkins
```sh
sudo apt-get update
sudo apt-get install jenkins
```

The above commands, along with installing Jenkins, also creates a user with the name `jenkins` which executes the automated services, launches Jenkins service as a daemon up on start.

Now Jenkins server is listening on port 8080and it can accessed through <server IP>:8080. If you want to change the port number to which Jenkins is listening, edit the `/etc/default/jenkins` to replace the line `HTTP_PORT=8080` to `HTTP_PORT=<preferred port number>`

#### Setting Jenkins
There are a few steps to follow for setting up Jenkins for the first time. Access the Jenkins server url from your favourite browser(read as chrome) and you will be asked to provide an admin password to unlock Jenkins and this password can be found in the following location, to quickly get password use this command

```sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Once you provide the password, you will asked to create the first admin user

After the admin creation, Jenkins will prompt you to install the plugins. You can either opt to install suggested plugins or select the list of plugins you need to be installed

Once the plugins are installed, we are all set to create a new Job in Jenkins.
