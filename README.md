# kazhem_microservices
Kazhemskiy Mikhail OTUS-DevOps-2020-02 microservices repository

# Домашние задания

## HomeWork 12: Docker контейнеры. Docker под капотом

* Настроена интеграция с travis-ci, по аналогии с репозиторием infra

### Установка Docker и основные команды

* Установлен [Docker](https://docs.docker.com/engine/install/)
* `docker version` для проверки текущей установки докера
  <details>
  <summary>Пример</summary>

  ```shell
    Client:
    Version:           19.03.6
    API version:       1.40
    Go version:        go1.12.17
    Git commit:        369ce74a3c
    Built:             Fri Feb 28 23:45:43 2020
    OS/Arch:           linux/amd64
    Experimental:      false

    Server: Docker Engine - Community
    Engine:
    Version:          19.03.8
    API version:      1.40 (minimum version 1.12)
    Go version:       go1.12.17
    Git commit:       afacb8b
    Built:            Wed Mar 11 01:29:16 2020
    OS/Arch:          linux/amd64
    Experimental:     true
    containerd:
    Version:          v1.2.13
    GitCommit:        7ad184331fa3e55e52b890ea95e65ba581ae3429
    runc:
    Version:          1.0.0-rc10
    GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
    docker-init:
    Version:          0.18.0
    GitCommit:        fec3683
  ```
  </details>
* `docker info` - информация о текущем состоянии docker daemon
  <details>
  <summary>Пример</summary>

  ```shell
    Client:
    Debug Mode: false
    Server:
    Containers: 13
    Running: 2
    Paused: 0
    Stopped: 11
    Images: 58
    Server Version: 19.03.8
    Storage Driver: overlay2
    Backing Filesystem: <unknown>
    Supports d_type: true
    Native Overlay Diff: true
    Logging Driver: json-file
    Cgroup Driver: cgroupfs
    Plugins:
    Volume: local
    Network: bridge host ipvlan macvlan null overlay
    Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
    Swarm: inactive
    Runtimes: runc
    Default Runtime: runc
    Init Binary: docker-init
    containerd version: 7ad184331fa3e55e52b890ea95e65ba581ae3429
    runc version: dc9208a3303feef5b3839f4323d9beb36df0a9dd
    init version: fec3683
    Security Options:
    seccomp
    Profile: default
    Kernel Version: 4.19.84-microsoft-standard
    Operating System: Docker Desktop
    OSType: linux
    Architecture: x86_64
    CPUs: 8
    Total Memory: 12.37GiB
    Name: docker-desktop
    ID: QW4A:TQLH:BJQM:4X6F:LUIZ:E2SY:5OIU:FHJP:LW5O:ZKYJ:FGQV:C5DQ
    Docker Root Dir: /var/lib/docker
    Debug Mode: true
    File Descriptors: 54
    Goroutines: 57
    System Time: 2020-05-23T12:18:03.3060413Z
    EventsListeners: 3
    Username: kazhem
    Registry: https://index.docker.io/v1/
    Labels:
    Experimental: true
    Insecure Registries:
    127.0.0.0/8
    Live Restore Enabled: false
    Product License: Community Engine

    WARNING: bridge-nf-call-iptables is disabled
    WARNING: bridge-nf-call-ip6tables is disabled
   ```
  </details>
* Проверены основновые команды docker:
  * Список запущенных контейнеров `docker ps`
  * Список всех контейнеров `docker ps -**a`**
  * Список сохранненных образов `docker images`
  * Команда `docker run` создает и запускает контейнер из image
  * `docker start <u_container_id>` запускает остановленный(уже созданный) контейнер
  * `docker attach <u_container_id>` подсоединяет терминал к созданному контейнеру
  * `docker run` = `docker create + docker start + docker attach*`  * - при наличии опции -i
    * `-i` - запускает контейнер в foreground режиме (docker attach)
    * `-d` – запускает контейнер в background режиме
    * `-t` создает TTY
  * `docker exec -it <u_container_id> bash` - запускает новый процесс bash внутри контейнера
  * `docker commit  <u_container_id> <image_name>` - создает image из контенера. При этом сам контейнер остается запущенным.
  * `docker kill` - сразу посылает SIGKILL
  * `docker stop` - посылает SIGTERM, и через 10 секунд(настраивается) посылает SIGKILL
    * SIGTERM - сигнал остановки приложения
    * SIGKILL - безусловное завершение процесса
  * `docker system df`
    * Отображает сколько дискового пространства занято образами, контейнерами и volume’ами.
    * Отображает сколько из них не используется и возможно удалить
  * `docker rm` удаляет контейнер, можно добавить флаг `-f`, чтобы удалялся работающий container(будет послан sigkill)
    `docker rm $(docker ps -a -q) # удалит все незапущенные контейнеры`
  * `docker rmi` удаляет image, если от него не зависят запущенные контейнеры
    `docker rmi $(docker images -q)`
* Задание со *: Сравните вывод двух следующих команд - `docker inspect <u_container_id>` и `docker inspect <u_image_id>`
  ```shell
    REPOSITORY               TAG                 IMAGE ID            CREATED              SIZE
    kazhem/ubuntu-tmp-file   latest              dfb7cf1903a0        About a minute ago   125MB
    ubuntu                   16.04               005d2078bdfa        3 days ago           125MB
    docker/getting-started   latest              656fe9b8b12f        5 weeks ago          26.2MB
    hello-world              latest              bf756fb1ae65        3 months ago         13.3kB
  ```
  ```text
    Анализ команд
    # docker inspect <u_image_id>
    и
    # docker inspect <u_container_id>
    показал, что
    В описании контейнера присутствуют такие элементы, как:
    "State": {}  # Описание текущего статуса контейнера (запущен/остановлен/упал и т.п.)
    "Image": ""  # Чексумма образа-основы
    "NetworkSettings":  # Параметры подключенных к контейнеру сетей
    и т.п. Подробнее в README.md
    Эти параметры характерны для уже запущенного окружения.

    В описании образа же присутствуют только параметры, описывающие сам образ,
    родительский образ и характеристики контейнера, с помощью которого создавался образ.
    Образ не имеет параметров, характерных для уже запущенного окружения.
    Только параметры по-умолчанию, которые будут использованы при запуске контейнера.


    Из вышеописанного можно сделать вывод, что контейнер -- это уже запущенное окружение на базе ранее созданного образа.
  ```

### Интеграция с Gcloud

* Создан новый проект  GCE с названием `docker`
* Инициализирован gcloud `gcloud init`
* Настроен `gcloud auth application-default login`
* Создан docker machine
  ```shell
    $ export GOOGLE_PROJECT=_ваш-проект_
    $ docker-machine create --driver google \
        --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntuos-cloud/global/images/family/ubuntu-1604-lts \
        --google-machine-type n1-standard-1 \
        --google-zone europe-west1-b \
        docker-host
    $ docker-machine ls
  ```
* Выполнено переключение на созданную машину `eval $(docker-machine env docker-host)`
* Работа с PID namespace:
  * По умолчанию контейнер запускается в отдельном PID  namespace
    Команда `docker run --rm -ti tehbilly/htop` результатом своим показывает только запущенный процесс htop
  * Запуск контейнера в PID namespace хоста
    Команда `docker run --rm --pid host -ti tehbilly/htop` возвращает все процессы хост-системы

### Dockerfile

* Создан Dockerfile
  * Создан конфиг MongoDB [docker-monolith/mongod.conf](docker-monolith/mongod.conf)
  * Создан скрипт запуска приложения [docker-monolith/start.sh](docker-monolith/start.sh)
  * Создан скрипт с переменной окружения `DBATABASE_URL` [docker-monolith/db_config](docker-monolith/db_config)
  * Создан [docker-monolith/Dockerfile](docker-monolith/Dockerfile)
    * Основан на `ubuntu:16.04`
      ```dockerfile
      FROM ubuntu:16.04
      ```
    * Установка необходимых пакетов
      ```dockerfile
      RUN apt-get update
      RUN apt-get install -y mongodb-server ruby-full ruby-dev build-essential git
      RUN gem install bundler
      ```
    * Загрузка приложения
      ```dockerfile
      RUN git clone -b monolith https://github.com/express42/reddit.git
      ```
    * Копирование необходимых файлов в контейнер
      ```dockerfile
      COPY mongod.conf /etc/mongod.conf
      COPY db_config /reddit/db_config
      COPY start.sh /start.sh
      ```
    * Установка зависимостей приложения
      ```dockerfile
      RUN cd /reddit && bundle install
      RUN chmod 0777 /start.sh
      ```
    * Запуск приложения
      ```dockerfile
      CMD ["/start.sh"]
* Собран образ нашего приложения: `docker build -t reddit:latest .` (из дериктории нахождения Dockerfile, т.к. точка - дериктория, где расположен Dockerfile). `-t` - тег образа
* Запущен контейнер `docker run --name reddit -d --network=host reddit:latest`
* Проверен результат: `docker-machine ls`:
  ```shell
  NAME          ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER     ERRORS
  docker-host   *        google   Running   tcp://<мой_IP>:2376           v19.03.4
  ```
* При попытке зайти на `` не удалось открыть страницу
* Создано правило фаервола
  ```shell
  gcloud compute firewall-rules create reddit-app \
   --allow tcp:9292 \
   --target-tags=docker-machine \
   --description="Allow PUMA connections" \
   --direction=INGRESS
  ```
  ```log
  Creating firewall...⠶Created [https://www.googleapis.com/compute/v1/projects/docker-257914/global/firewalls/reddit-app].
  Creating firewall...done.
  NAME        NETWORK  DIRECTION  PRIORITY  ALLOW     DENY  DISABLED
  reddit-app  default  INGRESS    1000      tcp:9292        False
  ```
* Сайт открыт успешно

### Docker hub
[Docker Hub ](https://hub.docker.com/) - это облачный registry сервис от компании Docker. В него можно выгружать и загружать из него докер образы. Docker по умолчанию скачивает образы из докер хаба.
* Выполнен вход на https://hub.docker.com/
* Выполнена авторизация docker на dockerhub `docker login`
* docker-образ загружен на докер хаб
  ```shell
  # docker tag reddit:latest kazhem/otus-reddit:1.0
  # docker push kazhem/otus-reddit:1.0

  The push refers to repository [docker.io/kazhem/otus-reddit]
  9c56f25ab809: Pushed
  9964405a2b79: Pushed
  f3e1d374270d: Pushed
  87badc7881a7: Pushed
  dcc1149e9964: Pushed
  bbeefc7b2d69: Pushed
  038504099637: Pushed
  28567395a615: Pushed
  3c326a42d554: Pushed
  bc72fb2e7b74: Mounted from library/ubuntu
  903669ee7207: Mounted from library/ubuntu
  a5a5f8c62487: Mounted from library/ubuntu
  788b17b748c2: Mounted from library/ubuntu
  1.0: digest: sha256:54828cee832eefa1a0379e4b128f7ce92ba0278c488686d8ba4ff3bdf2fc0c9d size: 3034
  ```
* Выполнена попытка запустить образ на локальном докере
  ```shell
  docker run --name reddit -d -p 9292:9292 kazhem/otus-reddit:1.0
  ```
* Образ успешно скачался с docker hub и приложение запустилось
  ```shell
  curl 127.0.0.1:9292
  ```
* Выполнен ряд проверок
  * `docker logs reddit -f` следить за логами контейнера
  * `docker exec -it reddit bash` выполнить bash в запущенном контейнере
    * `ps aux` список процессов
    * `killall5 1` послать сигнал SIGHUP всем приложениям
  * `docker start reddit` запустить ранее созданный контейнер с именем `reddit`
  * `docker stop reddit && docker rm reddit` остановить и удалить контейнер `reddit`
  * `docker run --name reddit --rm -it kazhem/otus-reddit:1.0 bash` скачать и запустить контейнер `kazhem/otus-reddit:1.0` из docker hub, удалить после остановки, в контейнере запустить `bash` вместо инструкции `CMD`
    * `ps aux` список процессов
    * `exit` выйти (с завершением `bash`)
  * Проверка что контейнер остановлен и удалён
    ```shell
    # docker container ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    03a9eea159ef        ubuntu:16.04        "bash"              41 hours ago        Up 21 hours                             wonderful_blackwell
    ```
* И ещё
  * `docker inspect kazhem/otus-reddit:1.0` посмотреть подробную информацию об образе
  * `docker inspect kazhem/otus-reddit:1.0 -f '{{.ContainerConfig.Cmd}}'` команда по-умолчанию при старте контейнера (директива `CMD` Dockerfile)
  * `docker run --name reddit -d -p 9292:9292 kazhem/otus-reddit:1.0` запустить контейнер
  * `docker exec -it reddit bash` запустить bash в уже запущенном контейнере
    * `mkdir /test1234` создать директорию /test1234 (внутри контейнера)
    * `touch /test1234/testfile` создать файл /test1234/testfile
    * `rmdir /opt` удалить лиректорию /opt
    * `exit` выйти из контейнера
  * `docker diff reddit` посмотреть изменения в перезаписываемом слое контейнера
    ```shell
    C /tmp
    A /tmp/mongodb-27017.sock
    C /var
    C /var/log
    A /var/log/mongod.log
    C /var/lib
    C /var/lib/mongodb
    A /var/lib/mongodb/_tmp
    A /var/lib/mongodb/journal
    A /var/lib/mongodb/journal/j._0
    A /var/lib/mongodb/local.0
    A /var/lib/mongodb/local.ns
    A /var/lib/mongodb/mongod.lock
    C /root
    A /root/.bash_history
    A /test1234
    A /test1234/testfile
    D /opt
    ```
  * `docker stop reddit && docker rm reddit` остановить и удалить контейнер
  * `docker run --name reddit --rm -it kazhem/otus-reddit:1.0 bash` снова запустить контейнер
  * `ls /` посмотреть содержимое корневой директории.
    Так как контейнер создан заново, /test1234 отсутствует, а /opt на месте
