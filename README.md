# mono-docker-config
Docker image for running ServiceStack on docker container using mono

#Create Ubuntu Virtual Machine On Azure

Login to Microsoft Azure and click on `Add` button in `Virtual Machines` pane

![Deploy](https://github.com/ServiceStackApps/mono-server-config/blob/master/images/0-create-azure-1.png)

In new opened pane type `Ubuntu Server` in filter string then select `Ubuntu Server 14.04 LTS` and click button `Create`

![Deploy](https://github.com/ServiceStackApps/mono-server-config/blob/master/images/0-create-azure-2.png)

To see the rest of the creation process follow the link [Create Ubuntu Virtual Machine On Azure](https://github.com/ServiceStackApps/mono-server-config/blob/master/azurevm.md)


#Run Docker Image

Login to your virtual machine using ssh or putty.  

##Install Docker

To install docker you need to run following command:

    curl -fsSL https://get.docker.com/ | sh

##Run Docker

Place your application into `/var/www/hello-app` and then run docker image

    sudo docker run -d -p 80:80 \
         -e USERSITE=www.yourdomain.com \
         -e USERLOCATION=/var/www/hello-app \
         -v /var/www:/var/www \
         servicestack/hyperfastcgi

Where

- `USERSITE` - Domain name of the site you will run, for example `www.yourdomain.com`
- `USERLOCATION` - Directory where applications is located

After executing the command you will get container ID. 

To stop docker container you can run:

    sudo docker stop <container ID>

### Alternative way. Build docker image from sources

    sudo apt-get install git
    git clone https://github.com/ServiceStackApps/mono-docker-config
    cd mono-docker-config
    sudo docker build .
    
Now you have got docker image which is ready to run. Remember ID of docker image. Place your application into `/var/www/hello-app` and run the command 
    
    sudo docker run -d -p 80:80 \
         -e USERSITE=www.yourdomain.com \
         -e USERLOCATION=/var/www/hello-app \
         -v /var/www:/var/www \
         92627a6cbee6

Where 

- `USERSITE` - Domain name of the site you will run, for example `www.yourdomain.com`
- `USERLOCATION` - Directory where applications is located
- `92627a6cbee6` - Docker image ID created on the previous step
