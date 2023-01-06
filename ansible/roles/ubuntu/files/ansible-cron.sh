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
requirements=${directory}/repo/ansible/requirements.yaml

echo "refactor-wifi" > /opt/laptops/branch

checkout="$(cat /opt/laptops/branch)"

while ! ping -c1 google.com; do sleep 3; done

ansible-galaxy install -r ${requirements}
ansible-galaxy collection install -r ${requirements}
ansible-pull ${FORCE} -C ${checkout} -d ${directory}/repo -i localhost, -U ${url} --tags "laptops" --vault-password-file /opt/ansible/vault-password ansible/playbook.yaml 2>&1 | tee -a ${logfile}
