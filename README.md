# puppet-control-repo
Puppet control repository


# Development using Docker

    # Repository directory
    cd ~/desktop/puppet/ 
    
    # Build docker images
    docker build -t puppet-ubuntu:16.04 -f ./docker/docker-files/DockerFile-Ubuntu-16.04.dockerfile .
    
    # Start container
    docker-compose.exe --file ./docker/docker-compose-files/all-in-one.yaml up
    
    # Log into container and apply puppet
    docker exec -it allinone.dev.vm bash
    /opt/puppet/puppet.sh