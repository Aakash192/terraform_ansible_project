# Azure Infrastructure with Terraform and Ansible

A cloud automation project that builds a small multi-VM environment on Azure with Terraform, then configures the Linux servers with Ansible. Terraform triggers Ansible automatically once the virtual machines exist, so a single `terraform apply` produces a configured environment.

## What it builds

| Layer | Resources |
|-------|-----------|
| Foundation | Resource group in Canada Central, virtual network (`10.0.0.0/16`), subnet (`10.0.1.0/24`), network security group |
| Shared services | Log Analytics workspace, Recovery Services vault, storage account used for boot diagnostics |
| Linux servers | 3 CentOS 8 VMs (`Standard_B1s`) in an availability set, SSH key authentication, public IPs, Network Watcher and Azure Monitor extensions |
| Windows server | 1 Windows Server 2016 VM (`Standard_B1s`) with the antimalware extension |
| Storage | A 10 GB StandardSSD data disk attached to each VM |
| Load balancing | Public load balancer with a backend pool of the Linux VMs, an HTTP rule on port 80 and a health probe |
| Database | Azure Database for PostgreSQL server with SSL enforced |

## How the pieces fit together

```
terraform apply
    |
    |  modules run in dependency order
    v
resource group, network, shared services, VMs, disks, load balancer, database
    |
    |  provisioner.tf waits for the resource group, data disks and Linux VMs
    v
runansible.sh  runs  ansible-playbook
    |
    v
Ansible roles on the 3 Linux VMs
    1. datadisk    partition, format and mount the data disk
    2. profile     session timeout in /etc/profile
    3. user        cloudadmins group, users, SSH keys, sudoers
    4. webserver   Apache serving each VM's hostname
```

## Terraform layout

The root `main.tf` wires eight small modules together. Each module takes what it needs as inputs and exposes outputs for the next one, for example the VM modules receive the subnet ID from the network module and the load balancer receives the network interface IDs from the Linux module.

| Module | Purpose |
|--------|---------|
| `rgroup` | Resource group |
| `network` | Virtual network, subnet, network security group and its rules |
| `common` | Log Analytics workspace, Recovery Services vault, storage account |
| `vmlinux` | Linux VMs, NICs, public IPs, availability set, monitoring extensions |
| `vmwindows` | Windows VM, NIC, public IP, availability set, antimalware extension |
| `datadisk` | Managed data disks and their attachments |
| `loadbalancer` | Load balancer, public IP, backend pool, rule, probe |
| `database` | PostgreSQL server |

## Ansible layout

The playbook `ansible/n01603990-playbook.yml` applies four roles to the `linux` inventory group:

| Role | What it does |
|------|--------------|
| `datadisk` | Creates two partitions on the data disk (4 GiB `xfs`, 5 GiB `ext4`), formats them and mounts them at `/part1` and `/part2` |
| `profile` | Appends a block to `/etc/profile` that sets `TMOUT=1500` |
| `user` | Creates the `cloudadmins` group and three users with generated SSH keys, and adds a sudoers drop-in that is validated with `visudo` before it is saved |
| `webserver` | Installs Apache, writes the VM's hostname to `index.html`, sets it read only, and restarts `httpd` through a handler |

`ansible/user_commands.yml` is a separate playbook for spot checks on one VM (last lines of `/etc/passwd` and `/etc/profile`, disk usage).

## Design decisions

- **One module per concern.** Small modules keep each piece readable and reusable, and the root file shows the whole architecture in one place.
- **`for_each` over a map of VMs.** Names and sizes live in one map, so adding a Linux VM is a one line change.
- **Remote state.** `backend.tf` stores state in an Azure Storage container, so state is not tied to one laptop.
- **Ansible runs after infrastructure is ready.** A `null_resource` with a `local-exec` provisioner depends on the resource group, data disks and Linux VMs, so configuration never starts against machines that do not exist yet.
- **Idempotent configuration.** The Ansible roles use modules such as `parted`, `filesystem`, `mount` and `blockinfile`, so re-running the playbook does not repeat work.
- **SSH keys for Linux, no passwords in code.** Linux VMs authenticate with key pairs. The database and Windows passwords are required, sensitive Terraform variables with no default.

## Prerequisites

- An Azure subscription and the Azure CLI, signed in with `az login`
- Terraform and Ansible installed
- An SSH key pair at the paths set by the `pub_key` and `priv_key` variables in the Linux VM module
- The backend resource group, storage account and container named in `terraform/backend.tf`, created beforehand

## Usage

```bash
cd terraform

# Passwords are read from the environment and never written to a file
export TF_VAR_db_admin_password='<choose a strong password>'
export TF_VAR_windows_admin_password='<choose a strong password>'

terraform init
terraform plan
terraform apply
```

Remove everything when finished, since the VMs, load balancer and database all cost money while they exist:

```bash
terraform destroy
```

## Known limitations

This was built as a lab exercise, and a production version would change several things:

- The network security group allows SSH, RDP, WinRM and HTTP from any source address. A real deployment would restrict these to known ranges or use Azure Bastion.
- The `user` role gives the `cloudadmins` group passwordless sudo and creates accounts with an empty password field. `host_key_checking` is also turned off in `ansible.cfg`.
- The Basic load balancer and the PostgreSQL Single Server resource type are older Azure offerings that Azure has been retiring. A refresh would move to a Standard load balancer and Flexible Server.
- CentOS 8 and Windows Server 2016 images are old. A refresh would use currently supported images.
- Resource names carry a course ID suffix from the assignment's naming convention.
