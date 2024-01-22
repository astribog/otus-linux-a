## Поднннять proxmox в virtualbox 
## Поднять lxc контейнер в proxmox с помощью terraform


## Пошаговая инструкция

1. Клонируем репу для создания vagrant proxmox base box https://github.com/rgl/proxmox-ve (не заставил работать vbox additions - закоментировал в proxmox-ve/provisioners/provision.sh). В этом репозитории уже присутсвуют склонированные репы с необходимыми изменениями.

```
git clone https://github.com/rgl/proxmox-ve
```
2. Собираем vagrant proxmox base box (около 1ч)
```
cd proxmox-ve
make build-virtualbox
```
3. Добавляем в vagrant собранную proxmox base box 
```
vagrant box add -f proxmox-ve-amd64  proxmox-ve-amd64-virtualbox.box
```
4. Используем Vagrantfile, скрипты из клонированной репы и поднимаем виртуалку c proxmox, адрес зашит в Vagrantfile
```
cd ..
cp proxmox-ve/example/provision.sh proxmox-ve/example/summary.sh .
vagrant up
```
5. Заходим https://192.168.56.10:8006 (root vagrant) и скачиваем lxc template

6. Клонируем репу terraform плагина proxmox и собираем его (ставим GO,если не стоит)
```
git clone https://github.com/Telmate/terraform-provider-proxmox
cd terraform-provider-proxmox/
make
```
7. Добавляем плагин в terraform
```
mkdir -p ~/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/${PLUGIN_ARCH}
cp bin/terraform-provider-proxmox ~/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/${PLUGIN_ARCH}/
```
8. Поднимаем lxc контейнер с помощью terraform
```
cd ..
terraform init
terraform validate
terraform plan
terraform apply
```
9. B результате получаем работающщий lxc контейнер в proxmox на virtualbox :)
![lxc](Screenshot_2024-01-22_00-12-18.png)



  1824  make build-virtualbox
 1825  vagrant add -f proxmox-ve-amd64-virtualbox.box
 1826* vagrant add proxmox-ve-amd64-virtualbox.box\
 1827  vagrant box add -f proxmox-ve-amd64-virtualbox.box
 1828  vagrant box add -f proxmox-ve-amd64  proxmox-ve-amd64-virtualbox.box
 1829  cd ..
 1830  vagrant up
 1831  vagrant ssh defaultt
 1832  vagrant ssh default
 1833  vagrant destroy -f
 1834  vagrant up
 1835  vagrant destroy
 1836  vagrant destroy -f
 1837  vagrant up
 1838  vagrant destroy -f
 1839  vagrant up
 1840  vagrant destroy -f
 1841  vagrant up
 1842  vagrant scp proxmox-ve-amd64:/var/lib/vz/template/cache/ubuntu-23.04-standard_23.04-1_amd64.tar.zst ./shared
 1843  vagrant ?
 1844  vagrant status
 1845  vagrant scp  default:/var/lib/vz/template/cache/ubuntu-23.04-standard_23.04-1_amd64.tar.zst ./shared
 1846  terraform ?
 1847  terraform -help
 1848  terraform init
 1849  sudo apt     install openvpn 
 1850  sudo openvpn --config ~/Documents/Whoer_Netherlands_nl.ovpn 
 1851  nano ~/Documents/Whoer_Netherlands_nl.ovpn 
 1852  sudo openvpn --config ~/Documents/Whoer_Netherlands_nl.ovpn 
 1853  nano ~/Documents/Whoer_Netherlands_nl.ovpn 
 1854  sudo openvpn --config ~/Documents/Whoer_Netherlands_nl.ovpn 
 1855  git clone https://github.com/Telmate/terraform-provider-proxmox
 1856  cd terraform-provider-proxmox/
 1857  make
 1858  wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
 1859  sudo  rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
 1860  sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
 1861  export PATH=$PATH:/usr/local/go/bin
 1862  go version
 1863  make
 1864  PLUGIN_ARCH=linux_amd64
 1865  mkdir -p ~/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/${PLUGIN_ARCH}
 1866  cp bin/terraform-provider-proxmox ~/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/${PLUGIN_ARCH}/
 1867  ls -al ~/.terraform.d/plugins/registry.example.com/telmate/proxmox/1.0.0/${PLUGIN_ARCH}/
 1868  cd ..
 1869  terraform init
 1870  terraform -help
 1871  terraform validate
 1872  terraform plan
 1873  terraform apply
 1874  ls  /etc/pve/lxc/
 1875  cat /etc/pve/nodes/pr64/lxc/100.conf
 1876  ls /etc/pve/nodes/pr64/lxc/
 1877* ls /etc/pve/
 1878  ls /etc/pve
 1879  terraform apply
 1880  terraform destroy
 1881  vagrant destroy
 1882  history