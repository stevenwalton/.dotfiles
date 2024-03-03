# What's in here?
Collection of roles and scripts for installing on different machines.
Some come from home servers while others come from things like setting up
machines elsewhere.
Try to contain each role into unique files so we can pull for what tasks we
really want to do and even Frankenstein when needed.

A big part of ansible is actually using it for documentation.
This will help you how you did things in the past and save time.
Best to do this as docu-u-code.

# How to use
You may forget how to use Ansible.
Luckily we can write that down

Make sure to edit [ansible.cfg](ansible.cfg) and that it points towards your
ssh config.
Then run
```bash
ansible-playbook -i inventory.yaml roles/whatever/you/want --ask-pass
```
In all likelihood you'll need to run `ansible-galaxy collection install
ansible.posix` if it is your first time.
