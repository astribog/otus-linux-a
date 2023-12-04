### Демонстрационный стенд pacemaker на 3 виртуальные машины с разделяемой файловой системой GFS2 поверх cLVM

  Данный vagrant-стенд развёртывает 4 виртуальных машины с использованием провайдера terraform.
Внутри виртуальных машин с помощью ansible развёртывается чистый pacemaker-кластер с настроенным фенсингом virtualbox.

  
##### Используемые инструменты:
  - Terraform + YandexCloud
  - CentOS7
  - targetcli
  - Pacemaker + Corosync
  - Ansible Galaxy роль для настройки iscsi target OndrejHome.targetcli
  - Ansible Galaxy роль для настройки iscsi initiators OndrejHome.iscsiadm

 
##### Порядок запуска:
```
git clone <this repo>
terraform apply
ansible-galaxy install OndrejHome.targetcli
ansible-galaxy install OndrejHome.iscsiadm
ansible-playbook main.yml
```

##### Комментарии:
  
  Внешие IP-адреса для Ansible формируются в процессе выполнения terraform, в hosts.yml. Внутренние захардкожены в  [terraform манифесте](main.tf) и соответствуют следующей таблице:

| IP адрес | Имя машины |
|----------------|---------------|
| 192.168.10.1 | tgt1.otus.lab |
| 192.168.10.2 | pcs1.otus.lab |
| 192.168.10.3 | pcs2.otus.lab |
| 192.168.10.4 | pcs3.otus.lab |

  В результате должно получится разделяемое файловое хранилище GFS2, примонтированное к /mnt/gfs2
  Данный стенд можно также развернуть и с использование Vagrant. Все необходимое присутствует.    

