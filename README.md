docker-machine-builder
======================

Virtual machine builder based on Docker Toolbox

Supported OS: mac OS

Usage
-----

1.  Install [Docker Toolbox](https://www.docker.com/products/docker-toolbox) and [VirtualBox](https://www.virtualbox.org/).

2.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/docker-machine-builder.git
    $ cd ~/docker-machine-builder
    ```

3.  Create a virtual machine.

    ```sh
    $ ./create_docker_machine.sh --run
    ```

    Run './create_docker_machine.sh --help' for information of options.

4.  Run a container.

    ```sh
    $ eval $(docker-machine env)
    $ docker-compose up -d
    ```
