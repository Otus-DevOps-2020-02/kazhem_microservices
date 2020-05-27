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


## HomeWork 13: Docker образы. Микросервисы

## Настройка
* Установлен Dockrfile linter [hadolint](https://github.com/hadolint/hadolint/releases/tag/v1.17.6)

#### Dockerfile best practices (collapsed)

<details><summary>Dockerfile best practices</summary>
<p>

https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

* [FROM](https://docs.docker.com/develop/develop-images/#from)

  We recommend the Alpine image as it is tightly controlled and small in size (currently under 5 MB), while still being a full Linux distribution.

* [LABEL](https://docs.docker.com/develop/develop-images/#label)

  For each label, add a line beginning with LABEL and with one or more key-value pairs.

* [RUN](https://docs.docker.com/develop/develop-images/#run)

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

* [CMD](https://docs.docker.com/develop/develop-images/#cmd)

  `CMD` should almost always be used in the form of `CMD ["executable", "param1", "param2"…]`. Thus, if the image is for a service, such as Apache and Rails, you would run something like `CMD ["apache2","-DFOREGROUND"]`.

  `CMD` should rarely be used in the manner of `CMD ["param", "param"]` in conjunction with `ENTRYPOINT`.

* [EXPOSE](https://docs.docker.com/develop/develop-images/#expose)

  you should use the common, traditional port for your application
  For example, an image containing the Apache web server would use `EXPOSE 80`, while an image containing MongoDB would use `EXPOSE 27017` and so on.
  For container linking, Docker provides environment variables for the path from the recipient container back to the source (ie, `MYSQL_PORT_3306_TCP`).

* [ENV](https://docs.docker.com/develop/develop-images/#env)

  For example, `ENV PATH /usr/local/nginx/bin:$PATH` ensures that `CMD ["nginx"]` just works.

  The `ENV` instruction is also useful for providing required environment variables specific to services you wish to containerize, such as Postgres’s `PGDATA`.

  Lastly, `ENV` can also be used to set commonly used version numbers so that version bumps are easier to maintain. Similar to having constant variables in a program (as opposed to hard-coding values), this approach lets you change a single ENV instruction to auto-magically bump the version of the software in your container.

  Each `ENV` line creates a new intermediate layer, just like `RUN` commands. This means that even if you unset the environment variable in a future layer, it still persists in this layer and its value can be dumped. To prevent this, and really unset the environment variable, use a RUN command with shell commands.

* [ADD or COPY](https://docs.docker.com/develop/develop-images/#add-or-copy)

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

* [ENTRYPOINT](https://docs.docker.com/develop/develop-images/#entrypoint)

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

* [VOLUME](https://docs.docker.com/develop/develop-images/#volume)

  The VOLUME instruction should be used to expose any database storage area, configuration storage, or files/folders created by your docker container. You are strongly encouraged to use VOLUME for any mutable and/or user-serviceable parts of your image.

* [USER](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user)

  If a service can run without privileges, use `USER` to change to a non-root user. Start by creating the user and group in the Dockerfile with something like
  ```Dockerfile
  RUN groupadd -r postgres && useradd --no-log-init -r -g postgres postgres
  ```

  WARNING: [unresolved bug](https://github.com/golang/go/issues/13548)

  Avoid installing or using `sudo` as it has unpredictable TTY and signal-forwarding behavior that can cause problems. If you absolutely need functionality similar to `sudo`, such as initializing the daemon as root but running it as non-root, consider using `“gosu”`.

* [WORKDIR](https://docs.docker.com/develop/develop-images/#workdir)

  For clarity and reliability, you should always use absolute paths for your `WORKDIR`. Also, you should use `WORKDIR` instead of proliferating instructions like `RUN cd … && do-something`, which are hard to read, troubleshoot, and maintain.

* [ONBUILD](https://docs.docker.com/develop/develop-images/#onbuild)

  An `ONBUILD` command executes after the current `Dockerfile` build completes. `ONBUILD` executes in any child image derived FROM the current image. Think of the `ONBUILD` command as an instruction the parent `Dockerfile` gives to the child `Dockerfile`.
  `ONBUILD` is useful for images that are going to be built `FROM` a given image.
  [Ruby’s ONBUILD variants](https://github.com/docker-library/ruby/blob/c43fef8a60cea31eb9e7d960a076d633cb62ba8d/2.4/jessie/onbuild/Dockerfile)
  Images built with `ONBUILD` should get a separate tag, for example: `ruby:1.9-onbuild` or `ruby:2.0-onbuild`.

</p>
</details>

### Выполнение

#### Подготовка

* Скачан и распакован архив [microservices.zip](https://github.com/express42/reddit/archive/microservices.zip)
  ```shell
  wget https://github.com/express42/reddit/archive/microservices.zip && \
    unzip microservices.zip && \
    rm microservices.zip
  ```
* Каталог `reddit-microservices` переименован в `src`
  ```shell
  mv reddit-microservices src
  ```

* Создан файл [src/post-py/Dockerfile](src/post-py/Dockerfile)
* Создан файл [src/comment/Dockerfile](src/comment/Dockerfile)
* Создан файл [src/ui/Dockerfile](src/ui/Dockerfile)
* Все Докерфайлы оптимизированы в соответствии с [рекомендациями](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
* Скачан последний образ MongoDB
  ```shell
  docker pull mongo:latest
  ```

#### Сборка

* Собраны образы:
  ```
  docker build -t kazhem/post:1.0 ./post-py
  docker build -t kazhem/comment:1.0 ./comment
  docker build -t kazhem/ui:1.0 ./ui
  ```
  Сборка `ui` началась не с первого шага, потому что слой с установленным пакетом `build-essential` уже был создан на этапе сборки `comment`, а сейчас был взят из build-cache вместо ссборки с нуля.

#### Запуск

* Создана специальная сеть для приложения:
  ```
  docker network create reddit
  ```
* Запущены контейнеры:
  ```
  docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
  docker run -d --network=reddit --network-alias=post kazhem/post:1.0
  docker run -d --network=reddit --network-alias=comment kazhem/comment:1.0
  docker run -d --network=reddit -p 9292:9292 kazhem/ui:1.0
  ```
* Сайт работает

* Задание со *: Запустите контейнеры с другими сетевыми алиасами
  * В соответствие с [теорией](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file) добавлены environment переменные
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
  * Сервис работает

#### Образы приложений

* Уменьшен образ `ui`, за счёт пересборки его на основе ubuntu:16.04
* Задание со *: Уменьшаем размер образов
  * На основе:
    * [Официальная wiki](https://wiki.alpinelinux.org/wiki)
    * [Статья на habr](https://habr.com/ru/company/digdes/blog/415279/)
    * [Статья на habr](https://habr.com/ru/company/digdes/blog/440658/)
    * [Получаем максимум от Docker. Микроконтейнеры и Alpine Linux](https://youtu.be/ClX9jbiVLaY)
  * Сделан вывод о том, что наиболее эффективным решением будет использование для приложений образов на основе alpine-linux
  * **ui**: Образ пересобран на базе ruby:2.2-alpine. Установка зависимостей потребовала установки build-base. Установка build-base, установка зависимостей и удаление build-base выполняется одной инструкцией RUN, чтобы избежать создания лишних образов.
  * Занимаемый объём уменьшился в 5 раз относительно ruby2.2 и в 3 раза относительно ubuntu:16.04
  * Такие же манипуляции были проделаны для commnent
  * Образ post уже был на основе alpine
  * Работоспособность проверена

#### Подключение volume
* Создан образ: `docker volume create reddit_db`
* Запущены контейнеры с подключенным volume:
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
* Написан пост
* При перезапуске пост не удален
