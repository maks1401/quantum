# Базовый образ с поддержкой GCC
FROM gcc:latest

# Устанавливаем дополнительные утилиты
RUN apt-get update && apt-get install -y \
    git \
    wget \
    libtool \
    autoconf \
    automake

# Скачиваем и собираем libquantum
RUN git clone https://github.com/libquantum/libquantum.git && \
    cd libquantum && \
    ./configure && make && make install

# Указываем путь к библиотекам
ENV LD_LIBRARY_PATH="/usr/local/lib"

# Указываем рабочую директорию для приложения
WORKDIR /app

# Копируем тестовый проект
COPY test_project.c /app

# Запускаем тестовый проект
RUN gcc test_project.c -o test_project -lquantum -fopenmp

# Указываем точку входа
CMD ["./test_project"]
