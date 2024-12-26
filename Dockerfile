# Базовый образ с поддержкой GCC
FROM gcc:latest

# Устанавливаем необходимые утилиты
RUN apt-get update && apt-get install -y \
    git \
    wget \
    libtool \
    autoconf \
    automake \
    sudo

# Указываем рабочую директорию для исходников
WORKDIR /usr/local/src

# Скачиваем, проверяем и собираем libquantum
RUN git clone https://github.com/libquantum/libquantum.git && \
    cd libquantum && \
    ./configure && make && make install && \
    echo "Проверяем наличие исходников..." && ls -l /usr/local/src/libquantum

# Добавляем пользователя с UID 1000
RUN useradd -m -u 1000 user && echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Настраиваем переменную окружения LD_LIBRARY_PATH (без использования неопределённого значения)
ENV LD_LIBRARY_PATH="/usr/local/lib"

# Переходим в домашнюю директорию пользователя
WORKDIR /home/user

# Копируем тестовый проект в /home/user и меняем владельца на пользователя с UID 1000
COPY test_project.c /home/user/
RUN chown -R user:user /home/user

# Выполняем сборку проекта от имени пользователя
USER user
RUN gcc test_project.c -o test_project -lquantum -fopenmp

# Указываем точку входа и добавляем проверки
CMD ["/bin/sh", "-c", "echo 'Проверяем исходники...' && \
    ls -l /usr/local/src/libquantum && \
    echo 'Проверяем права доступа...' && \
    ls -l /home/user && \
    echo 'Текущий пользователь:' && id && \
    ./test_project"]
