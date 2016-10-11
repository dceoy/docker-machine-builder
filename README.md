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

    ```sh
    $ ./create_docker_machine.sh --help
    Usage:  ./create_docker_machine.sh [options]
            ./create_docker_machine.sh [ -h | --help | -v | --version ]

    Description:
      Create a virtual machine for Docker Machine.

    Options:
      -h, --help          Print usage
      -v, --version       Print version information and quit
      --name 'default'    Set the machine name
      --disk '200000'     Set the size of disk for host in MB [$VIRTUALBOX_DISK_SIZE]
      --cpus '1'          Set the number of CPUs for the machine [$VIRTUALBOX_CPU_COUNT]
      --memory '1024'     Set the size of memory for host in MB [$VIRTUALBOX_MEMORY_SIZE]
      --run               Run the virtual machine after setup
      --bridge            Enable bridged networking
    ```

4.  Run a container.

    ```sh
    $ eval $(docker-machine env)
    $ docker-compose up -d
    ```
