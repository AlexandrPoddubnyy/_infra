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


====================
Домашнее задание №5:
====================

## В процессе сделано:
        Работа в репозитории *_infra -
            Создание новой ветки , перенос старых данных в соответсви с указанием в дз.
        Установка Packer.
        Создание сервисного аккаунта в YC, настройка роли, ключа.
        Инициализация плагина под Yandex.
        Подготовка конфигураций, шаблонов и скриптов для Packer, тесты, диагностика, дебаг, сборка, пересборки и тп.
        Запуск новой ВМ с собранного образа, проверка образа.
        Деплой, проверка приложения в новой ВМ.
        Параметризирование шаблонов, диагностика, пересборка.
        Построение bake-образа (*)
        Автоматизация создания ВМ (⭐)

## Как запустить проект:
    packer build -var-file=variables.pkr.hcl immutable.pkr.hcl

Образы:
> yc compute image list
+----------------------+------------------------+-------------+----------------------+--------+
|          ID          |          NAME          |   FAMILY    |     PRODUCT IDS      | STATUS |
+----------------------+------------------------+-------------+----------------------+--------+
| fd80g6f1967aq67ie3j8 | reddit-base-08-24-2023 | reddit-base | f2e5pn9cvd0mf5sg7bdn | READY  |
| fd8b12iglpvrid232tnc | reddit-full-08-25-2023 | reddit-full | f2e5pn9cvd0mf5sg7bdn | READY  |
+----------------------+------------------------+-------------+----------------------+--------+

Скрипт автоматизированного создания ВМ - тут config-scripts/create-reddit-vm.sh

====================
Домашнее задание №6:
====================

## В процессе сделано:
        Ознакомление с Terraform
        Установка Terraform.
        Проверка сервисного аккаунта в YC, переменные окружения и тп, подготовка окружения.
        Работа с Terraform,
            подготовка конфигураций,
            тесты, диагностика, запуск инфраструктуры проектов, работа из исзмеениями,
            шаблоны, вывод, переменные, статусы
        Проверка запущенных Вм и сервисов.

## Как запустить проект:
	terraform> terraform apply

## Как проверить работоспособность:
	Например, перейти по ссылке http://http://158.160.47.200:9292/


====================
Домашнее задание №7:
====================

## В процессе сделано:
    1. Подготовка ветки terraform-2, перенос lb.tf и тп
    2. Добавление ресурсов сети, terraform validate, корректировка outputs.tf , terraform destroy
    3. Добавление сети в вм. Траблшутинг, увеличение лимита сетей в YC через поддержку и тп
    4. Подготовка файлов для сборки образов и сборка

	> cd packer
	> packer build -var-file=variables.pkr.hcl db.pkr.hcl
	> packer build -var-file=variables.pkr.hcl app.pkr.hcl

    5. Разбивка конфигурации терраформ на отдельные файлы для app, db и тп. Проверка vm, по.
    6. Модули. разбирательство с ошибками инициализации , документация у hashicorp yc, stackoverflow и тп. Вариантов не найдено.
       Дебаггинг и тп. Итого, догадка-решение:  опять же config.tf в каждую папку с модулями
    7. Применнение конфигурации с модулями и тесты.
    8. Создание конфигуруций и инициализация stage и prod, параметризирорование, проверки.
    9. Удаление файлов со старых мест размешения, Destroy окружений.
    10. Прогоны, проверки тестов в github, корректировки для прохождения тестов.

	> cd terraform/stage ;  terraform init ; terraform apply
	> cd terraform/prod  ;  terraform init ; terraform apply

    11. (*) Вопрос хранения state в удаленном бакенде.
        Описано в backend.tf / config.tf.example
        Для инициализации:

	> terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"

        После переноса конфигов (без state) в другие папки

	> terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY" -reconfigure

    12. (**) Задача настройки provisioner для app и db , для разных окружений
        Рабочие файлы в папках окружений prod/stage, и модулей app/db


## Как запустить проект:

	>terraform/prod> terraform apply
	>terraform/stage> terraform apply

## Как проверить работоспособность:

	Например, перейти по ссылке http://158.160.47.200:9292/
