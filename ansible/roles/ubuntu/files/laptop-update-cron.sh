#!/bin/bash
#
# Hopefully this works.
#
if [ "$1" == "--force" ]; then
    FORCE="-o"
else
    FORCE=""
fi

url='https://github.com/magfest/laptops.git'
directory='/opt/laptops'
logfile='/var/log/ansible-laptop-pull-update.log'
checkout="$(cat ${directory}/branch)"

if [ "$checkout" == "" ]; then
    checkout="main"
    echo "main" > ${directory}/branch
fi

requirements="https://raw.githubusercontent.com/magfest/laptops/${checkout}/ansible/requirements.yaml"

mkdir -p ${directory}
wget -N -P ${directory} ${requirements}

while ! ping -c1 google.com; do sleep 3; done

ansible-galaxy install -r ${directory}/requirements.yaml
ansible-galaxy collection install -r ${directory}/requirements.yaml

ansible-pull ${FORCE} -C ${checkout} -d ${directory}/repo -i localhost, -U ${url} --tags "laptops" --vault-password-file /opt/ansible/vault-password ansible/playbook.yaml 2>&1 | tee -a ${logfile}
