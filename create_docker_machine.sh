#!/usr/bin/env bash
#
# Usage:  ./create_docker_machine.sh [options]
#         ./create_docker_machine.sh [ -h | --help | -v | --version ]
#
# Description:
#   Create a virtual machine using for Docker Machine.
#
# Options:
#   -h, --help          Print usage
#   -v, --version       Print version information and quit
#   --name 'default'    Set the machine name (default: default)
#   --disk '200000'     Set the size of disk for host in MB [$VIRTUALBOX_DISK_SIZE]
#   --cpus '1'          Set the number of CPUs for the machine [$VIRTUALBOX_CPU_COUNT]
#   --memory '1024'     Set the size of memory for host in MB [$VIRTUALBOX_MEMORY_SIZE]
#   --run               Run the virtual machine after setup
#   --bridge            Enable bridged networking

set -e

[[ "${1}" = '--debug' ]] \
  && set -x \
  && shift 1

SCRIPT_NAME='create_docker_machine.sh'
SCRIPT_VERSION='1.0.0'

VM_NAME='default'
VM_BRIDGED=0
VM_RUN=0

[[ -n "${VIRTUALBOX_DISK_SIZE}" ]] || VIRTUALBOX_DISK_SIZE=20000
[[ -n "${VIRTUALBOX_CPU_COUNT}" ]] || VIRTUALBOX_CPU_COUNT=1
[[ -n "${VIRTUALBOX_MEMORY_SIZE}" ]] || VIRTUALBOX_MEMORY_SIZE=1024
[[ -n "${VIRTUALBOX_BRIDGE_ADAPTER}" ]] || VIRTUALBOX_BRIDGE_ADAPTER=''
[[ -n "${VIRTUALBOX_BRIDGE_MAC}" ]] || VIRTUALBOX_BRIDGE_MAC=''

function print_version {
  echo "${SCRIPT_NAME}: ${SCRIPT_VERSION}"
}

function print_usage {
  sed -ne '
    1,2d
    /^#/!q
    s/^#$/# /
    s/^# //p
  ' ${SCRIPT_NAME}
}

function abort {
  echo "${SCRIPT_NAME}: ${*}" >&2
  exit 1
}

function validate_arg {
  [[ "${2}" =~ ^[^\-] ]] \
    && echo "${2}" \
    || abort "flag \`${1}\` needs an argument"
}

function validate_arg_int {
  arg_int="$(validate_arg ${1} ${2})"
  [[ "${arg_int}" =~ [0-9]+ ]] \
    && echo "${arg_int}" \
    || abort "flag \`${1}\` needs an integer argument"
}

while [[ -n "${1}" ]]; do
  case "${1}" in
    '-v' | '--version' )
      print_version && exit 0
      ;;
    '-h' | '--help' )
      print_usage && exit 0
      ;;
    '--name' )
      VM_NAME="$(validate_arg ${1} ${2})" && shift 2
      ;;
    '--disk' )
      VIRTUALBOX_DISK_SIZE="$(validate_arg_int ${1} ${2})" && shift 2
      ;;
    '--cpus' )
      VIRTUALBOX_CPU_COUNT="$(validate_arg_int ${1} ${2})" && shift 2
      ;;
    '--memory' )
      VIRTUALBOX_MEMORY_SIZE="$(validate_arg_int ${1} ${2})" && shift 2
      ;;
    '--run' )
      VM_RUN=1 && shift 1
      ;;
    '--bridge' )
      VM_BRIDGE=1 && shift 1
      ;;
    * )
      abort "invalid argument \`${1}\`"
      ;;
  esac
done

set -u
echo '[docker-machine version]' && docker-machine --version
echo '[VBoxManage version]' && VBoxManage --version
echo

docker-machine create \
  -d virtualbox \
  --virtualbox-disk-size ${VIRTUALBOX_DISK_SIZE} \
  --virtualbox-cpu-count ${VIRTUALBOX_CPU_COUNT} \
  --virtualbox-memory ${VIRTUALBOX_MEMORY_SIZE} \
  ${VM_NAME}

docker-machine env ${VM_NAME}
eval $(docker-machine env ${VM_NAME})
docker-machine ls
docker-machine stop ${VM_NAME}

if [[ ${VM_BRIDGE} -eq 1 ]]; then
  VBoxManage modifyvm ${VM_NAME} \
    --nic3 bridged \
    --cableconnected3 on
  [[ "${VIRTUALBOX_BRIDGE_ADAPTER}" != '' ]] \
    && VBoxManage modifyvm ${VM_NAME} \
         --bridgeadapter3 ${VIRTUALBOX_BRIDGE_ADAPTER}
  [[ "${VIRTUALBOX_BRIDGE_MAC}" != '' ]] \
    && VBoxManage modifyvm ${VM_NAME} \
         --macaddress3 ${VIRTUALBOX_BRIDGE_MAC}
fi

[[ ${VM_RUN} -eq 1 ]] && docker-machine start ${VM_NAME}
