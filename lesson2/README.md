## Реализовать терраформ для разворачивания одной виртуалки в yandex-cloud;
## Запровиженить nginx с помощью ansible.

Terraform скрипт создает файл hosts.ini c группами хостов и их ip (блок "resource "local_file" "inventory"").
Ansible playbook использует hosts.ini вместe c переменными в папке group_vars для подключения к хостам.
