# kazhem_microservices
Kazhemskiy Mikhail OTUS-DevOps-2020-02 microservices repository

- [kazhem_microservices](#kazhem_microservices)
- [Домашние задания](#домашние-задания)
  - [HomeWork 12: Docker контейнеры. Docker под капотом](#homework-12-docker-контейнеры-docker-под-капотом)
    - [Установка Docker и основные команды](#установка-docker-и-основные-команды)
    - [Интеграция с Gcloud](#интеграция-с-gcloud)
    - [Dockerfile](#dockerfile)
    - [Docker hub](#docker-hub)
  - [HomeWork 13: Docker образы. Микросервисы](#homework-13-docker-образы-микросервисы)
  - [Настройка](#настройка)
      - [Dockerfile best practices (collapsed)](#dockerfile-best-practices-collapsed)
    - [Выполнение](#выполнение)
      - [Подготовка](#подготовка)
      - [Сборка](#сборка)
      - [Запуск](#запуск)
      - [Образы приложений](#образы-приложений)
      - [Подключение volume](#подключение-volume)
  - [HomeWork 14: Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов](#homework-14-сетевое-взаимодействие-docker-контейнеров-docker-compose-тестирование-образов)
    - [Работа с сетями в Docker](#работа-с-сетями-в-docker)
      - [none](#none)
      - [host](#host)
      - [network namespaces](#network-namespaces)
      - [bridge](#bridge)
      - [Анализ bridge](#анализ-bridge)
    - [Docker-compose](#docker-compose)
      - [Переменные окружения](#переменные-окружения)
      - [Имя проекта](#имя-проекта)
    - [Задание со \*: docker-compose.override.yml](#задание-со--docker-composeoverrideyml)
  - [HomeWork 15: Устройство Gitlab CI. Построение процесса непрерывной интеграции](#homework-15-устройство-gitlab-ci-построение-процесса-непрерывной-интеграции)
    - [Подготовка](#подготовка-1)
    - [Инсталляция Gitlab CI](#инсталляция-gitlab-ci)
    - [Создание проекта](#создание-проекта)
    - [Runner](#runner)
    - [Тестирование Reddit](#тестирование-reddit)
    - [Работа с окружениями](#работа-с-окружениями)
      - [dev](#dev)
      - [staging и production](#staging-и-production)
      - [Динамические окружения](#динамические-окружения)
    - [Задание со *: Сборка контейнера с приложением reddit](#задание-со--сборка-контейнера-с-приложением-reddit)

# Домашние задания

## HomeWork 12: Docker контейнеры. Docker под капотом

- Настроена интеграция с travis-ci, по аналогии с репозиторием infra

### Установка Docker и основные команды

- Установлен [Docker](https://docs.docker.com/engine/install/)
- `docker version` для проверки текущей установки докера
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
- `docker info` - информация о текущем состоянии docker daemon
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
- Проверены основновые команды docker:
  - Список запущенных контейнеров `docker ps`
  - Список всех контейнеров `docker ps -**a`**
  - Список сохранненных образов `docker images`
  - Команда `docker run` создает и запускает контейнер из image
  - `docker start <u_container_id>` запускает остановленный(уже созданный) контейнер
  - `docker attach <u_container_id>` подсоединяет терминал к созданному контейнеру
  - `docker run` = `docker create + docker start + docker attach*`  * - при наличии опции -i
    - `-i` - запускает контейнер в foreground режиме (docker attach)
    - `-d` – запускает контейнер в background режиме
    - `-t` создает TTY
  - `docker exec -it <u_container_id> bash` - запускает новый процесс bash внутри контейнера
  - `docker commit  <u_container_id> <image_name>` - создает image из контенера. При этом сам контейнер остается запущенным.
  - `docker kill` - сразу посылает SIGKILL
  - `docker stop` - посылает SIGTERM, и через 10 секунд(настраивается) посылает SIGKILL
    - SIGTERM - сигнал остановки приложения
    - SIGKILL - безусловное завершение процесса
  - `docker system df`
    - Отображает сколько дискового пространства занято образами, контейнерами и volume’ами.
    - Отображает сколько из них не используется и возможно удалить
  - `docker rm` удаляет контейнер, можно добавить флаг `-f`, чтобы удалялся работающий container(будет послан sigkill)
    `docker rm $(docker ps -a -q) # удалит все незапущенные контейнеры`
  - `docker rmi` удаляет image, если от него не зависят запущенные контейнеры
    `docker rmi $(docker images -q)`
- Задание со *: Сравните вывод двух следующих команд - `docker inspect <u_container_id>` и `docker inspect <u_image_id>`
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

- Создан новый проект  GCE с названием `docker`
- Инициализирован gcloud `gcloud init`
- Настроен `gcloud auth application-default login`
- Создан docker machine
  ```shell
    $ export GOOGLE_PROJECT=_ваш-проект_
    $ docker-machine create --driver google \
        --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntuos-cloud/global/images/family/ubuntu-1604-lts \
        --google-machine-type n1-standard-1 \
        --google-zone europe-west1-b \
        docker-host
    $ docker-machine ls
  ```
- Выполнено переключение на созданную машину `eval $(docker-machine env docker-host)`
- Работа с PID namespace:
  - По умолчанию контейнер запускается в отдельном PID  namespace
    Команда `docker run --rm -ti tehbilly/htop` результатом своим показывает только запущенный процесс htop
  - Запуск контейнера в PID namespace хоста
    Команда `docker run --rm --pid host -ti tehbilly/htop` возвращает все процессы хост-системы

### Dockerfile

- Создан Dockerfile
  - Создан конфиг MongoDB [docker-monolith/mongod.conf](docker-monolith/mongod.conf)
  - Создан скрипт запуска приложения [docker-monolith/start.sh](docker-monolith/start.sh)
  - Создан скрипт с переменной окружения `DBATABASE_URL` [docker-monolith/db_config](docker-monolith/db_config)
  - Создан [docker-monolith/Dockerfile](docker-monolith/Dockerfile)
    - Основан на `ubuntu:16.04`
      ```dockerfile
      FROM ubuntu:16.04
      ```
    - Установка необходимых пакетов
      ```dockerfile
      RUN apt-get update
      RUN apt-get install -y mongodb-server ruby-full ruby-dev build-essential git
      RUN gem install bundler
      ```
    - Загрузка приложения
      ```dockerfile
      RUN git clone -b monolith https://github.com/express42/reddit.git
      ```
    - Копирование необходимых файлов в контейнер
      ```dockerfile
      COPY mongod.conf /etc/mongod.conf
      COPY db_config /reddit/db_config
      COPY start.sh /start.sh
      ```
    - Установка зависимостей приложения
      ```dockerfile
      RUN cd /reddit && bundle install
      RUN chmod 0777 /start.sh
      ```
    - Запуск приложения
      ```dockerfile
      CMD ["/start.sh"]
- Собран образ нашего приложения: `docker build -t reddit:latest .` (из дериктории нахождения Dockerfile, т.к. точка - дериктория, где расположен Dockerfile). `-t` - тег образа
- Запущен контейнер `docker run --name reddit -d --network=host reddit:latest`
- Проверен результат: `docker-machine ls`:
  ```shell
  NAME          ACTIVE   DRIVER   STATE     URL                        SWARM   DOCKER     ERRORS
  docker-host   *        google   Running   tcp://<мой_IP>:2376           v19.03.4
  ```
- При попытке зайти на `` не удалось открыть страницу
- Создано правило фаервола
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
- Сайт открыт успешно

### Docker hub
[Docker Hub ](https://hub.docker.com/) - это облачный registry сервис от компании Docker. В него можно выгружать и загружать из него докер образы. Docker по умолчанию скачивает образы из докер хаба.
- Выполнен вход на https://hub.docker.com/
- Выполнена авторизация docker на dockerhub `docker login`
- docker-образ загружен на докер хаб
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
- Выполнена попытка запустить образ на локальном докере
  ```shell
  docker run --name reddit -d -p 9292:9292 kazhem/otus-reddit:1.0
  ```
- Образ успешно скачался с docker hub и приложение запустилось
  ```shell
  curl 127.0.0.1:9292
  ```
- Выполнен ряд проверок
  - `docker logs reddit -f` следить за логами контейнера
  - `docker exec -it reddit bash` выполнить bash в запущенном контейнере
    - `ps aux` список процессов
    - `killall5 1` послать сигнал SIGHUP всем приложениям
  - `docker start reddit` запустить ранее созданный контейнер с именем `reddit`
  - `docker stop reddit && docker rm reddit` остановить и удалить контейнер `reddit`
  - `docker run --name reddit --rm -it kazhem/otus-reddit:1.0 bash` скачать и запустить контейнер `kazhem/otus-reddit:1.0` из docker hub, удалить после остановки, в контейнере запустить `bash` вместо инструкции `CMD`
    - `ps aux` список процессов
    - `exit` выйти (с завершением `bash`)
  - Проверка что контейнер остановлен и удалён
    ```shell
    # docker container ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    03a9eea159ef        ubuntu:16.04        "bash"              41 hours ago        Up 21 hours                             wonderful_blackwell
    ```
- И ещё
  - `docker inspect kazhem/otus-reddit:1.0` посмотреть подробную информацию об образе
  - `docker inspect kazhem/otus-reddit:1.0 -f '{{.ContainerConfig.Cmd}}'` команда по-умолчанию при старте контейнера (директива `CMD` Dockerfile)
  - `docker run --name reddit -d -p 9292:9292 kazhem/otus-reddit:1.0` запустить контейнер
  - `docker exec -it reddit bash` запустить bash в уже запущенном контейнере
    - `mkdir /test1234` создать директорию /test1234 (внутри контейнера)
    - `touch /test1234/testfile` создать файл /test1234/testfile
    - `rmdir /opt` удалить лиректорию /opt
    - `exit` выйти из контейнера
  - `docker diff reddit` посмотреть изменения в перезаписываемом слое контейнера
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
  - `docker stop reddit && docker rm reddit` остановить и удалить контейнер
  - `docker run --name reddit --rm -it kazhem/otus-reddit:1.0 bash` снова запустить контейнер
  - `ls /` посмотреть содержимое корневой директории.
    Так как контейнер создан заново, /test1234 отсутствует, а /opt на месте

## HomeWork 13: Docker образы. Микросервисы

## Настройка

- Установлен Dockrfile linter [hadolint](https://github.com/hadolint/hadolint/releases/tag/v1.17.6)

#### Dockerfile best practices (collapsed)

<details><summary>Dockerfile best practices</summary>
<p>

https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

- [FROM](https://docs.docker.com/develop/develop-images/#from)

  We recommend the Alpine image as it is tightly controlled and small in size (currently under 5 MB), while still being a full Linux distribution.

- [LABEL](https://docs.docker.com/develop/develop-images/#label)

  For each label, add a line beginning with LABEL and with one or more key-value pairs.

- [RUN](https://docs.docker.com/develop/develop-images/#run)

  Always combine RUN apt-get update with apt-get install in the same RUN statement. For example:
  ```Dockerfile
    RUN apt-get update && apt-get install -y \
        package-bar \
        package-baz \
        package-foo
  ```
  You can also achieve cache-busting by specifying a package version. This is known as version pinning, for example:
  ```Dockerfile
  RUN apt-get update && apt-get install -y \
      package-bar \
      package-baz \
      package-foo=1.3.*
  ```

  If you want the command to fail due to an error at any stage in the pipe, prepend set -o pipefail && to ensure that an unexpected error prevents the build from inadvertently succeeding. For example:
  ```Dockerfile
  RUN set -o pipefail && wget -O - https://some.site | wc -l > /number
  ```

- [CMD](https://docs.docker.com/develop/develop-images/#cmd)

  `CMD` should almost always be used in the form of `CMD ["executable", "param1", "param2"…]`. Thus, if the image is for a service, such as Apache and Rails, you would run something like `CMD ["apache2","-DFOREGROUND"]`.

  `CMD` should rarely be used in the manner of `CMD ["param", "param"]` in conjunction with `ENTRYPOINT`.

- [EXPOSE](https://docs.docker.com/develop/develop-images/#expose)

  you should use the common, traditional port for your application
  For example, an image containing the Apache web server would use `EXPOSE 80`, while an image containing MongoDB would use `EXPOSE 27017` and so on.
  For container linking, Docker provides environment variables for the path from the recipient container back to the source (ie, `MYSQL_PORT_3306_TCP`).

- [ENV](https://docs.docker.com/develop/develop-images/#env)

  For example, `ENV PATH /usr/local/nginx/bin:$PATH` ensures that `CMD ["nginx"]` just works.

  The `ENV` instruction is also useful for providing required environment variables specific to services you wish to containerize, such as Postgres’s `PGDATA`.

  Lastly, `ENV` can also be used to set commonly used version numbers so that version bumps are easier to maintain. Similar to having constant variables in a program (as opposed to hard-coding values), this approach lets you change a single ENV instruction to auto-magically bump the version of the software in your container.

  Each `ENV` line creates a new intermediate layer, just like `RUN` commands. This means that even if you unset the environment variable in a future layer, it still persists in this layer and its value can be dumped. To prevent this, and really unset the environment variable, use a RUN command with shell commands.

- [ADD or COPY](https://docs.docker.com/develop/develop-images/#add-or-copy)

  Although `ADD` and `COPY` are functionally similar, generally speaking, `COPY` is preferred. That’s because it’s more transparent than ADD. COPY only supports the basic copying of local files into the container, while ADD has some features (like local-only tar extraction and remote URL support) that are not immediately obvious.
  Consequently, the best use for ADD is local tar file auto-extraction into the image, as in `ADD rootfs.tar.xz /`.

  If you have multiple `Dockerfile` steps that use different files from your context, `COPY` them individually, rather than all at once.
  For example:
  ```Dockerfile
  COPY requirements.txt /tmp/
  RUN pip install --requirement /tmp/requirements.txt
  COPY . /tmp/
  ```
  Results in fewer cache invalidations for the `RUN` step, than if you put the `COPY . /tmp/` before it.

  Because image size matters, using ADD to fetch packages from remote URLs is strongly discouraged; you should use curl or wget instead. That way you can delete the files you no longer need after they’ve been extracted and you don’t have to add another layer in your image.
  do something like:
  ```Dockerfile
  RUN mkdir -p /usr/src/things \
      && curl -SL http://example.com/big.tar.xz \
      | tar -xJC /usr/src/things \
      && make -C /usr/src/things all
  ```

- [ENTRYPOINT](https://docs.docker.com/develop/develop-images/#entrypoint)

  The best use for ENTRYPOINT is to set the image’s main command, allowing that image to be run as though it was that command (and then use CMD as the default flags).
  ```Dockerfile
  ENTRYPOINT ["s3cmd"]
  CMD ["--help"]
  ```

  Postgres official image `ENTRYPOINT`
  ```shell
  #!/bin/bash
  set -e

  if [ "$1" = 'postgres' ]; then
      chown -R postgres "$PGDATA"

      if [ -z "$(ls -A "$PGDATA")" ]; then
          gosu postgres initdb
      fi

      exec gosu postgres "$@"
  fi

  exec "$@"
  ```

  Configure app as PID 1
  This script uses [the `exec` Bash command](http://wiki.bash-hackers.org/commands/builtin/exec) so that the final running application becomes the container’s `PID 1`. This allows the application to receive any Unix signals sent to the container. For more, see the [`ENTRYPOINT` reference](https://docs.docker.com/engine/reference/builder/#entrypoint).

- [VOLUME](https://docs.docker.com/develop/develop-images/#volume)

  The VOLUME instruction should be used to expose any database storage area, configuration storage, or files/folders created by your docker container. You are strongly encouraged to use VOLUME for any mutable and/or user-serviceable parts of your image.

- [USER](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user)

  If a service can run without privileges, use `USER` to change to a non-root user. Start by creating the user and group in the Dockerfile with something like
  ```Dockerfile
  RUN groupadd -r postgres && useradd --no-log-init -r -g postgres postgres
  ```

  WARNING: [unresolved bug](https://github.com/golang/go/issues/13548)

  Avoid installing or using `sudo` as it has unpredictable TTY and signal-forwarding behavior that can cause problems. If you absolutely need functionality similar to `sudo`, such as initializing the daemon as root but running it as non-root, consider using `“gosu”`.

- [WORKDIR](https://docs.docker.com/develop/develop-images/#workdir)

  For clarity and reliability, you should always use absolute paths for your `WORKDIR`. Also, you should use `WORKDIR` instead of proliferating instructions like `RUN cd … && do-something`, which are hard to read, troubleshoot, and maintain.

- [ONBUILD](https://docs.docker.com/develop/develop-images/#onbuild)

  An `ONBUILD` command executes after the current `Dockerfile` build completes. `ONBUILD` executes in any child image derived FROM the current image. Think of the `ONBUILD` command as an instruction the parent `Dockerfile` gives to the child `Dockerfile`.
  `ONBUILD` is useful for images that are going to be built `FROM` a given image.
  [Ruby’s ONBUILD variants](https://github.com/docker-library/ruby/blob/c43fef8a60cea31eb9e7d960a076d633cb62ba8d/2.4/jessie/onbuild/Dockerfile)
  Images built with `ONBUILD` should get a separate tag, for example: `ruby:1.9-onbuild` or `ruby:2.0-onbuild`.

</p>
</details>

### Выполнение

#### Подготовка

- Скачан и распакован архив [microservices.zip](https://github.com/express42/reddit/archive/microservices.zip)
  ```shell
  wget https://github.com/express42/reddit/archive/microservices.zip && \
    unzip microservices.zip && \
    rm microservices.zip
  ```
- Каталог `reddit-microservices` переименован в `src`
  ```shell
  mv reddit-microservices src
  ```

- Создан файл [src/post-py/Dockerfile](src/post-py/Dockerfile)
- Создан файл [src/comment/Dockerfile](src/comment/Dockerfile)
- Создан файл [src/ui/Dockerfile](src/ui/Dockerfile)
- Все Докерфайлы оптимизированы в соответствии с [рекомендациями](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
- Скачан последний образ MongoDB
  ```shell
  docker pull mongo:latest
  ```

#### Сборка

- Собраны образы:
  ```
  docker build -t kazhem/post:1.0 ./post-py
  docker build -t kazhem/comment:1.0 ./comment
  docker build -t kazhem/ui:1.0 ./ui
  ```
  Сборка `ui` началась не с первого шага, потому что слой с установленным пакетом `build-essential` уже был создан на этапе сборки `comment`, а сейчас был взят из build-cache вместо ссборки с нуля.

#### Запуск

- Создана специальная сеть для приложения:
  ```
  docker network create reddit
  ```
- Запущены контейнеры:
  ```
  docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
  docker run -d --network=reddit --network-alias=post kazhem/post:1.0
  docker run -d --network=reddit --network-alias=comment kazhem/comment:1.0
  docker run -d --network=reddit -p 9292:9292 kazhem/ui:1.0
  ```
- Сайт работает

- Задание со *: Запустите контейнеры с другими сетевыми алиасами
  - В соответствие с [теорией](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file) добавлены environment переменные
    ```shell
    docker run -d \
      --network=reddit \
      --network-alias=posts_db1 \
      --network-alias=comment_db1 \
      mongo:latest
    docker run -d \
      --network=reddit \
      --network-alias=post1 \
      --env POST_DATABASE_HOST=posts_db1 \
      kazhem/post:1.0
    docker run -d \
      --network=reddit \
      --network-alias=comment1 \
      --env COMMENT_DATABASE_HOST=comment_db1 \
      kazhem/comment:1.0
    docker run -d \
      --network=reddit \
      --env POST_SERVICE_HOST=post1 \
      --env COMMENT_SERVICE_HOST=comment1 \
      -p 9292:9292 kazhem/ui:1.0
    ```
  - Сервис работает

#### Образы приложений

- Уменьшен образ `ui`, за счёт пересборки его на основе ubuntu:16.04
- Задание со *: Уменьшаем размер образов
  - На основе:
    - [Официальная wiki](https://wiki.alpinelinux.org/wiki)
    - [Статья на habr](https://habr.com/ru/company/digdes/blog/415279/)
    - [Статья на habr](https://habr.com/ru/company/digdes/blog/440658/)
    - [Получаем максимум от Docker. Микроконтейнеры и Alpine Linux](https://youtu.be/ClX9jbiVLaY)
  - Сделан вывод о том, что наиболее эффективным решением будет использование для приложений образов на основе alpine-linux
  - **ui**: Образ пересобран на базе ruby:2.2-alpine. Установка зависимостей потребовала установки build-base. Установка build-base, установка зависимостей и удаление build-base выполняется одной инструкцией RUN, чтобы избежать создания лишних образов.
  - Занимаемый объём уменьшился в 5 раз относительно ruby2.2 и в 3 раза относительно ubuntu:16.04
  - Такие же манипуляции были проделаны для commnent
  - Образ post уже был на основе alpine
  - Работоспособность проверена

#### Подключение volume
- Создан образ: `docker volume create reddit_db`
- Запущены контейнеры с подключенным volume:
  ```shell
    docker run -d \
      --network=reddit \
      --network-alias=post_db \
      --network-alias=comment_db \
      -v reddit_db:/data/db \
      mongo:latest
    docker run -d \
      --network=reddit \
      --network-alias=post \
      kazhem/post:1.0
    docker run -d \
      --network=reddit \
      --network-alias=comment \
      kazhem/comment:1.0
    docker run -d \
      --network=reddit \
  ```
- Написан пост
- При перезапуске пост не удален

## HomeWork 14: Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов

### Работа с сетями в Docker

- Подключились к нашей docker-machine: `eval $(docker-machine env docker-host)`
- Скачен образ, в который включены утилиты по работе с сетью `docker pull joffotron/docker-net-tools`

#### none

- Запущен контейнер с сетью `--network none` и выведен ifconfig
  ```
  docker run -ti --rm --network none joffotron/docker-net-tools -c "ifconfig; ping -c3 localhost;"

  lo      Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

  PING localhost (127.0.0.1): 56 data bytes
  64 bytes from 127.0.0.1: seq=0 ttl=64 time=0.046 ms
  64 bytes from 127.0.0.1: seq=1 ttl=64 time=0.079 ms
  64 bytes from 127.0.0.1: seq=2 ttl=64 time=0.092 ms

  --- localhost ping statistics ---
  3 packets transmitted, 3 packets received, 0% packet loss
  round-trip min/avg/max = 0.046/0.072/0.092 ms
  ```
  - Видим только `lo` интерфейс. Сетевой стек внутри контейнера работает.
  - Может быть применимо для тестирования или для фанимуляции с файлами в volume.

#### host

- Запуск контейнера в сетевом пространстве имён хоста
  ```
  docker run -ti --rm --network host joffotron/docker-net-tools -c ifconfig

  br-4abef5d88142 Link encap:Ethernet  HWaddr 02:42:20:9E:35:CC
            inet addr:172.18.0.1  Bcast:172.18.255.255  Mask:255.255.0.0
            inet6 addr: fe80::42:20ff:fe9e:35cc%32535/64 Scope:Link
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:4206 errors:0 dropped:0 overruns:0 frame:0
            TX packets:4245 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:253919 (247.9 KiB)  TX bytes:603308 (589.1 KiB)

  docker0   Link encap:Ethernet  HWaddr 02:42:E8:AC:84:5A
            inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
            inet6 addr: fe80::42:e8ff:feac:845a%32535/64 Scope:Link
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:18087 errors:0 dropped:0 overruns:0 frame:0
            TX packets:21428 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:1470987 (1.4 MiB)  TX bytes:523597801 (499.3 MiB)

  ens4      Link encap:Ethernet  HWaddr 42:01:0A:84:00:02
            inet addr:10.132.0.2  Bcast:10.132.0.2  Mask:255.255.255.255
            inet6 addr: fe80::4001:aff:fe84:2%32535/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1460  Metric:1
            RX packets:1086974 errors:0 dropped:0 overruns:0 frame:0
            TX packets:1022098 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000
            RX bytes:1553653174 (1.4 GiB)  TX bytes:353341844 (336.9 MiB)

  lo        Link encap:Local Loopback
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1%32535/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:3822104 errors:0 dropped:0 overruns:0 frame:0
            TX packets:3822104 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000
            RX bytes:518376223 (494.3 MiB)  TX bytes:518376223 (494.3 MiB)
  ```
- Сравнение результата с `docker-machine ssh docker-host ifconfig`:
  ```
  br-4abef5d88142 Link encap:Ethernet  HWaddr 02:42:20:9e:35:cc
            inet addr:172.18.0.1  Bcast:172.18.255.255  Mask:255.255.0.0
            inet6 addr: fe80::42:20ff:fe9e:35cc/64 Scope:Link
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:4206 errors:0 dropped:0 overruns:0 frame:0
            TX packets:4245 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:253919 (253.9 KB)  TX bytes:603308 (603.3 KB)

  docker0   Link encap:Ethernet  HWaddr 02:42:e8:ac:84:5a
            inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
            inet6 addr: fe80::42:e8ff:feac:845a/64 Scope:Link
            UP BROADCAST MULTICAST  MTU:1500  Metric:1
            RX packets:18087 errors:0 dropped:0 overruns:0 frame:0
            TX packets:21428 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:0
            RX bytes:1470987 (1.4 MB)  TX bytes:523597801 (523.5 MB)

  ens4      Link encap:Ethernet  HWaddr 42:01:0a:84:00:02
            inet addr:10.132.0.2  Bcast:10.132.0.2  Mask:255.255.255.255
            inet6 addr: fe80::4001:aff:fe84:2/64 Scope:Link
            UP BROADCAST RUNNING MULTICAST  MTU:1460  Metric:1
            RX packets:1087074 errors:0 dropped:0 overruns:0 frame:0
            TX packets:1022202 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000
            RX bytes:1553673066 (1.5 GB)  TX bytes:353357733 (353.3 MB)

  lo        Link encap:Local Loopback
            inet addr:127.0.0.1  Mask:255.0.0.0
            inet6 addr: ::1/128 Scope:Host
            UP LOOPBACK RUNNING  MTU:65536  Metric:1
            RX packets:3822104 errors:0 dropped:0 overruns:0 frame:0
            TX packets:3822104 errors:0 dropped:0 overruns:0 carrier:0
            collisions:0 txqueuelen:1000
            RX bytes:518376223 (518.3 MB)  TX bytes:518376223 (518.3 MB)
  ```
- Как можно видеть - выводы команд идентичны
- Запущен nginx:
  ```
  docker run --network host -d nginx
  ...
  docker ps
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
  d1b37b918d5c        nginx               "nginx -g 'daemon of…"   11 seconds ago      Up 6 seconds                            objective_ardinghelli
  ```
- Еще раз (и еще и еще):
  ```
  docker run --network host -d nginx
  ...
  docker ps
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
  d1b37b918d5c        nginx               "nginx -g 'daemon of…"   2 minutes ago       Up About a minute                       objective_ardinghelli
  ```
- Причина падения: уже занятый 80й порт nginx:
  ```
  docker logs 35048cdbc56dd88d2a7915a91bfd726b8aa449c1ba0ad810f26aaedc5d33daf8
  2020/05/28 17:24:28 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
  nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
  2020/05/28 17:24:28 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
  nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
  2020/05/28 17:24:28 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
  nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
  2020/05/28 17:24:28 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
  nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
  2020/05/28 17:24:28 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
  nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
  2020/05/28 17:24:28 [emerg] 1#1: still could not bind()
  nginx: [emerg] still could not bind()
  ```

#### network namespaces

- на docker-host создан симлинк, позволяющий видеть неймспейсы командой `sudo ip netns`
  ```shell
  sudo ln -s /var/run/docker/netns /var/run/netns
  ```
- список неймспейсов без запущенных контейнеров
  ```shell
  $ sudo ip netns
  default
  ```
- список неймспейсов при запущенном контейнере с сетью `none`
  ```shell
  docker run --network none -d nginx
  docker ps
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
  c9001dd09630        nginx               "nginx -g 'daemon of…"   5 minutes ago       Up 5 minutes                            flamboyant_pare
  ```
  на docker-machine
  ```shell
  $ sudo ip netns
  37dd29ce75b0
  default
  ```
  видим, появился новый namespace. Запускаем ещё один контейнер
  ```shell
  docker run --network none -d nginx

  fd86c1feb833eddf42ea35ee61a2d417ce66b361a003b4d2dc3f7be9a0cb87a6
  ```
  ```shell
  docker ps

  CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
  fd86c1feb833        nginx               "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes                            affectionate_cartwright
  c9001dd09630        nginx               "nginx -g 'daemon of…"   10 minutes ago      Up 10 minutes                           flamboyant_pare
  ```
  на docker-machine
  ```shell
  $ sudo ip netns
  71eccd0c6e82
  37dd29ce75b0
  defaul
  ```
  видим 2 неймспейса
- С помощью драйвера host:
  ```shell
  docker run --network host -d nginx
  3c5a8a67b8085f45e284fe135d144146fd370aaf8bc7d23471c230107e120c15

  docker ps
  CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
  3c5a8a67b808        nginx               "nginx -g 'daemon of…"   18 seconds ago      Up 16 seconds                           jolly_ganguly


  sudo ip netns
  default
  ```
  Неймспейс создан не был, т.к. используется неймспейс хоста

#### bridge

- Создана `bridge`-сеть в docker (флаг --driver указывать необязательно, т.к. по-умолчанию используется `bridge` )
  ```shell
  docker network create reddit --driver bridge
  ```
  ```shell
  docker network ls
  NETWORK ID          NAME                DRIVER              SCOPE
  4467ddd9adef        bridge              bridge              local
  96b77beda115        host                host                local
  d887c4b80a32        none                null                local
  4abef5d88142        reddit              bridge              local
  ```
  - Зпущены контейнеры:
  ```shell
  docker run -d \
      --network=reddit \
      --network-alias=post_db \
      --network-alias=comment_db \
      -v reddit_db:/data/db \
      mongo:latest
    docker run -d \
      --network=reddit \
      --network-alias=post \
      kazhem/post:1.0
    docker run -d \
      --network=reddit \
      --network-alias=comment \
      kazhem/comment:1.0
    docker run -d \
      --network=reddit \
      -p 9292:9292 kazhem/ui:1.0
  ```
  ```shell
  # docker ps
  CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
  ffade2c9f69c        kazhem/ui:1.0        "puma"                   7 seconds ago       Up 2 seconds        0.0.0.0:9292->9292/tcp   pensive_bose
  941445b67c3d        kazhem/comment:1.0   "puma"                   15 seconds ago      Up 11 seconds                                busy_wiles
  8efbca335498        kazhem/post:1.0      "python3 post_app.py"    28 seconds ago      Up 24 seconds                                happy_ride
  d61a2c5edd55        mongo:latest         "docker-entrypoint.s…"   46 seconds ago      Up 42 seconds       27017/tcp                eloquent_merkle
  ```
- Приложение доступно по http://<мой_IP>:9292/
- Cозданы 2 новые docker сети:
  ```shell
  docker network create front_net --subnet=10.0.1.0/24
  8bcb08a45409561643017a1b8dfaf2b854f678672ad3afce7f2a1851fc4745ae

  docker network create front_net --subnet=10.0.1.0/24
  cd4d6276466d31349c30f4c26638e008157e760d59548218272bab612dd1d5b7

  docker network ls
  NETWORK ID          NAME                DRIVER              SCOPE
  8bcb08a45409        back_net            bridge              local
  4467ddd9adef        bridge              bridge              local
  cd4d6276466d        front_net           bridge              local
  96b77beda115        host                host                local
  d887c4b80a32        none                null                local
  4abef5d88142        reddit              bridge              local
  ```
- Запущены контейнеры с новыми сетями
  ```shell
  docker run -d \
    --network=back_net \
    --network-alias=post_db \
    --network-alias=comment_db \
    -v reddit_db:/data/db \
    --name mongo_db \
    mongo:latest
  docker run -d \
    --network=back_net \
    --network-alias=post \
    --name post \
    kazhem/post:1.0
  docker run -d \
    --network=back_net \
    --network-alias=comment \
    --name comment \
    kazhem/comment:1.0
  docker run -d \
    --network=front_net \
    -p 9292:9292 \
    --name ui \
    kazhem/ui:1.0

  docker ps
  CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
  7b9ff340b248        kazhem/ui:1.0        "puma"                   10 seconds ago      Up 7 seconds        0.0.0.0:9292->9292/tcp   ui
  6380a7fda63d        kazhem/comment:1.0   "puma"                   19 seconds ago      Up 15 seconds                                comment
  5c73617ef09d        kazhem/post:1.0      "python3 post_app.py"    29 seconds ago      Up 26 seconds                                post
  dddf1b98373a        mongo:latest         "docker-entrypoint.s…"   42 seconds ago      Up 39 seconds       27017/tcp                mongo_db
  ```
  - Контейнер `ui` подключен к сети reddit_front.
  - Остальные контейнеры подключены к сети reddit_back
- Docker при инициализации контейнера может подключить к нему только 1 сеть. При этом контейнеры из соседних сетей не будут доступны как в DNS, так и для взаимодействия по сети. Поэтому нужно поместить контейнеры `post` и `comment` в обе сети.
  ```shell
  docker network connect front_net post
  docker network connect front_net comment
  ```
- Приложение теперь работает

#### Анализ bridge

- На docker-machine установлена утилита `bridge-utils`:
  ```shell
  sudo apt-get update && sudo apt-get install bridge-utils
  ```
- Список docker-сетей на docker-machine:
  ```shell
  # docker network ls
  NETWORK ID          NAME                DRIVER              SCOPE
  8bcb08a45409        back_net            bridge              local
  4467ddd9adef        bridge              bridge              local
  cd4d6276466d        front_net           bridge              local
  96b77beda115        host                host                local
  d887c4b80a32        none                null                local
  4abef5d88142        reddit              bridge              local
  ```
- Список br-* интерфейсов на docker-machine:
  ```shell
  ifconfig | grep br
  br-4abef5d88142 Link encap:Ethernet  HWaddr 02:42:20:9e:35:cc
  br-8bcb08a45409 Link encap:Ethernet  HWaddr 02:42:a2:a9:b1:5b
  br-cd4d6276466d Link encap:Ethernet  HWaddr 02:42:3e:3c:75:73
  ```
  имена интефейсов бриджей совпадают с id сетей
- Более подробная информация для интерфейса сети front_net:
  ```shell
  brctl show br-cd4d6276466d
  bridge name             bridge id         STP enabled   interfaces
  br-cd4d6276466d         8000.02423e3c7573       no      veth64fadca
                                                          veth674db80
                                                          vethbf0d4e8
  ```
- Более подробная информация для интерфейса сети back_net:
  ```shell
  brctl show br-8bcb08a45409
  bridge name             bridge id         STP enabled   interfaces
  br-8bcb08a45409         8000.0242a2a9b15b       no      veth4907c5f
                                                          veth75d3eff
                                                          vethc4da533
  ```
- iptables:
  ```shell
  docker-user@docker-host:~$ sudo iptables -vnL -t nat
  Chain PREROUTING (policy ACCEPT 13088 packets, 788K bytes)
  pkts bytes target     prot opt in     out     source               destination
  70478 4414K DOCKER     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

  Chain INPUT (policy ACCEPT 211 packets, 16556 bytes)
  pkts bytes target     prot opt in     out     source               destination

  Chain OUTPUT (policy ACCEPT 340 packets, 21882 bytes)
  pkts bytes target     prot opt in     out     source               destination
      0     0 DOCKER     all  --  *      *       0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

  Chain POSTROUTING (policy ACCEPT 13118 packets, 789K bytes)
  pkts bytes target     prot opt in     out     source               destination
    692 35641 MASQUERADE  all  --  *      !br-cd4d6276466d  10.0.1.0/24          0.0.0.0/0
      0     0 MASQUERADE  all  --  *      !br-8bcb08a45409  10.0.2.0/24          0.0.0.0/0
  3922  214K MASQUERADE  all  --  *      !br-4abef5d88142  172.18.0.0/16        0.0.0.0/0
    574 34799 MASQUERADE  all  --  *      !docker0  172.17.0.0/16        0.0.0.0/0
      0     0 MASQUERADE  tcp  --  *      *       10.0.1.2             10.0.1.2             tcp dpt:9292

  Chain DOCKER (2 references)
  pkts bytes target     prot opt in     out     source               destination
      0     0 RETURN     all  --  br-cd4d6276466d *       0.0.0.0/0            0.0.0.0/0
      0     0 RETURN     all  --  br-8bcb08a45409 *       0.0.0.0/0            0.0.0.0/0
      0     0 RETURN     all  --  br-4abef5d88142 *       0.0.0.0/0            0.0.0.0/0
      0     0 RETURN     all  --  docker0 *       0.0.0.0/0            0.0.0.0/0
      2   104 DNAT       tcp  --  !br-cd4d6276466d *       0.0.0.0/0            0.0.0.0/0            tcp dpt:9292 to:10.0.1.2:9292

  ```
  - здесь видно, что перед определением маршрута, весь трафик с `dst-type LOCAL` попадает в цепочку `DOCKER`, в которой
    - возвращается обратно в `PREROUTING`, если пришёл с одного из docker-бриджей
    - если пришёл не с `reddit_front` и на tcp-порт 9292, выполняется редирект на `10.0.1.2:9292` (ui)
  - в цепочке `POSTROUTING` трафик, исходящий из docker-сетей маскируется перед выходом с других интерфейсов
    - так же маскируется трафик между любыми интерфейсами с ip 10.0.1.2 на тот же ip 10.0.1.2 порт назначения tcp 9292
  - `docker-proxy` слушает порт 9292 для перенаправления трафика:
  ```shell
  docker-user@docker-host:~$ ps ax | grep docker-proxy
  18969 ?        Sl     0:00 /usr/bin/docker-proxy -proto tcp -host-ip 0.0.0.0 -host-port 9292 -container-ip 10.0.1.2 -container-port 9292
  ```

### Docker-compose

- Создан [src/docker-compose.yml](src/docker-compose.yml)
- Экспортирована env переменная `export USERNAME=kazhem`
- Запущены контейнеры с помощью `docker-compose`
  - спрвка: для zsh, при ошибке TLS надо экпортиовать `export COMPOSE_TLS_VERSION=TLSv1_2`
  ```shell
  # docker-compose up -d
  Creating network "src_reddit" with the default driver
  Creating volume "src_post_db" with default driver
  Pulling post_db (mongo:3.2)...
  3.2: Pulling from library/mongo
  a92a4af0fb9c: Pull complete
  74a2c7f3849e: Pull complete
  927b52ab29bb: Pull complete
  e941def14025: Pull complete
  be6fce289e32: Pull complete
  f6d82baac946: Pull complete
  7c1a640b9ded: Pull complete
  e8b2fc34c941: Pull complete
  1fd822faa46a: Pull complete
  61ba5f01559c: Pull complete
  db344da27f9a: Pull complete
  Digest: sha256:0463a91d8eff189747348c154507afc7aba045baa40e8d58d8a4c798e71001f3
  Status: Downloaded newer image for mongo:3.2
  Creating src_post_1 ...
  Creating src_post_1
  Creating src_ui_1 ...
  Creating src_post_db_1 ...
  Creating src_post_db_1
  Creating src_ui_1
  Creating src_comment_1 ...
  Creating src_post_1 ... done

  #docker ps
  CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                    NAMES
  3128ffcac1d7        kazhem/comment:1.0   "puma"                   2 minutes ago       Up 2 minutes                                 src_comment_1
  b7bc0f69996b        kazhem/ui:1.0        "puma"                   2 minutes ago       Up 2 minutes        0.0.0.0:9292->9292/tcp   src_ui_1
  5f2066ae832c        mongo:3.2            "docker-entrypoint.s…"   2 minutes ago       Up 2 minutes        27017/tcp                src_post_db_1
  10b87588e607        kazhem/post:1.0      "python3 post_app.py"    2 minutes ago       Up 2 minutes                                 src_post_1
  ```
- Сервис работает

#### Переменные окружения

Приоритет источников для значения переменных в контейнере:

When you set the same environment variable in multiple files, here’s the priority used by Compose to choose which value to use:

1. Compose file
2. Shell environment variables
3. Environment file
4. Dockerfile
5. Variable is not defined

- Подробнее про
  - переменные окружения https://docs.docker.com/compose/environment-variables/
  - подстановку переменных окружения https://docs.docker.com/compose/compose-file/#variable-substitution
    > Important: The .env file feature only works when you use the docker-compose up command and does not work with docker stack deploy.
  - `docker-compose config` чтобы посмотреть отрезолвленный compose-файл https://docs.docker.com/compose/reference/config/
  - Compose CLI environment variables https://docs.docker.com/compose/reference/envvars/
- Создан файл [src/.env](src/.env) со значениями переменных по умолчанию
- Параметризованы следующие параметры
  - `MONGO_VERSION=3.2` - версия mongodb
  - `UI_VERSION=1.0` - версия ui
  - `POST_VERSION=1.0` - версия post-py
  - `COMMENT_VERSION=1.0` - версия comment
  - `UI_PORT=9292` - порт публикации ui
  - `USERNAME=kazhem` - имя пользователя для подстановки в имя образа.
    Например `image: ${USERNAME}/ui:${UI_VERSION}`
- Docker-compose запущен, сервис работает

#### Имя проекта

- https://docs.docker.com/compose/#multiple-isolated-environments-on-a-single-host
- Имя проекта по умолчанию берётся из `basename` директории проекта
- Переопределить имя проекта можно
  - using the [-p command line option](https://docs.docker.com/compose/reference/overview/)
  - using [COMPOSE_PROJECT_NAME environment variable](https://docs.docker.com/compose/reference/envvars/#compose_project_name)

### Задание со \*: docker-compose.override.yml

[Share Compose configurations between files and projects](https://docs.docker.com/compose/extends/)

By default, Compose reads two files, a docker-compose.yml and an optional docker-compose.override.yml file.
If a service is defined in both files, Compose merges the configurations.
To use multiple override files, or an override file with a different name, you can use the -f option to specify the list of files. Compose merges files in the order they’re specified on the command line.

- Добавлен файл docker-compose.override.yml](src/docker-compose.override.yml)
- В [docker-compose.override.yml](src/docker-compose.override.yml) переопределены следующие параметры:
  - В `/app` контейнера `post` монтируется локальная директория `./post-py`
  - В `/app` контейнера `comment` монтируется локальная директория `./comment`
  - Сервис `puma` в `ui` запускается с параметрами `--debug -w 2`
- В [src/docker-compose.override.yml](src/docker-compose.override.yml) описание сервисов помещено в секцию `services:`
- Для каждого сервиса в docker-compose.override.yml](src/docker-compose.override.yml) директория с кодом монтируется в директорию, указанную в соответтсвующей переменной окружения

- **ВАЖНО** не работает из коробки с docker-machine, необходимо смотреть[docker-machine mount](https://docs.docker.com/machine/reference/mount/)


## HomeWork 15: Устройство Gitlab CI. Построение процесса непрерывной интеграции


### Подготовка
* Packer'ом подготвлен образ c предустановленным docker (с помощью ansible)
  * [packer](gitlab-ci/packer)
  * [ansible](gitlab-ci/ansible)
* Развернут инстанс на GCP с помощью [terraform](gitla-ci/terraform)

### Инсталляция Gitlab CI
Все действия выполняются на удалённой машине, развёрнутой в предыдущем пункте

- Созданы необходимые директории
  ```shell
  sudo mkdir -p /srv/gitlab/config /srv/gitlab/data /srv/gitlab/logs
  cd /srv/gitlab/
  sudo touch docker-compose.yml
  ```
- Содержимое `docker-compose.yml` на основе файла из [документации](https://docs.gitlab.com/omnibus/docker/README.html#install-gitlab-using-docker-compose)
  ```yaml
  web:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://35.187.77.192'
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
    ports:
      - '80:80'
      - '443:443'
      - '2222:22'
    volumes:
      - '/srv/gitlab/config:/etc/gitlab'
      - '/srv/gitlab/logs:/var/log/gitlab'
      - '/srv/gitlab/data:/var/opt/gitlab'
  ```
- Запущено развёртывание `sudo docker-compose up -d`
- Спустя несколько минут установка завершена
  ```shell
  appuser@gitlab-stage-001:/srv/gitlab$ sudo docker-compose up -d
  Pulling web (gitlab/gitlab-ce:latest)...
  latest: Pulling from gitlab/gitlab-ce
  e92ed755c008: Pull complete
  b9fd7cb1ff8f: Pull complete
  ee690f2d57a1: Pull complete
  53e3366ec435: Pull complete
  4e082d9ef448: Pull complete
  108285b4c8fb: Pull complete
  23c976adea47: Pull complete
  aec9168cdc19: Pull complete
  a1dbce85ed8f: Pull complete
  1597ce8b7a37: Pull complete
  Digest: sha256:6042d80d1c00c70a3508d5b10a213f481d788bbf716478c3ed1437141d490cb6
  Status: Downloaded newer image for gitlab/gitlab-ce:latest
  Creating gitlab_web_1 ... done
  ```
- В [веб интерфейсе](http://35.187.77.192) задан пароль для пользователя `root` (пользователь по умолчанию)
- Успешно выполнен вход
- Отменена возможность регистрации новых пользователей
  *settings -> general -> sign-up restrictions ->sign-up enabled = false*, *save changes*
- Изменён логин пользователя *Administrator* чтобы усложнить подбор пароля перебором (admin -> users -> Administrator -> Edit)
- Добавлен SSH ключ в настройках пользователя
- В `docker-comnpose.yml` добавлен параметр `gitlab_rails['gitlab_shell_ssh_port'] = 2222` для работы с git-репозиторием через ssh по порту `2222`

### Создание проекта

- Создана приватная группа `homework`
- Создан приватный проект `example`
- В репозиторий `kazhem_microservices` добавлен удалённый репозиторий созданного проекта
  ```shell
  git remote add gitlab http://35.187.77.192/homework/example.git
  git push gitlab gitlab-ci-1
  ```
- Добавлен [.gitlab-ci.yml](.gitlab-ci.yml) содержащий шаблон пайплайна
```yaml
stages:
  - build
  - test
  - deploy

build_job:
  stage: build
  script:
    - echo 'Building'

test_unit_job:
  stage: test
  script:
    - echo 'Testing 1'

test_integration_job:
  stage: test
  script:
    - echo 'Testing 2'

deploy_job:
  stage: deploy
  script:
    - echo 'Deploy'
```
- Запушен в репозиторий
- Pipeline не работает, т.к. нет runners

### Runner

- На хосте с gitlab запущен раннер
  ```shell
  docker run -d --name gitlab-runner --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest
  ```
- Раннер зарегистрирован в gitlab
  ```shell
  docker exec -it gitlab-runner gitlab-runner register --run-untagged --locked=false
  ```
  ```shell
  Runtime platform                                    arch=amd64 os=linux pid=13 revision=c127439c version=13.0.0
  Running in system-mode.

  Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
  http://35.187.77.192
  Please enter the gitlab-ci token for this runner:
  <token>
  Please enter the gitlab-ci description for this runner:
  [f05ea118d88e]: my-runner
  Please enter the gitlab-ci tags for this runner (comma separated):
  linux,xenial,ubuntu,docker
  Registering runner... succeeded                     runner=Dow-mDat
  Please enter the executor: docker, shell, docker-ssh+machine, virtualbox, docker+machine, kubernetes, custom, docker-ssh, parallels, ssh:
  docker
  Please enter the default Docker image (e.g. ruby:2.6):
  alpine:latest
  Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
  ```
- Пайплайн автоматически был запущен и выполнен успешно

### Тестирование Reddit

- Код приложения склонирован из репозитория
```shell
git clone https://github.com/express42/reddit.git && rm -rf ./reddit/.git
git add reddit/
git commit -m "Add reddit app"
git push gitlab gitlab-ci-1
```
- В [.gitlab-ci.yml](.gitlab-ci.yml) добавлены элементы пайпалйна для тестирования приложения. Новое содержимое
  ```yaml
  ---
  image: ruby:2.4.2

  stages:
    - build
    - test
    - deploy

  variables:
    DATABASE_URL: "mongodb://mongo/user_posts"

  before_script:
    - cd reddit
    - bundle install

  build_job:
    stage: build
    script:
      - echo 'Building'

  test_unit_job:
    stage: test
    services:
      - mongo:latest
    script:
      - ruby simpletest.rb
      # - echo 'Testing 1'

  test_integration_job:
    stage: test
    script:
      - echo 'Testing 2'

  deploy_job:
    stage: deploy
    script:
      - echo 'Deploy'
  ```
- В [reddit/simpletest.rb](reddit/simpletest.rb) добавлен простой тест
  ```ruby
  require_relative './app'
  require 'test/unit'
  require 'rack/test'

  set :environment, :test

  class MyAppTest < Test::Unit::TestCase
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    def test_get_request
      get '/'
      assert last_response.ok?
    end
  end
  ```
- В [reddit/Gemfile](reddit/Gemfile) добавлена библиотека для тестирования
  ```ruby
  gem 'rack-test'
  ```
- Изменения закоммичены и запушены в gitlab
  ```shell
  git add .
  git ci -m"Add reddit app tests to pipeline"
  git push gitlab gitlab-ci-1
  ```
- Job succeeded

### Работа с окружениями

#### dev

- В [.gitlab-ci.yml](.gitlab-ci.yml) stage `deploy` переименован в `review`
  ```yaml
  stages:
    - build
    - test
    - review
  ```
- Job `deploy_job` переименован в `deploy_dev_job` и приведён к следующему виду
  ```yaml
  deploy_dev_job:
    stage: review
    script:
      - echo 'Deploy'
    environment:
      name: dev
      url: http://dev.example.com
  ```
- Выполнен commit и push
  ```shell
  git add .
  git ci -m"Add deploy dev environment"
  git push gitlab gitlab-ci-1
  ```
- В проекте в *operations* -> *environments* появилось окружение **dev**
- При нажатии на *View deployment* происходит переход на указанный url

#### staging и production

- В [.gitlab-ci.yml](.gitlab-ci.yml) добавлены jobs `staging` и `production`
  ```yaml
  staging:
    stage: stage
    when: manual  # ручной запуск
    script:
      - echo 'Deploy'
    environment:
      name: stage
      url: https://beta.example.com

  production:
    stage: production
    when: manual  # ручной запуск
    script:
      - echo 'Deploy'
    environment:
      name: production
      url: https://example.com
  ```
- Стадии stage и production были запущены вручную
- В оба стейджа добавлено условие возможности запуска только с тэгом, соответствуюжем трйм числам, раздёлённым точкой
  ```yaml
  only:
    - /^\d+\.\d+\.\d+/
  ```
- После пуша без тега, стадии stage и production недоступны
- Выполнен пуш с тегом
  ```shell
  git add .
  git commit -m "Add tag and push"
  git tag 2.4.10
  git push gitlab gitlab-ci-1
  git push gitlab gitlab-ci-1 --tags
  ```
- Для job-а с тегом снова доступны стадии stage и prod

#### Динамические окружения

- Добавлен job `branch review`
  ```yaml
  branch review:
    stage: review  # имя стадии
    script: echo "Deploy to $CI_ENVIRONMENT_SLUG"
    environment:
      name: branch/$CI_COMMIT_REF_NAME  # имя бренча в имени окружения
      url: http://$CI_ENVIRONMENT_SLUG.example.com  # имя бренча в url
    only:
      - branches  # запуск для каждой ветки репозитория
    except:
      - master  # не запускать для мастера
  ```
  Этот job определяет динамическое окружение для каждой ветки в репозитории, кроме ветки master
- Проверено: была создана ветка `new-feature`. Создалось 2 окружения
  - `branch/gitlab-ci-1` для текущего бренча
  - `branch/new-feature` для созданного бренча


### Задание со *: Сборка контейнера с приложением reddit

- На основе:
  - [ссылка](https://stanislas.blog/2018/09/build-push-docker-images-gitlab-ci/)
  - [документация](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html)
- На сервере создан docker-compose.yml в папке /srv/gitlab-ruuner:
  ```yaml
  ---
  version: '3.3'

  services:
    gitlab-runner:
      image: gitlab/gitlab-runner:latest
      container_name: gitlab_runner
      restart: always
      volumes:
        - ./config/:/etc/gitlab-runner/
        - /var/run/docker.sock:/var/run/docker.sock
  ```
- Для регистрации runner (см выше) можно также использовать команду:
  ```shell
  docker-compose run --rm gitlab-runner register -n \
    --url http://35.187.77.192/ \
    --registration-token Dow <token> \
    --executor docker \
    --description "Kazhem Docker Runner" \
    --docker-image "docker:stable" \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock
  ```
- Job build теперь выглядит так:
  ```yaml
  build_job:
  stage: build
  script:
    # login
    - docker info
    - docker login -u $REGISTRY_USER -p $REGISTRY_PASSWORD
    # build
    - cd ./src
    - docker build -t ${REGISTRY_USER}/post:${CI_COMMIT_REF_NAME} ./post-py
    - docker build -t ${REGISTRY_USER}/comment:${CI_COMMIT_REF_NAME} ./comment
    - docker build -t ${REGISTRY_USER}/ui:${CI_COMMIT_REF_NAME} ./ui
    # push
    - docker push ${REGISTRY_USER}/post:${CI_COMMIT_REF_NAME}
    - docker push ${REGISTRY_USER}/comment:${CI_COMMIT_REF_NAME}
    - docker push ${REGISTRY_USER}/ui:${CI_COMMIT_REF_NAME}
  ```
  - В проект добавлены переменные `REGISTRY_USER` и `REGISTRY_PASSWORD`
  - Коммитится в dockerhub


## HomeWork 16: Введение в мониторинг. Системы мониторинга.

### Prometheus: запуск, конфигурация, знакомство с Web UI

#### Запуск docker-machine хоста для prometheus

Создадим правило фаервола для Prometheus и Puma:

```shell
gcloud compute firewall-rules create prometheus-default --allow tcp:9090
gcloud compute firewall-rules create puma-default --allow tcp:9292
```

Создадим Docker хост в GCE и настроим локальное окружение на работу с ним
```shell
export GOOGLE_PROJECT=<project_id>

docker-machine create --driver google \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
  --google-machine-type n1-standard-1 \
  --google-zone europe-west1-b \
  docker-host

eval $(docker-machine env docker-host)
```
#### Запуск prometheus

Систему мониторинга Prometheus будем запускать внутри Docker контейнера. Для начального знакомства воспользуемся готовым образом с DockerHub (использована последняя версия - более новая версия, чем в ДЗ)
```shell
docker run --rm -p 9090:9090 -d --name prometheus prom/prometheus:v2.14.0
```
```log
Digest: sha256:907e20b3b0f8b0a76a33c088fe9827e8edc180e874bd2173c27089eade63d8b8
Status: Downloaded newer image for prom/prometheus:v2.14.0
ba7f92afa8bc8e3542d60f25faae8f76f1459fa3ea2aeb5c4e954b2bda73957c
```

Список запущенных контейнеров
```shell
docker ps
```
```log
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                    NAMES
ba7f92afa8bc        prom/prometheus:v2.14.0   "/bin/prometheus --c…"   49 seconds ago      Up 45 seconds       0.0.0.0:9090->9090/tcp   prometheus
```

#### Web-интерфейс
IP запущенной docker-machine
```shell
docker-machine ip docker-host
```
```log
34.78.188.236
```

Веб-интерфейс открыт http://34.78.188.236:9090

По умолчанию prometheus собирает статистику о своей работе. Выберем, например, метрику `prometheus_build_info` и нажмем Execute, чтобы посмотреть информацию о версии.
```log
prometheus_build_info{branch="HEAD",goversion="go1.9.2",instance="localhost:9090",job="prometheus",revision="85f23d82a045d103ea7f3c89a91fba4a93e6367a",version="2.1.0"} 1
```

`prometheus_build_info` - название метрики - идентификатор собранной информации.

`branch`, `goversion`, `instance`, etc... - лейбл - добавляет метаданных метрике, уточняет ее. Использование лейблов дает нам возможность не ограничиваться лишь одним названием метрик для идентификации получаемой информации. Лейблы содержаться в `{}` скобках и представлены наборами "ключ=значение".

`1` - значение метрики - численное значение метрики, либо NaN, если значение недоступно

#### Targets

Targets (цели) - представляют собой системы или процессы, за которыми следит Prometheus. Помним, что Prometheus является pull системой, поэтому он постоянно делает HTTP запросы на имеющиеся у него адреса (endpoints). Посмотрим текущий список целей:

Status -> Targets

В Targets сейчас мы видим только сам Prometheus. У каждой цели есть свой список адресов _(endpoints)_, по которым следует обращаться для получения информации.

В веб интерфейсе мы можем видеть состояние каждого endpoint-а (up); лейбл (`instance="someURL"`), который Prometheus автоматически добавляет к каждой метрике, получаемой с данного endpoint-а; а также время, прошедшее с момента последней операции сбора информации с endpoint-а.

Также здесь отображаются ошибки при их наличии и можно отфильтровать только неживые таргеты.

Обратите внимание на endpoint, который мы с вами видели на предыдущем слайде.

Мы можем открыть страницу в веб браузере по данному HTTP пути (host:port/metrics), чтобы посмотреть, как выглядит та информация, которую собирает Prometheus. **Примечение** В веб-интерфейсе отображается url http://localhost:9090/metrics, который ссылается на localhost вместо ip удалённого интсанса. Чтобы посмотреть метрики, необходимо вручную указать ip http://34.78.188.236:9090/metrics
  ```log
  # HELP go_gc_duration_seconds A summary of the GC invocation durations.
  # TYPE go_gc_duration_seconds summary
  go_gc_duration_seconds{quantile="0"} 1.6556e-05
  go_gc_duration_seconds{quantile="0.25"} 2.6098e-05
  go_gc_duration_seconds{quantile="0.5"} 2.7583e-05
  go_gc_duration_seconds{quantile="0.75"} 2.9423e-05
  go_gc_duration_seconds{quantile="1"} 8.8754e-05
  go_gc_duration_seconds_sum 0.858655005
  go_gc_duration_seconds_count 31595
  ...
  ```
Остановим контейнер
```shell
docker stop prometheus
```

### Мониторинг состояния микросервисов

#### Переупорядочим структуру директорий

До перехода к следующему шагу приведем структуру каталогов в более четкий/удобный вид:

1. Создадим директорию [docker](docker) в корне репозитория и перенесем в нее директорию `docker-monolith` и файлы `docker-compose.*` и все `.env` (`.env` должен быть в [.gitgnore](.gitgnore)), в репозиторий закоммичен [.env.example](.env.example), из которого создается `.env`
2. Создадим в корне репозитория директорию [monitoring](monitoring). В ней будет хранится все, что относится к мониторингу
3. Не забываем про [.gitgnore](.gitgnore) и актуализируем записи при необходимости (добавлена запись `.env`)

**P.S.** С этого момента сборка сервисов отделена от `docker-compose`, поэтому инструкции `build` **удалены** из [src/docker-compose.yml](src/docker-compose.yml).

#### Создание Docker образа

Познакомившись с веб интерфейсом Prometheus и его стандартной конфигурацией, соберем на основе готового образа с DockerHub свой Docker образ с конфигурацией для мониторинга наших микросервисов.

Создайте директорию [monitoring/prometheus](monitoring/prometheus). Затем в этой директории создайте простой [Dockerfile](monitoring/prometheus/Dockerfile), который будет копировать файл конфигурации с нашей машины внутрь контейнера:

```dockerfile
FROM prom/prometheus:v2.1.0
ADD prometheus.yml /etc/prometheus/
```
#### Конфигурация

Вся конфигурация Prometheus, в отличие от многих других систем мониторинга, происходит через файлы конфигурации и опции командной строки.

Мы определим простой конфигурационный файл для сбора метрик с наших микросервисов. В директории [monitoring/prometheus](monitoring/prometheus) создан файл [prometheus.yml](monitoring/prometheus/prometheus.yml) со следующим содержимым:
```yaml
---
global:
  scrape_interval: '5s'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets:
        - 'localhost:9090'

  - job_name: 'ui'
    static_configs:
      - targets:
        - 'ui:9292'

  - job_name: 'comment'
    static_configs:
      - targets:
        - 'comment:9292'
```

- Файл [monitoring/prometheus/Dockerfile](monitoring/prometheus/Dockerfile) исправлен в соответсвии с указаниями линтера (replace `ADD` with `COPY`)

#### Создаем образ

В директории prometheus собираем Docker образ:
```shell
export USER_NAME=kazhem
cd monitoring/prometheus
docker build -t $USER_NAME/prometheus .
```

В конце занятия нужно будет запушить на DockerHub собранные вами на этом занятии образы.

#### Образы микросервисов

В коде микросервисов есть healthcheck-и для проверки работоспособности приложения.

Сборку образов теперь необходимо производить при помощи скриптов `docker_build.sh`, которые есть в директории каждого сервиса. С его помощью мы добавим информацию из Git в наш healthcheck.

Пример скрипта
```shell
#!/bin/bash

echo `git show --format="%h" HEAD | head -1` > build_info.txt
echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt

docker build -t $USER_NAME/ui .
```

#### Соберем images

Выполните сборку образов при помощи скриптов `docker_build.sh` в директории каждого сервиса.
```shell
cd src/comment && bash ./docker_build.sh && cd -
cd src/post-py && bash ./docker_build.sh && cd -
cd src/ui && bash ./docker_build.sh && cd -
```

Или все сразу из корня репозитория
```shell
for i in ui post-py comment; do cd src/$i; bash docker_build.sh cd -; done
```

#### docker-compose.yml

Все `docker-compose.*` файлы перемещены из [src/](src/) в [docker/](docker/)

Будем поднимать наш Prometheus совместно с микросервисами. Определите в вашем [docker/docker-compose.yml](docker/docker-compose.yml) файле новый сервис.
```yaml
services:
...
  prometheus:
    image: ${USERNAME}/prometheus
    ports:
      - '9090:9090'
    volumes:
      - prometheus_data:/prometheus
    command:  # доп. параметры коммандной строки
      - '--config.file=/etc/prometheus/prometheus.yml'  # путь к конфигурационному файлу внутри контейнера
      - '--storage.tsdb.path=/prometheus'  # путь к директории с данными внутри контейнера
      - '--storage.tsdb.retention=1d'  # хранить данные за последние сутки

volumes:
  prometheus_data:
```

Мы будем использовать Prometheus для мониторинга всех наших микросервисов, поэтому нам необходимо, чтобы контейнер с ним мог общаться по сети со всеми другими сервисами, определенными в компоуз файле.

```yaml
    networks:
      - reddit_front
      - reddit_back
```

Также проверьте актуальность версий сервисов
в `.env` и `.env.example`

#### Запуск микросервисов

Поднимем сервисы, определенные в docker/dockercompose.yml

```shell
cd docker && docker-compose up -d
```

Ошибка
```log
Pulling ui (kazhem/ui:1.0)...
ERROR: manifest for kazhem/ui:1.0 not found: manifest unknown: manifest unknown
```
Причина -- отсутствие образов нужной версии?

Запушен таг kazhem/ui:1.0 (для всех остальных сервисов по аналогии)
  ```shell
   docker tag kazhem/ui:latest kazhem/ui:1.0
   docker push kazhem/ui:1.0
  ```
В [].env](docker/.env) указана версия 1.0 для приложений

Запуск
```shell
docker-compose up -d
Creating docker_post_db_1    ... done
Creating docker_post_1       ... done
Creating docker_ui_1         ... done
Creating docker_prometheus_1 ... done
Creating docker_comment_1    ... done
```

**Ошибка!** Приложение не запустилось

Список запущенных сервисов
```shell
docker-compose ps
```
```log
       Name                      Command               State            Ports
--------------------------------------------------------------------------------------
docker_comment_1      puma                             Exit 1
docker_post_1         python3 post_app.py              Exit 2
docker_post_db_1      docker-entrypoint.sh mongod      Up       27017/tcp
docker_prometheus_1   /bin/prometheus --config.f ...   Up       0.0.0.0:9090->9090/tcp
docker_ui_1           puma --debug -w 2                Exit 1
```

comment
```shell
docker logs docker_comment_1
```
```log
/usr/local/lib/ruby/site_ruby/2.2.0/bundler/definition.rb:33:in `build': /app/Gemfile not found (Bundler::GemfileNotFound)
        from /usr/local/lib/ruby/site_ruby/2.2.0/bundler.rb:135:in `definition'
        from /usr/local/lib/ruby/site_ruby/2.2.0/bundler.rb:101:in `setup'
        from /usr/local/lib/ruby/site_ruby/2.2.0/bundler/setup.rb:20:in `<top (required)>'
        from /usr/local/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:59:in `require'
        from /usr/local/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:59:in `require'
        from /usr/local/bundle/bin/puma:27:in `<main>'
```
post
```shell
docker logs docker_post_1
python3: can't open file 'post_app.py': [Errno 2] No such file or directory
```

Причина [docker/docker-compose.override.yml](docker/docker-compose.override.yml), в котором указано монтирование директорий с кодом с локального хоста.

`docker/docker-compose.override.yml` переименован в [docker/docker-compose.override.yml.example](docker/docker-compose.override.yml.example)

Теперь:
  ```
  docker-compose ps
        Name                      Command               State           Ports
  -------------------------------------------------------------------------------------
  docker_comment_1      puma                             Up
  docker_post_1         python3 post_app.py              Up
  docker_post_db_1      docker-entrypoint.sh mongod      Up      27017/tcp
  docker_prometheus_1   /bin/prometheus --config.f ...   Up      0.0.0.0:9090->9090/tcp
  docker_ui_1           puma                             Up      0.0.0.0:9292->9292/tcp
  ```
Приложение открывается http://34.78.188.236:9292/
Prometheus доступен http://34.78.188.236:9090
В prometheus появились активные endpoint-ы `comment` и `ui` http://34.78.188.236:9090/targets

#### Healthchecks

Healthcheck-и представляют собой проверки того, что наш сервис здоров и работает в ожидаемом режиме. В нашем случае healthcheck выполняется внутри кода микросервиса и выполняет проверку того, что все сервисы, от которых зависит его работа, ему доступны.

Если требуемые для его работы сервисы здоровы, то healthcheck проверка возвращает status = 1, что соответсвует тому, что сам сервис здоров.

Если один из нужных ему сервисов нездоров или недоступен, то проверка вернет status = 0.

#### Состояние сервиса UI

В веб интерфейсе Prometheus выполните поиск по названию метрики `ui_health`.

Действительно, есть такой.
```log
ui_health{branch="monitoring-1",commit_hash="2dec0f4",instance="ui:9292",job="ui",version="0.0.1"}
```

Построим график того, как менялось значение метрики ui_health со временем: вкладка _Graph_

**Обратим внимание**, что, помимо имени метрики и ее значения, мы также видим информацию в лейблах о версии приложения, комите и ветке кода в Git-е.

Видим, что статус UI сервиса был стабильно 1 (но это не так!), что означает, что сервис работал. Данный график оставьте открытым.

**P.S.** Если у вас статус не равен 1, проверьте какой сервис
недоступен (слайд 32), и что у вас заданы все aliases для DB.
Не работалд commnent по причине того, что не было сетевого алиаса на сеть `post_db - comment_db`:
  ```yaml
  services:
  post_db:
    image: mongo:${MONGO_VERSION}
    volumes:
      - post_db:/data/db
    networks:
      back_net:
        aliases:
          - comment_db
  ```

##### Проверка метрик

Остановим post сервис

Мы говорили, что условились считать сервис здоровым, если все сервисы, от которых он зависит также являются здоровыми.

Попробуем остановить сервис post на некоторое время и проверим, как изменится статус ui сервиса, который зависим от post.

```shell
docker-compose stop post
```
```log
Stopping docker_post_1 ... done
```

После обновления графика метрика `ui_health` снова изменила значение на `0`.


##### Поиск проблемы

Помимо статуса сервиса, мы также собираем статусы сервисов, от которых он зависит. Названия метрик, значения которых соответствует данным статусам, имеет формат `ui_health_<service-name>`.

Посмотрим, не случилось ли чего плохого с сервисами, от которых зависит UI сервис.

Наберем в строке выражений ui_health_ и Prometheus нам предложит дополнить названия метрик.

Проверим comment сервис. Видим, что сервис свой статус не менял в данный промежуток времени: `ui_health_comment_availability`

А с post сервисом все плохо: `ui_health_post_availability`

Чиним. Проблему мы обнаружили и знаем, как ее поправить (ведь мы же ее и создали :)). Поднимем post сервис.
```shell
docker-compose start post
```
```log
Starting post ... done
```
Post сервис поправился: `ui_health_post_availability`
UI сервис тоже: `ui_health

### Сбор метрик хоста с использованием экспортера

Экспортер похож на вспомогательного агента для сбора метрик.

В ситуациях, когда мы не можем реализовать отдачу метрик Prometheus в коде приложения, мы можем использовать экспортер, который будет транслировать метрики приложения или системы в формате доступном для чтения Prometheus.

Экспортер это:
- Программа, которая делает метрики доступными для сбора Prometheus
- Дает возможность конвертировать метрики в нужный для Prometheus формат
- Используется когда нельзя поменять код приложения
- Примеры: PostgreSQL, RabbitMQ, Nginx, Node exporter, cAdvisor


#### Node exporter

Воспользуемся [Node экспортер](https://github.com/prometheus/node_exporter) для сбора информации о работе Docker хоста (виртуалки, где у нас запущены контейнеры) и предоставлению этой информации в Prometheus.

#### docker-compose.yml

Node экспортер будем запускать также в контейнере. Определим еще один сервис в [docker/docker-compose.yml](docker/docker-compose.yml) файле.

Не забудьте также добавить определение сетей для сервиса node-exporter, чтобы обеспечить доступ Prometheus к экспортеру.

```yaml
services:
  ...
  node-exporter:
    image: prom/node-exporter:${NODE_EXPORTER_VERSION}
    user: root
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - front_net
      - back_net
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($$|/)"'
```
Чтобы сказать Prometheus следить за еще одним сервисом, нам нужно добавить информацию о нем в конфиг.

Добавим еще один job:
```yaml
scrape_configs:
  ...
  - job_name: 'node'
    static_configs:
      - targets:
        - 'node-exporter:9100'
```
Не забудем собрать новый Docker для Prometheus:
```shell
monitoring/prometheus $ docker build -t $USER_NAME/prometheus .
```

#### Пересоздадим наши сервисы

```shell
docker-compose down
docker-compose up -d
```

Проверяем web-интерфейс http://34.78.188.236:9090/graph открылся **успешно**

Посмотрим, список endpoint-ов Prometheus http://34.78.188.236:9090/targets - должен появится еще один endpoint.

#### Получение информации

Получим информацию об использовании CPU: `node_load1`
```log
node_load1{instance="node-exporter:9100",job="node"}	0
```

Зайдем на хост: `docker-machine ssh docker-host`

Добавим нагрузки: `yes > /dev/null`

На графике http://34.78.188.236:9090/graph?g0.range_input=1h&g0.expr=node_load1&g0.tab=0 видно, что нагрузка возросла.


Ссылка на docker-hub https://hub.docker.com/u/kazhem

### Задания со \*

Добавлен [Makefile](Makefile)  с командами (документация:  [_1](https://www.ibm.com/developerworks/ru/library/l-debugmake/index.html), [_2](https://habrahabr.ru/post/132524/), [_3](http://rus-linux.net/nlib.php?name=/MyLDP/algol/gnu_make/gnu_make_3-79_russian_manual.html)):
  - build_comment
  - build_post
  - build_ui
  - build_prometheus
  - build (all)
  ----
  - push_comment
  - push_post
  - push_ui
  - push_prometheus
  - push (all)

### Задания со \*

#### MongoDB exporter

Добавьте в Prometheus мониторинг MongoDB с использованием необходимого экспортера.

В качестве экспортера был выбран [percona/mongodb_exporter](https://github.com/percona/mongodb_exporter) от percona, так как представлен известным разработчиком, а так же как единственный, представленный на prometheus wiki [Default port allocations](https://github.com/prometheus/prometheus/wiki/Default-port-allocations)

Экспортер [dcu/mongodb_exporter](https://github.com/dcu/mongodb_exporter), представленный на https://prometheus.io/docs/instrumenting/exporters/, по рекомендациям из ДЗ, выбран не был.

##### Установка

Добавлен Makefile target `mongodb_exporter_clone`, который клонирует репозиторий с github.
```makefile
mongodb_exporter_clone:
	cd ./monitoring && git clone https://github.com/percona/mongodb_exporter.git
```
Клонирован репозиторий
```shell
make mongodb_exporter_clone
```
```log
cd ./monitoring \
        && (test -d ./mongodb_exporter || git clone https://github.com/percona/mongodb_exporter.git)
Cloning into 'mongodb_exporter'...
remote: Enumerating objects: 15, done.
remote: Counting objects: 100% (15/15), done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 5882 (delta 6), reused 5 (delta 2), pack-reused 5867
Receiving objects: 100% (5882/5882), 6.40 MiB | 1.56 MiB/s, done.
Resolving deltas: 100% (2950/2950), done.
```
Добавлен Makefile target `mongodb_exporter_docker_build`, который собирает докер-контейнер
```makefile
# mongodb_exporter
MONGODB_EXPORTER_DOCKER_IMAGE_NAME?=${USER_NAME}/mongodb-exporter
MONGODB_EXPORTER_VERSION?=v0.11.0
mongodb_exporter_docker_build:
	cd ./monitoring/mongodb_exporter && make docker DOCKER_IMAGE_NAME=${MONGODB_EXPORTER_DOCKER_IMAGE_NAME} DOCKER_IMAGE_TAG=${MONGODB_EXPORTER_VERSION}
```
Собран docker-образ `vscoder/mongodb-mongodb_exporter:v0.10.0`
```shell
make mongodb_exporter_docker_build
```
```log
...
Successfully built 8da76a8e3cbb
Successfully tagged kazhem/mongodb-exporter:v0.11.0
```

В [docker/.env](docker/.env) добавлена переменная `MONGODB_EXPORTER_VERSION=v0.11.0`

В [docker/docker-compose.yml](docker/docker-compose.yml) добавлен сервис `postdb-exporter`
```yaml
 postdb-exporter:
    image: ${USERNAME}/mongodb-exporter:${MONGODB_EXPORTER_VERSION}
    networks:
      - back_net
    environment:
      MONGODB_URI: "mongodb://post_db:27017"
```

В [monitoring/prometheus/prometheus.yml](monitoring/prometheus/prometheus.yml) добавлен job
```yaml
scrape_config:
  ...
  - job_name: "post_db"
    static_configs:
      - targets:
        - "postdb-exporter:9216"
```

В [.gitignore](.gitignore) добавлена строка
```
monitoring/mongodb_exporter
```

В Makefile target `build` добавлена сборка `mongodb_exporter_docker_build`

В Makefile target `push` добавлена закачка `mongodb_exporter_push`

Сборка всего
```shell
make build
```

Проверка http://34.78.188.236:9090
```log
mongodb_exporter_scrapes_total{instance="postdb-exporter:9216",job="post_db"}	8
```

## HomeWork 17: Мониторинг приложения и инфраструктуры

### План

1. Мониторинг Docker контейнеров
2. Визуализация метрик
3. Сбор метрик работы приложения и бизнес метрик
4. Настройка и проверка алертинга
5. Много заданий со ⭐ (необязательных)

### Мониторинг Docker контейнеров


#### Подготовка окружения

Открывать порты в файрволле для новых сервисов нужно
самостоятельно по мере их добавления.

Создадим Docker хост в GCE и настроим локальное окружение на
работу с ним

Пример из ДЗ:
```shell
$ export GOOGLE_PROJECT=_ваш-проект_

# Создать докер хост
docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    docker-host

# Настроить докер клиент на удаленный докер демон
eval $(docker-machine env docker-host)

# Переключение на локальный докер
eval $(docker-machine env --unset)

$ docker-machine ip docker-host

$ docker-machine rm docker-host
```

#### Мониторинг Docker контейнеров

Разделим файлы Docker Compose:

В данный момент и мониторинг и приложения у нас описаны в одном большом [docker-compose.yml](docker/docker-compose.yml). С одной стороны это просто, а с другой - мы смешиваем различные сущности, и сам файл быстро растет.

Оставим описание приложений в [docker-compose.yml](docker/docker-compose.yml), а мониторинг выделим в отдельный файл [docker-compose-monitoring.yml](docker/docker-compose-monitoring.yml).

Для запуска приложений будем как и ранее использовать `docker-compose up -d`, а для мониторинга - `docker-compose -f docker-compose-monitoring.yml up -d`

#### cAdvisor

Мы будем использовать [cAdvisor](https://github.com/google/cadvisor) для наблюдения за состоянием наших Docker контейнеров.

cAdvisor собирает информацию о ресурсах потребляемых контейнерами и характеристиках их работы.

Примерами метрик являются:
- процент использования контейнером CPU и памяти, выделенные для его запуска,
- объем сетевого трафика
- и др.

#### Файл docker-compose-monitoring.yml

cAdvisor также будем запускать в контейнере. Для этого добавим новый сервис в наш компоуз файл мониторинга [docker/docker-compose-monitoring.yml](docker/docker-compose-monitoring.yml).

Поместите данный сервис в одну сеть с Prometheus, чтобы тот мог собирать с него метрики.

```yaml
cadvisor:
  image: google/cadvisor:v0.33.0
  volumes:
    - '/:/rootfs:ro'
    - '/var/run:/var/run:rw'
    - '/sys:/sys:ro'
    - '/var/lib/docker/:/var/lib/docker:ro'
  ports:
    - '8080:8080'
```

#### Файл prometheus.yml

Добавим информацию о новом сервисе в [конфигурацию Prometheus](monitoring/prometheus/prometheus.yml), чтобы он начал собирать метрики:
```yaml
scrape_configs:
  ...
  - job_name: 'cadvisor'
    static_configs:
      - targets:
        - 'cadvisor:8080'
```

Пересоберем образ Prometheus с обновленной конфигурацией.

Пример из лекции:
```shell
export USER_NAME=username # где username - ваш логин на Docker Hub
docker build -t $USER_NAME/prometheus .
```


#### cAdvisor UI

Запустим сервисы:
```shell
docker-compose up -d
docker-compose -f docker-compose-monitoring.yml up -d
```

Образы успешно скачаны с docker hub. Проект запущен.
```log
...
Creating docker_ui_1      ... done
Creating docker_post_db_1 ... done
Creating docker_post_1    ... done
Creating docker_comment_1 ... done
...
WARNING: Found orphan containers (docker_comment_1, docker_post_1, docker_post_db_1, docker_ui_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.

Creating docker_prometheus_1      ... done
Creating docker_cadvisor_1        ... done
Creating docker_node-exporter_1   ... done
Creating docker_cloudprober_1     ... done
Creating docker_postdb-exporter_1 ... done
```

cAdvisor имеет UI, в котором отображается собираемая о контейнерах информация.
Откроем страницу Web UI по адресу http://<docker-machinehost-ip>:8080
Нажмите ссылку Docker Containers (внизу слева) для просмотра информации по контейнерам.

В UI мы можем увидеть:
- список контейнеров, запущенных на хосте
- информацию о хосте (секция Driver Status)
- информацию об образах контейнеров (секция Images)

Нажмем на название одного из контейнеров, чтобы посмотреть информацию о его работе:

Здесь отображается информация по процессам, использованию CPU, памяти, сети и файловой системы:

По пути /metrics все собираемые метрики публикуются для сбора Prometheus: http://34.78.188.236:8080/metrics

Видим, что имена метрик контейнеров начинаются со слова `container`

Проверим, что метрики контейнеров собираются Prometheus.


### Визуализация метрик: Grafana

Используем инструмент Grafana для визуализации данных из Prometheus.

Добавим новый сервис в [docker-compose-monitoring.yml](docker/docker-compose-monitoring.yml). Так же добавляем grafana в сеть `reddit_front`
```yaml
services:

  grafana:
    image: grafana/grafana:${GRAFANA_VERSION}
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=secret
    depends_on:
      - prometheus
    ports:
      - 3000:3000
    networks:
      - reddit_front

volumes:
  grafana_data:
```
В ДС указано использовать `grafana:5.0.0`, указана для установки `grafana:7.1.3`))


Сервис `cadvisor` так же оставлен только в сети `front_net` так как ему не нужно взаимодействовать ни с чем кроме prometheus.


#### Grafana: Web UI

Запустим новый сервис:
```yaml
docker-compose -f docker-compose-monitoring.yml up -d grafana
```

Добавим правило фаервола
```shell
gcloud compute firewall-rules create grafana \
  --allow tcp:3000 \
  --target-tags=docker-machine \
  --description="Allow grafana UI connections" \
  --direction=INGRESS
```

Откроем страницу Web UI Grafana по адресу http:// <dockermachine-host-ip>:3000 и используем для входа логин и пароль администратора, которые мы передали через переменные окружения:


#### Grafana: Добавление источника данных

Нажмем Add data source (Добавить источник данных):

Выберем нужный тип и зададим параметры подключения:

- Type: Prometheus
- Name: Prometheus Server
- URL: http://prometheus:9090

**Save & Test**


#### Дашборды

Перейдем на [Сайт grafana](https://grafana.com/grafana/dashboards), где можно найти и скачать большое количество уже созданных официальных и комьюнити дашбордов для визуализации различного типа метрик для разных систем мониторинга и баз данных.

Выберем в качестве источника данных нашу систему мониторинга (Prometheus) и выполним поиск по категории Docker. Затем выберем популярный дашборд: **Docker + System dashboard**

Нажмем _Загрузить JSON_. В директории `monitoring` создайте
директории `grafana/dashboards`, куда поместите скачанный
дашборд. Поменяйте название файла дашборда на
[DockerMonitoring.json](monitoring/grafana/dashboards/DockerMonitoring.json).


#### Импорт дашборда

Снова откроем веб-интерфейс Grafana и выберем импорт шаблона (Dashboards -> Manage -> Import)

Загрузите скачанный дашборд. При загрузке укажите источник
данных для визуализации (Prometheus Server):


Ранее выбранный дашборд `Last updated: 2 years ago`

Выбран дашборд https://grafana.com/grafana/dashboards/9633


Сохранен актуальный json в [monitoring/grafana/dashboards/DockerMonitoring.json](monitoring/grafana/dashboards/DockerMonitoring.json)


### Сбор метрик работы приложения

В качестве примера метрик приложения в сервис UI [мы добавили](https://github.com/express42/reddit/commit/e443f6ab4dcf25f343f2a50c01916d750fc2d096):

- счетчик `ui_request_count`, который считает каждый приходящий HTTP-запрос (добавляя через лейблы такую информацию как HTTP метод, путь, код возврата, мы уточняем данную метрику)
- гистограмму `ui_request_latency_seconds`, которая позволяет отслеживать информацию о времени обработки каждого запроса

В качестве примера метрик приложения в сервис Post [мы добавили](https://github.com/express42/reddit/commit/d8a0316c36723abcfde367527bad182a8e5d9cf2):

- Гистограмму `post_read_db_seconds`, которая позволяет отследить информацию о времени требуемом для поиска поста в БД

#### Зачем?

Созданные метрики придадут видимости работы нашего приложения и понимания, в каком состоянии оно сейчас находится.

Например, время обработки HTTP запроса не должно быть большим, поскольку это означает, что пользователю приходится долго ждать между запросами, и это ухудшает его общее впечатление от работы с приложением. Поэтому большое время обработки запроса будет для нас сигналом проблемы.

Отслеживая приходящие HTTP-запросы, мы можем, например, посмотреть, какое количество ответов возвращается с кодом ошибки. Большое количество таких ответов также будет служить для нас сигналом проблемы в работе приложения.


#### prometheus.yml

Добавим информацию о post-сервисе в конфигурацию Prometheus, чтобы он начал собирать метрики и с него:

```yaml
scrape_configs:
  ...
  - job_name: "post"
    static_configs:
      - targets:
          - "post:5000"
```

Пересоберем (и загрузим на docker-hub) образ Prometheus с обновленной конфигурацией:

```shell
make push_prometheus
```

Пересоздадим нашу Docker инфраструктуру мониторинга
```yaml
docker-compose -f docker-compose-monitoring.yml up -d
```

И добавим несколько постов в приложении и несколько комментов, чтобы собрать значения метрик приложения: сделано.

#### Создание дашборда в Grafana

Построим графики собираемых метрик приложения. Выберем создать новый дашборд: Снова откроем вебинтерфейс Grafana и выберем создание шаблона (Dashboard).

1. Выбираем "Построить график" (New Panel ➡ Graph)
2. Жмем один раз на имя графика (Panel Title), затем выбираем Edit:

Построим для начала простой график изменения счетчика HTTP-запросов по времени. Выберем источник данных и в поле запроса введем название метрики:

Далее достаточно нажать мышкой на любое место UI, чтобы убрать курсор из поля запроса, и Grafana выполнит запрос и построит график.

В правом верхнем углу мы можем уменьшить временной интервал, на котором строим график, и настроить автообновление данных.

Сейчас мы с вами получили график различных HTTP запросов, поступающих UI сервису.

Изменим заголовок графика и описание.

Сохраним созданный дашборд.

Построим график запросов, которые возвращают код ошибки на этом же дашборде. Добавим еще один график на наш дашборд.

Переходим в режим правки графика.

В поле запросов запишем выражение для поиска всех http запросов, у которых код возврата начинается либо с 4 либо с 5 (используем регулярное выражения для поиска по лейблу). Будем использовать функцию rate(), чтобы посмотреть не просто значение счетчика за весь период наблюдения, но и скорость увеличения данной величины за промежуток времени (возьмем, к примеру 1- минутный интервал, чтобы график был хорошо видим).

График ничего не покажет, если не было запросов с ошибочным кодом возврата. Для проверки правильности нашего запроса обратимся по несуществующему HTTP пути, например, http://<your_ip>:9292/nonexistent, чтобы получить код ошибки 404 в ответ на наш запрос.

Проверим график (временной промежуток можно уменьшить для лучшей видимости графика).

Добавьте заголовок и описание графика и нажмите сохранить изменения дашборда.

Grafana поддерживает версионирование дашбордов, именно поэтому при сохранении нам предлагалось ввести сообщение, поясняющее изменения дашборда. Вы можете посмотреть историю изменений своего.

#### Самостоятельно

Как вы можете заметить, первый график, который мы сделали просто по `ui_request_count` не отображает никакой полезной информации, т.к. тип метрики `count`, и она просто растет. Задание: Используйте для первого графика (UI http requests) функцию rate аналогично второму графику (Rate of UI HTTP Requests with Error).

https://prometheus.io/docs/prometheus/latest/querying/functions/#rate

Запрос:
```promql
rate(ui_request_count{job="ui"}[1m])
```


#### Гистограмма

Гистограмма представляет собой графический способ представления распределения вероятностей некоторой случайной величины на заданном промежутке значений. Для построения гистограммы берется интервал значений, который может принимать измеряемая величина и разбивается на промежутки (обычно одинаковой величины), данные промежутки помечаются на горизонтальной оси X. Затем над каждым интервалом рисуется прямоугольник, высота которого соответствует числу измерений величины, попадающих в данный интервал.

Простым примером гистограммы может быть распределение оценок за контрольную в классе, где учится 21 ученик. Берем промежуток возможных значений (от 1 до 5) и разбиваем на равные интервалы. Затем на каждом интервале рисуем столбец, высота которого соответсвует частоте появлению данной оценки.


#### Histogram метрика

В Prometheus есть тип метрик histogram. Данный тип метрик в качестве своего значение отдает ряд распределения измеряемой величины в заданном интервале значений. Мы используем данный тип метрики для измерения времени обработки HTTP запроса нашим приложением.

Рассмотрим пример гистограммы в Prometheus. Посмотрим информацию по времени обработки запроса приходящих на главную страницу приложения.

```promql
ui_request_response_time_bucket{path="/"}
```

Эти значения означают, что запросов с временем обработки `<= 0.025s` было 3 штуки, а запросов `0.01 <= 0.01s` было 7 штук (в этот столбец входят 3 запроса из предыдущего столбца и 4 запроса из промежутка `[0.025s; 0.01s]`, такую гистограмму еще называют кумулятивной). Запросов, которые бы заняли `> 0.01s` на обработку не было, поэтому величина всех последующих столбцов равна 7.


#### Процентиль

- Числовое значение в наборе значений
- Все числа в наборе меньше процентиля, попадают в границы заданного процента значений от всего числа значений в наборе

##### Пример процентиль

В классе 20 учеников. Ваня занимает 4-е место по росту в классе. Тогда рост Вани (180 см) является 80-м процентилем. Это означает, что 80 % учеников имеют рост менее 180 см.

##### 95-й процентиль

Часто для анализа данных мониторинга применяются значения 90, 95 или 99-й процентиля.

Мы вычислим 95-й процентиль для выборки времени обработки запросов, чтобы посмотреть какое значение является максимальной границей для большинства (95%) запросов. Для этого воспользуемся встроенной функцией `histogram_quantile()`

Добавьте третий по счету график на ваш дашборд. В поле запроса введите следующее выражение для вычисления 95 процентиля времени ответа на запрос (gist)
```promql
histogram_quantile(0.95, sum(rate(ui_request_response_time_bucket[5m])) by (le))
```

Сохраним изменения дашборда и эспортируем его в JSON файл, который загрузим на нашу локальную машину.

Положите загруженный файл в созданную ранее директорию `monitoring/grafana/dashboards` под названием [UI_Service_Monitoring.json](monitoring/grafana/dashboards/UI_Service_Monitoring.json)

### Сбор метрик бизнеслогики

В качестве примера метрик бизнес логики мы в наше приложение мы добавили счетчики **количества постов** и **комментариев**.
- `post_count`
- `comment_count`

Мы построим график скорости роста значения счетчика за последний час, используя функцию `rate()`. Это позволит нам получать информацию об активности пользователей приложения.

Создайте новый дашборд, назовите его `Business_Logic_Monitoring` и постройте график функции `rate(post_count[1h])`.

Постройте еще один график для счетчика comment, экспортируйте дашборд и сохраните в директории `monitoring/grafana/dashboards` под названием [Business_Logic_Monitoring.json](monitoring/grafana/dashboards/Business_Logic_Monitoring.json).


### Настройка и проверка алертинга


#### Правила алертинга

Мы определим несколько правил, в которых зададим условия состояний наблюдаемых систем, при которых мы должны получать оповещения, т.к. заданные условия могут привести к недоступности или неправильной работе нашего приложения.

P.S. Стоит заметить, что в самой Grafana тоже есть alerting. Но по функционалу он уступает Alertmanager в Prometheus.

#### Alertmanager

Alertmanager - дополнительный компонент для системы мониторинга Prometheus, который отвечает за первичную обработку алертов и дальнейшую отправку оповещений по заданному назначению.

Создайте новую директорию `monitoring/alertmanager`. В этой директории создайте [Dockerfile](monitoring/alertmanager/Dockerfile) со следующим содержимым:
```dockerfile
FROM prom/alertmanager:v0.14.0
COPY config.yml /etc/alertmanager/
```

Настройки Alertmanager-а как и Prometheus задаются через YAML файл или опции командой строки. В директории `monitoring/alertmanager` создайте файл [config.yml](monitoring/alertmanager/config.yml), в котором определите отправку нотификаций в ВАШ тестовый слак канал.

Для отправки нотификаций в слак канал потребуется создать СВОЙ [Incoming Webhook](https://api.slack.com/messaging/webhooks) [monitoring/alertmanager/config.yml](monitoring/alertmanager/config.yml). Было создано slack-приложение `vscoders alertmanager`.
```yaml
---
global:
  slack_api_url: "https://hooks.slack.com/services/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""

route:
  receiver: "slack-notifications"

receivers:
  - name: "slack-notifications"
    slack_configs:
      - channel: "#mikhail_kazhemskiy"
```

Соберем образ alertmanager: для этого

Создан файл [monitoring/alertmanager/docker_build.sh](monitoring/alertmanager/docker_build.sh)

Добавлены Makefiel targets:
```makefile
###
# alertmanager
###
alertmanager_build:
	. ./env && \
	cd ./monitoring/alertmanager && bash docker_build.sh

alertmanager_push:
	. ./env && \
	docker push $${USER_NAME}/alertmanager
```

Выполнен `make alertamanager_build` и `make alertmanager_push`
Образ запушен на докерхаб


Добавим новый сервис в [компоуз файл мониторинга](docker/docker-compose-monitoring.yml). Не забудьте добавить его в одну сеть с сервисом Prometheus:
```yaml
services:
  ...
  alertmanager:
    image: ${USERNAME}/alertmanager
    command:
      - "--config.file=/etc/alertmanager/config.yml"
    ports:
      - 9093:9093
    networks:
      - reddit_back
```

#### Alert rules

Создадим файл [alerts.yml](monitoring/prometheus/alerts.yml) в директории `prometheus`, в котором определим условия при которых должен срабатывать алерт и посылаться Alertmanager-у. Мы создадим простой алерт, который будет срабатывать в ситуации, когда одна из наблюдаемых систем (endpoint) недоступна для сбора метрик (в этом случае метрика `up` с лейблом `instance` равным имени данного эндпоинта будет равна нулю). Выполните запрос по имени метрики `up` в веб интерфейсе Prometheus, чтобы убедиться, что сейчас все эндпоинты доступны для сбора метрик:
```promql
up
```
```log
up{instance="cadvisor:8080",job="cadvisor"}	1
up{instance="cloudprober:9313",job="cloudprober"}	1
up{instance="comment:9292",job="comment"}	1
up{instance="localhost:9090",job="prometheus"}	1
up{instance="node-exporter:9100",job="node"}	1
up{instance="post:5000",job="post"}	1
up{instance="postdb-exporter:9216",job="post_db"}	1
up{instance="ui:9292",job="ui"}	1
```

[alerts.yml](monitoring/prometheus/alerts.yml)
```yaml
---
groups:
  - name: alert.rules
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels:
          severity: page
        annotations:
          description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 1 minute"
          summary: "Instance {{ $labels.instance }} down"
```

Добавим операцию копирования данного файла в Dockerfile: [monitoring/prometheus/Dockerfile](monitoring/prometheus/Dockerfile)
```dockerfile
FROM prom/prometheus:v2.14.0
COPY prometheus.yml /etc/prometheus/
# добавлено
COPY alerts.yml /etc/prometheus/
```


#### prometheus.yml

Добавим информацию о правилах в [конфиг prometheus](monitoring/prometheus/prometheus.yml)
```yaml
global:
  scrape_interval: '5s'
...
rule_files:
  - "alerts.yml"

alerting:
  alertmanagers:
    - scheme: http
      static_configs:
        - targets:
            - "alertmanager:9093"
```

Пересоберем образ Prometheus:

Метод ДЗ
```shell
docker build -t $USER_NAME/prometheus .
```

Метод Make
```shell
make build_prometheus push_prometheus
```
#### Проверка алерта

Остановим один из сервисов и подождем одну минуту.

**Уведомление пришло в slack!!!**

У Alertmanager также есть свой веб интерфейс, доступный на порту 9093, который мы прописали в компоуз файле.

P.S. Проверить работу вебхуков слака можно обычным curl.



Ссылка на докер-хаб https://hub.docker.com/u/kazhem


### Задания со \*


#### Makefile

Если в прошлом ДЗ вы реализовали Makefile, добавьте в него билд и публикацию добавленных в этом ДЗ сервисов;

**Сделано в процессе**


#### Сбор метрик с docker

В Docker в экспериментальном режиме реализована отдача метрик в формате Prometheus. Добавьте сбор этих метрик в Prometheus. Сравните количество метрик с Cadvisor. Выберите готовый дашборд или создайте свой для этого источника данных. Выгрузите его в monitoring/grafana/dashboards;

https://docs.docker.com/config/thirdparty/prometheus/

TODO: сделать


#### Telegraf

Для сбора метрик с Docker демона также можно использовать Telegraf от InfluxDB. Добавьте сбор этих метрик в Prometheus. Сравните количество метрик с Cadvisor. Выберите готовый дашборд или создайте свой для этого источника данных. Выгрузите его в monitoring/grafana/dashboards;

TODO: сделать


#### Alertmanager email

Придумайте и реализуйте другие алерты, например на 95 процентиль времени ответа UI, который рассмотрен выше; Настройте интеграцию Alertmanager с e-mail помимо слака;

TODO: сделать


### Задания с \*\*

#### Автоматическое развёртывание Grafana

В Grafana 5.0 была добавлена возможность описать в конфигурационных файлах источники данных и дашборды. Реализуйте автоматическое добавление источника данных и созданных в данном ДЗ дашбордов в графану;

TODO: сделать


#### Stackdriver

Реализуйте сбор метрик со Stackdriver, в PR опишите, какие метрики удалось собрать;

TODO: сделать


#### Свои метрики

Придумайте свои метрики приложения/бизнес метрики и реализуйте их в коде приложения. Опишите в PR что было добавлено;

TODO: сделать


### Задания со \*\*\*

#### Tickster

Реализуйте схему с проксированием запросов от Grafana к Prometheus через Trickster, кеширующий прокси от Comcast;

TODO: сделать


#### Автоматическое исправление проблем

Используя связку Autoheal + AWX, реализуйте автоматическое исправление проблем (например рестарт одного из микросервисов при падении);

> - Autoheal - проект команды OpenShift для автоматического иcправления проблем по результатам алертов;
> - AWX - open source версия Ansible Tower, установить его можно либо вручную, либо используя одну из готовых ролей, [например](https://github.com/geerlingguy/ansible-role-awx);

Дополнительные папки создавайте в директории monitoring.

TODO: сделать


## HomeWork 18: Логирование и распределенная трассировка

### План

- Сбор неструктурированных логов
- Визуализация логов
- Сбор структурированных логов
- Распределенная трасировка


### Подготовка

Код микросервисов обновился для добавления функционала логирования. Новая версия кода доступа по [ссылка](https://github.com/express42/reddit/tree/logging).

- Обновите код в директории **/src** вашего репозитория из кода по ссылке выше. (старый `./src` переименовал в `./src.microservices`)
  ```shell
  # Rename old ./src
  mv ./src ./src.microservices
  mv ./reddit-loggin ./src
  # Copy Dockerfile and Makefile
  cp ./src.microservices/comment/Dockerfile ./src/comment/
  cp ./src.microservices/post-py/Dockerfile ./src/post-py/
  cp ./src.microservices/ui/Dockerfile ./src/ui/
  cp ./src.microservices/Makefile ./src/
  # Move old ./src outside the project
  mv ./src.microservices ../
  ```
- Если вы используется python-alpine, добавьте в **/src/post-py/Dockerfile** установку пакетов `gcc` и `musl-dev` (заменил установку `build-base` на `gcc` и `musl-dev`)
  ```dockerfile
  ...
  RUN apk add --no-cache --virtual .build-deps gcc musl-dev \
    && pip install --no-cache-dir -r $APP_HOME/requirements.txt \
    && apk del .build-deps
  ...
  ```
- Выполните сборку образов при помощи скриптов docker_build.sh в директории каждого сервиса
  Метод ДЗ
  ```shell
  for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done
  ```
  Метод make
  ```
  make build_ui build_post build_comment
  make push_ui push_post push_comment
  ```

Внимание! В данном ДЗ мы используем отдельные теги для контейнеров приложений :logging


#### Подготовка окружения

```shell
export GOOGLE_PROJECT=_ваш-проект_

docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-open-port 5601/tcp \
    --google-open-port 9292/tcp \
    --google-open-port 9411/tcp \
    logging

# configure local env
eval $(docker-machine env logging)

# узнаем IP адрес
docker-machine ip logging
```

### Логирование Docker контейнеров

#### Elastic Stack

Как упоминалось на лекции хранить все логи стоит централизованно: на одном (нескольких) серверах. В этом ДЗ мы рассмотрим пример системы централизованного логирования на примере Elastic стека (ранее известного как ELK): который включает в себя 3 осовных компонента:
- ElasticSearch (TSDB и поисковый движок для хранения данных)
- Logstash (для агрегации и трансформации данных)
- Kibana (для визуализации)

Однако для агрегации логов вместо Logstash мы будем использовать Fluentd, таким образом получая еще одно популярное сочетание этих инструментов, получившее название EFK.

#### docker-compose-logging.yml

Создадим отдельный compose-файл для нашей системы логирования в папке `docker/`

[docker/docker-compose-logging.yml](docker/docker-compose-logging.yml)
```yaml
---
version: "3"
services:
  fluentd:
    image: ${USERNAME}/fluentd
    ports:
      - "24224:24224"
      - "24224:24224/udp"

  elasticsearch:
    image: elasticsearch:7.4.0
    expose:
      - 9200
    ports:
      - "9200:9200"

  kibana:
    image: kibana:7.4.0
    ports:
      - "5601:5601"
```


### Структурированные логи

Логи должны иметь заданную (единую) структуру и содержать необходимую для нормальной эксплуатации данного сервиса информацию о его работе.

Лог-сообщения также должны иметь понятный для выбранной системы логирования формат, чтобы избежать ненужной траты ресурсов на преобразование данных в нужный вид. Структурированные логи мы рассмотрим на примере сервиса post.

Правим [.env](docker/.env) файл и меняем теги нашего приложения на logging
```shell
...
UI_VERSION=logging
UI_APP_HOME=/app
UI_PORT=9292
POST_VERSION=logging
POST_APP_HOME=/app
COMMENT_VERSION=logging
COMMENT_APP_HOME=/app
...
```

Запустите сервисы приложения
```shell
make build
cd docker/ && docker-compose up -d
```

И выполните команду для просмотра логов post сервиса:
```shell
docker-compose logs -f post
```


Запустите сервисы приложения
```shell
make build
cd docker/ && docker-compose up -d
```

И выполните команду для просмотра логов post сервиса:
```shell
docker-compose logs -f post
```
```log
Attaching to docker_post_1
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": null, "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:50:50"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": null, "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:50:55"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": null, "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:51:00"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": null, "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:51:05"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": null, "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:51:10"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": null, "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:51:15"}
```

Внимание! Среди логов можно наблюдать проблемы с доступностью Zipkin, у нас он пока что и правда не установлен. Ошибки можно игнорировать. [Github issue](https://github.com/express42/reddit/issues/2)

Откройте приложение в браузере и создайте несколько постов, пронаблюдайте, как пишутся логи post серсиса в терминале.
```log
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": null, "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:20"}
post_1     | {"event": "find_all_posts", "level": "info", "message": "Successfully retrieved all posts from the database", "params": {}, "request_id": "0f6cf007-a51a-4d42-b8eb-5c6f51fdc605", "service": "post", "timestamp": "2019-12-17 04:53:22"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/posts?", "request_id": "0f6cf007-a51a-4d42-b8eb-5c6f51fdc605", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:22"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": "0f6cf007-a51a-4d42-b8eb-5c6f51fdc605", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:25"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": "0f6cf007-a51a-4d42-b8eb-5c6f51fdc605", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:30"}
post_1     | {"event": "find_all_posts", "level": "info", "message": "Successfully retrieved all posts from the database", "params": {}, "request_id": "f1d68a4f-c685-4585-abb0-570276e21812", "service": "post", "timestamp": "2019-12-17 04:53:30"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/posts?", "request_id": "f1d68a4f-c685-4585-abb0-570276e21812", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:30"}
post_1     | {"event": "find_all_posts", "level": "info", "message": "Successfully retrieved all posts from the database", "params": {}, "request_id": "0da9978b-80cb-4b32-b56f-096fb8ed72b8", "service": "post", "timestamp": "2019-12-17 04:53:31"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/posts?", "request_id": "0da9978b-80cb-4b32-b56f-096fb8ed72b8", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:31"}
post_1     | {"event": "find_all_posts", "level": "info", "message": "Successfully retrieved all posts from the database", "params": {}, "request_id": "a7d06d49-1e67-40e4-b8b2-d83c21930257", "service": "post", "timestamp": "2019-12-17 04:53:32"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/posts?", "request_id": "a7d06d49-1e67-40e4-b8b2-d83c21930257", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:32"}
post_1     | {"event": "find_all_posts", "level": "info", "message": "Successfully retrieved all posts from the database", "params": {}, "request_id": "bed17527-4202-4054-a124-87e800362971", "service": "post", "timestamp": "2019-12-17 04:53:32"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/posts?", "request_id": "bed17527-4202-4054-a124-87e800362971", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:32"}
post_1     | {"addr": "172.19.0.2", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": "bed17527-4202-4054-a124-87e800362971", "response_status": 200, "service": "post", "timestamp": "2019-12-17 04:53:35"}
```

Каждое событие, связанное с работой нашего приложения логируется в JSON формате и имеет нужную нам структуру: тип события (event), сообщение (message), переданные функции параметры (params), имя сервиса (service) и др.


#### Отправка логов во Fluentd

Как отмечалось на лекции, по умолчанию Docker контейнерами используется json-file драйвер для логирования информации, которая пишется сервисом внутри контейнера в stdout (и stderr). Для отправки логов во Fluentd используем docker драйвер [fluentd](https://docs.docker.com/engine/admin/logging/fluentd/).

Определим драйвер для логирования для сервиса post внутри compose-файла:

[docker/docker-compose.yml](docker/docker-compose.yml)
```yaml
version: '3'
services:
  post:
    image: ${USER_NAME}/post
    environment:
      - POST_DATABASE_HOST=post_db
      - POST_DATABASE=posts
    depends_on:
      - post_db
    ports:
      - "5000:5000"
    logging:
      driver: "fluentd"
      options:
        fluentd-address: localhost:24224
        tag: service.post
```
#### Сбор логов Post сервиса

Поднимем инфраструктуру централизованной системы логирования и перезапустим сервисы приложения. Из каталога docker:

Метод ДЗ
```shell
docker-compose -f docker-compose-logging.yml up -d
docker-compose down
docker-compose up -d
```

Но мы создадим (и изменим) Makefile targets
```makefile
###
# app down
###
down_app:
	cd docker \
	&& `../.venv/bin/`docker-compose down

down_monitoring:
	cd docker \
	&& ../.venv/bin/docker-compose -f docker-compose-monitoring.yml down

down_logging:
	cd docker \
	&& ../.venv/bin/docker-compose -f docker-compose-logging.yml down


###
# run
###
run_app: variables
	cd docker \
	&& ../.venv/bin/docker-compose up -d

run_monitoring: variables
	cd docker \
	&& ../.venv/bin/docker-compose -f docker-compose-monitoring.yml up -d

run_logging: variables
	cd docker \
	&& ../.venv/bin/docker-compose -f docker-compose-logging.yml up -d
```

А теперь метод Make
```shell
make run_logging down_app run_app
```

Создадим несколько постов в приложении:


#### Kibana

Kibana - инструмент для визуализации и анализа логов от компании Elastic.

Откроем WEB-интерфейс Kibana для просмотра собранных в ElasticSearch логов Post-сервиса (kibana слушает на порту 5601)


#### Kibana

Kibana - инструмент для визуализации и анализа логов от компании Elastic.

Откроем WEB-интерфейс Kibana для просмотра собранных в ElasticSearch логов Post-сервиса (kibana слушает на порту 5601)

Ошибка:
> Kibana server is not ready yet

Смотрим список запущенных контейнеров
```shell
cd ./docker && docker-compose -f docker-compose-logging.yml ps
```
```log
         Name                       Command                State                               Ports
--------------------------------------------------------------------------------------------------------------------------------
docker_elasticsearch_1   /usr/local/bin/docker-entr ...   Exit 78
docker_fluentd_1         tini -- /bin/entrypoint.sh ...   Up        0.0.0.0:24224->24224/tcp, 0.0.0.0:24224->24224/udp, 5140/tcp
docker_kibana_1          /usr/local/bin/dumb-init - ...   Up        0.0.0.0:5601->5601/tcp
```

Смотрим логи ES
```shell
docker-compose -f docker-compose-logging.yml logs elasticsearch
```
```log
...
elasticsearch_1  | ERROR: [2] bootstrap checks failed
elasticsearch_1  | [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
elasticsearch_1  | [2]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
...
```

Поиск в слаке дал решение. Чиним:

Задаём vm.max_map_count на docker-machine инстансе
```shell
docker-machine ssh logging sudo sysctl -w vm.max_map_count=262144
exit
```

Обновим версию и добавим envionment

[docker-compose-logging.yml](docker/docker-compose-logging.yml)
```yaml
services:
  ...
  elasticsearch:
    image: elasticsearch:7.5.0
    expose:
      - 9200
    ports:
      - "9200:9200"
    environment:
      - node.name=elasticsearch
      - cluster.name=docker-cluster
      - node.master=true
      - cluster.initial_master_nodes=elasticsearch
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
  ...
```

Перезапускаем logging
```shell
make down_logging run_logging
```

Проверяем
```shell
cd ./docker && docker-compose -f docker-compose-logging.yml ps
```
Ошибка
```log
         Name                       Command                State                               Ports
--------------------------------------------------------------------------------------------------------------------------------
docker_elasticsearch_1   /usr/local/bin/docker-entr ...   Exit 78
docker_fluentd_1         tini -- /bin/entrypoint.sh ...   Up        0.0.0.0:24224->24224/tcp, 0.0.0.0:24224->24224/udp, 5140/tcp
docker_kibana_1          /usr/local/bin/dumb-init - ...   Up        0.0.0.0:5601->5601/tcp
```
```shell
docker-compose -f docker-compose-logging.yml logs elasticsearch
```
```log
...
elasticsearch_1  | ERROR: [1] bootstrap checks failed
elasticsearch_1  | [1]: memory locking requested for elasticsearch process but memory is not locked
...
```
Отчасти помогла найти проблему дискуссия по [ссылке](https://discuss.elastic.co/t/elasticsearch-is-not-starting-when-bootstrap-memory-lock-is-set-to-true/120962/2)


##### memory locking requested for elasticsearch process but memory is not locked

Правим `/etc/security/limits.conf` на инстансе docker-machine
```shell
docker-machine ssh logging
echo elasticsearch soft memlock unlimited | sudo tee /etc/security/limits.conf
echo elasticsearch hard memlock unlimited | sudo tee /etc/security/limits.conf
exit
```

Переподнимаем logging
```shell
make down_logging run_logging
```

Результат тот же.

После некоторых блужданий, решение найдено https://github.com/deviantony/docker-elk/issues/243

К сервису добавлены лимиты
```yaml
ulimits:
  memlock:
    soft: -1
    hard: -1
```

Итоговый [docker/docker-compose-logging.yml](docker/docker-compose-logging.yml)
```yaml
---
version: "3"
services:
  fluentd:
    image: ${USERNAME}/fluentd
    ports:
      - "24224:24224"
      - "24224:24224/udp"

  elasticsearch:
    image: elasticsearch:7.5.0
    expose:
      - 9200
    ports:
      - "9200:9200"
    environment:
      - node.name=elasticsearch
      - cluster.name=docker-cluster
      - node.master=true
      - cluster.initial_master_nodes=elasticsearch
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
    ulimits:
      memlock:
        soft: -1
        hard: -1

  kibana:
    image: kibana:7.5.0
    ports:
      - "5601:5601"
```


##### Kibana продолжение

Откроем WEB-интерфейс Kibana для просмотра собранных в ElasticSearch логов Post-сервиса (kibana слушает на порту 5601) http://34.66.31.172:5601

1. Discover
2. Configure an index pattern `fluentd-*`
3. Next
4. Time Filter field name `@timestamp`
5. Next
6. Discover

Далее можн поиграться с интефейсом, посмотреть логи.

Видим лог-сообщение, которые мы недавно наблюдали в терминале. Теперь эти лог-сообщения хранятся централизованно в ElasticSearch. Также видим доп. информацию о том, откуда поступил данный лог.

Обратим внимание на то, что наименования в левом столбце, называются полями. По полям можно производить поиск для быстрого нахождения нужной информации.

Для того чтобы посмотреть некоторые примеры поиска, можно ввести в поле поиска произвольное выражение.

К примеру, посмотрев список доступных полей, мы можем выполнить поиск всех логов, поступивших с контейнера `reddit_post_1`.

Заметим, что поле log содержит в себе JSON объект, который содержит много интересной нам информации.
```json
{"addr": "172.22.0.3", "event": "request", "level": "info", "method": "GET", "path": "/healthcheck?", "request_id": "6a63335d-3419-499f-a380-d834fd491e67", "response_status": 200, "service": "post", "timestamp": "2020-08-26 10:22:00"}
```

Нам хотелось бы выделить эту информацию в поля, чтобы иметь возможность производить по ним поиск. Например, для того чтобы найти все логи, связанные с определенным событием (event) или конкретным сервисов (service).

Мы можем достичь этого за счет использования **фильтров** для выделения нужной информации.

#### Фильтры

Добавим фильтр для парсинга json логов, приходящих от post сервиса, в конфиг fluentd.

[logging/fluentd/fluent.conf](logging/fluentd/fluent.conf)
```xml
<source>
   @type forward
   port 24224
   bind 0.0.0.0
</source>

<filter service.post>
   @type parser
   format json
   key_name log
</filter>

<match *.**>
   @type copy
...
```

После этого персоберите образ и перезапустите сервис fluentd

Метод ДЗ
```shell
logging/fluentd $ docker build -t $USER_NAME/fluentd
docker/ $ docker-compose -f docker-compose-logging.yml up -d fluentd
```

Но у нас букв меньше. Метод Make
```shell
make fluentd_build run_logging
```

Вновь обратимся к Kibana. Прежде чем смотреть логи убедимся, что временной интервал выбран верно. Нажмите один раз на дату со временем. Выставлены верно!

Снова взглянем на одно из сообщений и увидим, что вместо одного поля log появилось множество полей с нужной нам информацией!

Выполним для пример поиск по событию создания нового поста: `event: post_create`

Нашлось 2 поста, которые были созданы после настройки фильтра.



### Неструктурированные логи

Неструктурированные логи отличаются отсутствием четкой структуры данных. Также часто бывает, что формат лог-сообщений не подстроен под систему централизованного логирования, что существенно увеличивает затраты вычислительных и временных ресурсов на обработку данных и выделение нужной информации.

На примере сервиса ui мы рассмотрим пример логов с неудобным форматом сообщений.


#### Логирование UI сервиса

По аналогии с post сервисом определим для ui сервиса драйвер для логирования fluentd в compose-файле.

[docker/docker-compose.yml](docker/docker-compose.yml)
```yaml
services:
  ui:
    environment:
      APP_HOME: ${UI_APP_HOME}
    image: ${USERNAME}/ui:${UI_VERSION}
    ports:
      - ${UI_PORT}:9292/tcp
    networks:
      - reddit_front
    logging:
      driver: "fluentd"
      options:
        fluentd-address: localhost:24224
        tag: service.ui
```

Перезапустим ui сервис Из каталога `./docker`

Путь ДЗ
```
docker-compose stop ui
docker-compose rm ui
docker-compose up -d
```


Посмотрим на формат собираемых сообщений
```log
I, [2020-08-27T10:10:14.052808 #1]  INFO -- : service=ui | event=show_all_posts | request_id=92d283af-61b6-4fb2-8a49-2630f57d5f9c | message='Successfully showed the home page with posts' | params: "{}"
```

### Парсинг

Когда приложение или сервис не пишет структурированные логи, приходится использовать старые добрые **регулярные выражения** для их парсинга в [/docker/fluentd/fluent.conf](/docker/fluentd/fluent.conf)

Следующее **регулярное выражение** нужно, чтобы успешно выделить интересующую нас информацию из лога UI-сервиса в поля

[/docker/fluentd/fluent.conf](/docker/fluentd/fluent.conf)
```xml
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<filter service.post>
  @type parser
  format json
  key_name log
</filter>

<filter service.ui>
  @type parser
  format /\[(?<time>[^\]]*)\]  (?<level>\S+) (?<user>\S+)[\W]*service=(?<service>\S+)[\W]*event=(?<event>\S+)[\W]*(?:path=(?<path>\S+)[\W]*)?request_id=(?<request_id>\S+)[\W]*(?:remote_addr=(?<remote_addr>\S+)[\W]*)?(?:method= (?<method>\S+)[\W]*)?(?:response_status=(?<response_status>\S+)[\W]*)?(?:message='(?<message>[^\']*)[\W]*)?/
  key_name log
</filter>


<match *.**>
  @type copy
  <store>
    @type elasticsearch
    host elasticsearch
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
  </store>
  <store>
    @type stdout
  </store>
</match>
```

#### Перезапускаем логгинг

Обновим fluentd и перезапустим логгинг
```shell
make fluentd_build run_logging
```

Теперь гораздо лучше: сообщение в эластике
```json
{
  "_index": "fluentd-20200827",
  "_type": "access_log",
  "_id": "qjx8L3QBELbPWWup_LDJ",
  "_version": 1,
  "_score": null,
  "_source": {
    "level": "INFO",
    "user": "--",
    "service": "ui",
    "event": "show_all_posts",
    "request_id": "cc9b5fca-fd3f-4d24-9408-2dfcf0b8fd7f",
    "message": "Successfully showed the home page with posts",
    "@timestamp": "2020-08-27T10:35:52+00:00",
    "@log_name": "service.ui"
  },
  "fields": {
    "@timestamp": [
      "2020-08-27T10:35:52.000Z"
    ]
  },
  "highlight": {
    "@log_name": [
      "@kibana-highlighted-field@service.ui@/kibana-highlighted-field@"
    ]
  },
  "sort": [
    1598524552000
  ]
}
```

Созданные регулярки могут иметь ошибки, их сложно менять и невозможно читать. Для облегчения задачи парсинга вместо стандартных регулярок можно использовать **grok**-шаблоны. По-сути **grok**’и - это именованные шаблоны регулярных выражений (очень похоже на функции). Можно использовать готовый regexp, просто сославшись на него как на функцию

[docker/fluentd/fluent.conf](docker/fluentd/fluent.conf)
```xml
...
<filter service.ui>
   @type parser
   format grok
   grok_pattern %{RUBY_LOGGER}
   key_name log
</filter>
...
```

Это grok-шаблон, зашитый в плагин для fluentd. В развернутом виде он выглядит вот так:
```grok
%{RUBY_LOGGER} [(?<timestamp>(?>\d\d){1,2}-(?:0?[1-9]|1[0-2])-(?:(?:0[1-9])|(?:[12][0-9])|(?:3[01])|[1-9])[T ](?:2[0123]|[01]?[0-9]):?(?:[0-5][0-9])(?::?(?:(?:[0-5]?[0-9]|60)(?:[:.,][0-9]+)?))?(?:Z|[+-](?:2[0123]|[01]?[0-9])(?::?(?:[0-5][0-9])))?) #(?<pid>\b(?:[1-9][0-9]*)\b)\] *(?<loglevel>(?:DEBUG|FATAL|ERROR|WARN|INFO)) -- +(?<progname>.*?): (?<message>.*)
```

Как было видно на предыдущем слайде - часть логов нужно еще распарсить. Для этого используем несколько Grok-ов по-очереди

[docker/fluentd/fluent.conf](docker/fluentd/fluent.conf)
```xml
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<filter service.post>
  @type parser
  format json
  key_name log
</filter>

<filter service.ui>
  @type parser
  key_name log
  format grok
  grok_pattern %{RUBY_LOGGER}
</filter>

<filter service.ui>
  @type parser
  format grok
  grok_pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
  key_name message
  reserve_data true
</filter>

<match *.**>
  @type copy
  <store>
    @type elasticsearch
    host elasticsearch
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
  </store>
  <store>
    @type stdout
  </store>
</match>
```
```shell
make fluentd_build run_logging
```

В итоге получим в Kibana:
```json
{
  "_index": "fluentd-20200827",
  "_type": "access_log",
  "_id": "fTyLL3QBELbPWWup-LHF",
  "_version": 1,
  "_score": null,
  "_source": {
    "timestamp": "2020-08-27T10:52:14.470906",
    "pid": "1",
    "loglevel": "INFO",
    "progname": "",
    "message": "Successfully showed the home page with posts",
    "service": "ui",
    "event": "show_all_posts",
    "request_id": "8a395e5a-b550-4d01-b6d3-165c9b7476b2",
    "@timestamp": "2020-08-27T10:52:14+00:00",
    "@log_name": "service.ui"
  },
  "fields": {
    "@timestamp": [
      "2020-08-27T10:52:14.000Z"
    ]
  },
  "highlight": {
    "@log_name": [
      "@kibana-highlighted-field@service.ui@/kibana-highlighted-field@"
    ]
  },
  "sort": [
    1598525534000
  ]
}
```

### Задания co *

#### grok

UI-сервис шлет логи в нескольких форматах.

```log
service=ui | event=request | path=/ | request_id=96e76ff2-3d06-4ffa-806b-c14d7ca6a78a | remote_addr=185.30.195.250 | method= GET | response_status=200
```

Такой лог остался неразобранным. Составьте конфигурацию fluentd так, чтобы разбирались оба формата логов UI-сервиса (тот, что сделали до этого и текущий) одновременно.

##### Анализ

Читаем документацию https://github.com/fluent/fluent-plugin-grok-parser/blob/master/README.md

Парсим готовые шаблоны https://github.com/fluent/fluent-plugin-grok-parser/tree/master/patterns

##### Реализация

И пишем конфиг (удобный grok-дебаггер есть в кибане: Dev Tools )

```xml
<filter service.ui>
  @type parser
  format grok
  <grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
  </grok>
  <grok>
    pattern service=%{WORD:service} \| event=%{WORD:event} \| path=%{URIPATH:path} \| request_id=%{GREEDYDATA:request_id} \| remote_addr=%{IP:remote_addr} \| method= %{WORD:message} \| response_status=%{INT:response_status}
  </grok>
  key_name message
  reserve_data true
</filter>
```

Готово.



### Распределенная трасировка

Разобраться с темой распределенного трейсинга и решить проблему в конце данного файла.

#### Zipkin

Добавьте в compose-файл для сервисов логирования сервис распределенного трейсинга Zipkin

[docker/docker-compose-logging.yml](docker/docker-compose-logging.yml)
```yaml
version: '3'

services:
  zipkin:
    image: openzipkin/zipkin
    ports:
      - "9411:9411"

  ...

  kibana:
    image: kibana
    ports:
      - "8080:5601"  # Почему 8080??? Раньше так не было... в композ-файле прописал 5601:5601
```


#### docker-compose.yml

Правим наш [docker/docker-compose.yml]([docker/docker-compose.yml])

Добавьте для каждого сервиса поддержку `ENV` переменных и задайте параметризованный параметр `ZIPKIN_ENABLED`

```yaml
environment:
   - ZIPKIN_ENABLED=${ZIPKIN_ENABLED}
```

В `.env` файле укажите
```shell
ZIPKIN_ENABLED=true
```


Перевыкатите приложение с обновлением

Метод ДЗ
```shell
docker-compose up -d
```

Метод Make
```shell
make run_app
```


#### Networks

Zipkin должен быть в одной сети с приложениями, поэтому, если вы выполняли задание с сетями, вам нужно объявить эти сети в [docker-compose-logging.yml](docker/docker-compose-logging.yml) и добавить в них zikpkin похожим образом:

```yaml
services:
  ...
  zipkin:
    image: openzipkin/zipkin
    ports:
      - "9411:9411"
    networks:
      - front_net
      - back_net


networks:
  front_net:
  back_net:
```
#### Пересоздадим наши сервисы

Метод ДЗ
```shell
docker-compose -f docker-compose-logging.yml -f docker-compose.yml down
docker-compose -f docker-compose-logging.yml -f docker-compose.yml up -d
```

Откроем Zipkin WEB UI на порту 9411, пока никаких трейсов поиск не должен дать, т.к. никаких запросов нашему приложению еще не поступало (так и есть)

Откроем главную страницу приложения и обновим ее несколько раз.

Заглянув затем в UI Zipkin (страницу потребуется обновить), мы должны найти несколько трейсов (следов, которые оставили запросы проходя через систему наших сервисов)... Да, нашли.

Нажмем на один из трейсов, чтобы посмотреть, как запрос шел через нашу систему микросервисов и каково общее время обработки запроса у нашего приложения при запросе главной страницы.

Видим, что первым делом наш запрос попал к ui сервису, который смог обработать наш запрос за суммарное время равное **187.566ms**.

Из этих **187ms** ms ушло **134.155ms** на то чтобы ui мог направить запрос post сервису по пути `/posts` и получить от него ответ в виде списка постов. Post сервис в свою очередь использовал функцию обращения к БД за списком постов, на что ушло **4.827ms**... На самом деле, не видны в трейсах обращения к БД, но посмотрим что будет дальше.

Повторим немного терминологию: синие полоски со временем называются **span** и представляют собой одну операцию, которая произошла при обработке запроса. Набор **span**-ов называется трейсом. Суммарное время обработки нашего запроса равно верхнему **span**-у, который включает в себя время всех **span**-ов, расположенных под ним.


## HomeWork 19: Введение в Kubernetes

### Создание примитивов

Опишем приложение в контексте Kubernetes с помощью manifest-ов в YAML-формате. Основным примитивом будет *Deployment*. Основные задачи сущности *Deployment*:

- Создание *Replication Controller*-а (следит, чтобы число запущенных *Pod*-ов соответствовало описанному);
- Ведение истории версий запущенных *Pod*-ов (для различных стратегий деплоя, для возможностей отката);
- Описание процесса деплоя (стратегия, параметры стратегий).

Пример *Deployment*:
`post-deployment.yml`
```yaml
---
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: post-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: post
  template:
    metadata:
      name: post
      labels:
        app: post
    spec:
      containers:
      - image: kazhem/post
        name: post
```

### Задание

- Создайте директорию `kubernetes` в корне репозитория;
- Внутри директории `kubernetes` создайте директорию `reddit`;
- Сохраните файл [post-deployment.yml](kubernetes/reddit/post-deployment.yml) в директории `kubernetes/reddit`;
- Создайте собственные файлы с *Deployment* манифестами приложений и сохраните в папке `kubernetes/reddit`;
  - [ui-deployment.yml](kubernetes/reddit/ui-deployment.yml)
  - [comment-deployment.yml](kubernetes/reddit/comment-deployment.yml)
  - [mongo-deployment.yml](kubernetes/reddit/mongo-deployment.yml)

P.S. Эту директорию и файлы в ней в дальнейшем мы будем развивать (пока это нерабочие экземпляры).


### Kubernetes The Hard Way

["Сложный путь"](https://github.com/kelseyhightower/kubernetes-the-hard-way) установить Kubernetes

В качестве домашнего задания предлагается пройти [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) разработанный инженером Google Kelsey Hightower
Туториал представляет собой:
- Пошаговое руководство по ручной инсталляции основных компонентов Kubernetes кластера;
- Краткое описание необходимых действий и объектов.

На текущий момент:

- Версия Kubernetes в данном гайде зависла на 1.15

Тем, кто уже проходил THW ранее, советуем попробовать установить версию 1.17 самостоятельно, не прибегая к помощи репозитория.

### Задание

- Создать отдельную директорию `the_hard_way` в директории `kubernetes`;
- Пройти **Kubernetes The Hard Way**;
- Проверить, что `kubectl apply -f <filename>` проходит по созданным до этого deployment-ам (`ui`, `post`, `mongo`, `comment`) и поды запускаются;
- Удалить кластер после прохождения THW;
- Все созданные в ходе прохождения THW файлы (кроме бинарных) поместить в папку `kubernetes/the_hard_way` репозитория (сертификаты и ключи тоже можно коммитить, но только после удаления кластера).

### Возможные проблемы

Если на шаге **Bootstrapping the etcd Cluster** у вас не работает команда `sudo systemctl start etcd`, то, вероятно, Вы не используете параллельный ввод с помощью tmux, а выполняете команды для каждого сервера отдельно. Для того, чтобы команда выполнилась успешно, установите `etcd` на каждый необходимый инстанс и **одновременно** запустите её на всех инстансах.

Если в процессе выполнения команд возникает ошибка `(gcloud.compute.addresses.describe) argument --region: expected one argument`, то убедитесь, что Вы выполняете команду в нужном месте. Обычно это происходит, когда команду необходимо выполнять на локальной машине, а она выполняется на каком то из инстансов. Если команда точно выполняется локально, то выполните:
```
{
  gcloud config set compute/region us-west1
  gcloud config set compute/zone us-west1-c
}
```

### Задание со \*

- Описать установку компонентов Kubernetes из THW в виде Ansible-плейбуков в папке `kubernetes/ansible`;
- Задание достаточно выполнить в виде Proof of Concept, просто автоматизация некоторых действий туториала.

Задание со * выполняться не будет, так как практическое применение не предвидится, к тому же есть же [KubeSpray](https://github.com/kubernetes-sigs/kubespray)

### Выполнение задания

Выполнение задания будет описано в отдельном файле [kubernetes/the_hard_way/README.md](kubernetes/the_hard_way/README.md)

### Проверка деплоя

Кластер развёрнут по THW: [описание процесса](./kubernetes/the_hard_way/README.md)

Далее - деплой подов нашего приложения:

```shell
cd kubernetes/reddit
kubectl apply -f ./
```
```log
deployment.apps/comment-deployment created
deployment.apps/mongo-deployment created
deployment.apps/post-deployment created
deployment.apps/ui-deployment created
```

```shell
kubectl get pods
```
```log
NAME                                  READY   STATUS    RESTARTS   AGE
busybox                               1/1     Running   0          51m
comment-deployment-5bb6744cdd-rprz9   1/1     Running   0          32s
mongo-deployment-86d49445c4-fzsbp     1/1     Running   0          31s
nginx-554b9c67f9-zkpn2                1/1     Running   0          42m
post-deployment-7576fb4896-m9tm7      1/1     Running   0          31s
ui-deployment-57d7c9fd56-s7gcq        1/1     Running   0          30s
```
