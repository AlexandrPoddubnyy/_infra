# AlexandrPoddubnyy_infra
AlexandrPoddubnyy Infra repository


Домашнее задание №3:

Исследование способов подключения к someinternalhost. Вариант:

	а) Одностотроник для входа на ВМ someinternalhost в YC -

		> ssh -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/appuser appuser@x.x.x.x" -i ~/.ssh/appuser appuser@someinternalhost hostname -f
		где: x.x.x.x - IP-внешний адрес VM bastion

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
