# AlexandrPoddubnyy_infra
AlexandrPoddubnyy Infra repository


====================
Домашнее задание №3:
====================

Исследование способов подключения к someinternalhost. Вариант:

	а) Одностотроник для входа на ВМ someinternalhost в YC -

		вариант> ssh -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/appuser appuser@x.x.x.x" -i ~/.ssh/appuser appuser@someinternalhost hostname -f
	        вариант> ssh -J x.x.x.x -i ~/.ssh/appuser appuser@10.128.0.11
		где: x.x.x.x - IP-внешний адрес VM bastion
		      10.128.0.11 - IP-адрес VM someinternalhost

	б)  при описании в файле пользователя на локальном ПК ~/.ssh/config , записи вида

		####
		Host someinternalhost
		        User appuser
		        IdentityFile ~/.ssh/appuser
		        ProxyCommand=ssh -W %h:%p -i ~/.ssh/appuser appuser@x.x.x.x
		####

		вход на ВМ возможен по короткой комманде
		> ssh someinternalhost

Впн-сервер на bastion

	bastion_IP = 51.250.66.142
	someinternalhost_IP = 10.128.0.11

====================
Домашнее задание №4:
====================

а) Тестовое приложение

	testapp_IP = 158.160.35.107
	testapp_port = 9292

б) Самостоятельноа работа. Скрипт для инсталляции приложения:
	 startup script в ВМ -  startup-script.sh

в) Дополнительное задание. Запуск новой ВМ, сразу с установленным приложением:

	yaml для ya cli metadata -  startup.yaml
	используемая команда YС CLI (пример):

	> yc compute instance create \
	   --name reddit-app2 \
	   --hostname reddit-app2 \
	   --memory=4 \
	   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
	   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
	   --metadata-from-file='user-data=startup.yaml'
