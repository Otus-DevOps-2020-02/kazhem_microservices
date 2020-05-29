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
