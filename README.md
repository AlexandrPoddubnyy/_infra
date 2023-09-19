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


====================
Домашнее задание №8:
====================

## В процессе сделано:
    1 Установка Ansible
    2 Знакомство с базовыми функциями и инвентори
    3 Выполнение различных модулей на подготовленной в прошлых ДЗ инфраструктуре
    4 Пишем простой плейбук
    5 Задание со звездочкой (*) Динамический инвентори.
      Для задания со сзвездочкой используется скрипт myinv.sh, минимальные данные скрипт берет из листинга >yc compute instance list

## Как запустить проект:

	Из хистори
	> pip install -r requirements.txt
	> ansible --version
	> which ansible
	>
	> ansible appserver -i ./inventory -m ping
	> ansible appserver,dbserver -i ./inventory -m ping
	> ansible appserver,dbserver -m command -a uptime
	>
	> ansible all -m ping -i inventory.yml
	>
	> ansible app -m command -a 'ruby -v'
	> ansible app -m command -a 'bundler -v'
	> ansible app -m command -a 'ruby -v; bundler -v'
	> ansible app -m shell -a 'ruby -v; bundler -v'
	>
	> ansible db -m command -a 'systemctl status mongodb'
	> ansible db -m systemd -a name=mongodb
	> ansible db -m service -a name=mongodb
	>
	> ansible app -m apt -a name=git
	> ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit'
	> ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/appuser/reddit'
	>
	> yc compute instance list
	> ansible all -m ping

## Как проверить работоспособность:

	Например, перейти по ссылке http://158.160.47.200:9292/


====================
Домашнее задание №9:
====================

## В процессе сделано:

    Кратко:
    1. Подготовка git-а для работы с веткой ansible-2 , при условии что дз ansible-1 еще не принято, ветка предудущая не смержена.
    2. Коммит с заремливанием кода провизионина приложения и дб через terraform-2 , задачния со *
    3. Коммит с корректировкой .для ансибле
    4. Работа по "Один playbook, один сценарий"
    5. Работа по "Аналогично один плейбук, но много сценариев"
    6. Работа по "И много плейбуков."
    7. Работа по "Задание со ⭐ "
    8. Работа по "Изменим провижн образов Packer на Ansible-плейбуки"
    9. Работа по "Проверка ДЗ"

    Чуть подробнее:
    1. Подготовка git-а для работы с веткой ansible-2 , при условии что дз ansible-1 еще не принято, ветка предудущая не смержена.
    2. Коммит с заремливанием кода провизионина приложения и дб через terraform-2 , задачния со *
    3. Коммит с корректировкой .для ансибле
    4. Один playbook, один сценарий
        Плейбуки
        Сценарий плейбука
        Сценарий для MongoDB
        Шаблон конфига MongoDB
        Пробный, тестовый прогон
            ansible-playbook reddit_app.yml --syntax-check
            ansible-playbook reddit_app.yml --check
            ansible-playbook reddit_app.yml --check --limit db
        Определение переменных
        Корректировка 2-х темплейтов для mongod и mongodb
        Пробный прогон
        Handlers
        Добавим handlers
        Применим плейбук
            ansible-playbook  reddit_app.yml  --limit db
        Настройка инстанса приложения
        Unit для приложения
        Добавим шаблон для приложения
          + Информация о внутренних адресах выведена в output-переменные в Terraform
        Настройка инстанса приложения
          ansible-playbook reddit_app.yml --check --limit db --tags db-tag
          ansible-playbook reddit_app.yml --check --limit app --tags app-tag
          ansible-playbook reddit_app.yml --limit app --tags app-tag
        Деплой
        Выполняем деплой
          ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
          ansible-playbook reddit_app.yml --limit app --tags deploy-tag
        Проверяем работу приложения
     5. Аналогично один плейбук, но много сценариев
        Один плейбук, несколько сценариев
        Результат
        Пересоздадим инфраструктуру
        Проверим работу сценариев
            ansible-playbook reddit_app2.yml --tags db-tag --check
            ansible-playbook reddit_app2.yml --tags db-tag
            ansible-playbook reddit_app2.yml --tags app-tag --check
            ansible-playbook reddit_app2.yml --tags app-tag
        Сценарий для деплоя
            ansible-playbook reddit_app2.yml --tags app-tag
        Проверка сценария
            ansible-playbook reddit_app2.yml --tags deploy-tag --check
     6. И много плейбуков.
        Несколько плейбуков
        db.yml
        app.yml
        deploy.yml
        site.yml
        Проверка результата
            ansible-playbook site.yml --check
            ansible-playbook site.yml
        Проверка результата
     7. Задание со ⭐
        - Использовать dynamic inventory для Yandex Cloud в этом задании.  Готово. Работает с помошью inventory = ./myinv.sh
        - Исследовать функционал keyed_groups -  исследована документация, информация из интернет и тп, действующих решений в проекте не исследовано.
     8. Изменим провижн образов Packer на Ansible-плейбуки
        Провижининг в Packer
        Изменим провижининг в Packer
        Самостоятельное задание
            ansible-playbook --check packer_db.yml
            ansible-playbook --check packer_app.yml
        Интегрируем Ansible в Packer
        Проверяем образы
          Выполните билд образов с использованием нового провижинера.
            packer validate -var-file=variables.pkr.hcl db.pkr.hcl
            packer validate -var-file=variables.pkr.hcl app.pkr.hcl
                Для настройки плагина понадобилось временно добавить в .hcl
                ...
                packer {
                    required_plugins {
                        ansible = {
                            source  = "github.com/hashicorp/ansible"
                            version = "~> 1"
                        }
                    }
                }
                ...
                и сделать >packer init -var-file=variables.pkr.hcl app.pkr.hcl
            AlexandrPoddubnyy_infra> packer validate -var-file=packer/variables.pkr.hcl packer/db.pkr.hcl
            AlexandrPoddubnyy_infra> packer validate -var-file=packer/variables.pkr.hcl packer/app.pkr.hcl
            packer build -var-file=packer/variables.pkr.hcl packer/db.pkr.hcl
            packer build -var-file=packer/variables.pkr.hcl packer/app.pkr.hcl
            yc compute image list
          На основе созданных app и db образов запустите stage окружение
            terraform/stage> terraform destroy
            terraform/stage> terraform apply -auto-approve
          Проверьте, что c помощью плейбука site.yml из предыдущего раздела окружение конфигурируется, а приложение деплоится и работает.
            ansible> ansible-playbook site.yml --check
            ansible> ansible-playbook site.yml
     9. Проверка ДЗ
            git commit
            change README "внесите описание того, что сделано"

## Как запустить проект:

        >packer build -var-file=packer/variables.pkr.hcl packer/db.pkr.hcl
        >packer build -var-file=packer/variables.pkr.hcl packer/app.pkr.hcl
        >yc compute image list
        terraform/stage> terraform destroy
        terraform/stage> terraform apply -auto-approve
        ansible> ansible-playbook site.yml

## Как проверить работоспособность:

        Например, перейти по ссылке http://158.160.33.224:9292/
