#!/bin/bash

# Автор проекта: Емельянов Григорий Андреевич @emelyagr https://github.com/emelyagr
# Author of the project: Emelyanov Grigory Andreevich @emelyagr https://github.com/emelyagr

echo -e "\e[34m"
echo " "
echo "//////////////////////////////////////////////////////////"
echo "///                                                    ///"
echo "///                 Webdirectorylist                   ///"
echo "///                                                    ///"
echo "//////////////////////////////////////////////////////////"
echo -e "\e[0m"
echo " "

# Запрос ввода URL веб-сайта от пользователя
read -p "Пожалуйста, введите URL веб-сайта: " WEBSITE_URL

# Проверка, что пользователь ввел URL
if [ -z "$WEBSITE_URL" ]; then
  echo "Пожалуйста, введите URL веб-сайта."
  exit 1
fi

# Директория для сохранения скачанного сайта
DOWNLOAD_DIR="downloaded_website"

# Создание директории для сохранения сайта, если она не существует
mkdir -p "$DOWNLOAD_DIR"

# Скачивание всего сайта с помощью wget
wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains "$(echo $WEBSITE_URL | cut -d'/' -f3)" --no-parent -P "$DOWNLOAD_DIR" "$WEBSITE_URL"

# Автор проекта: Емельянов Григорий Андреевич @emelyagr https://github.com/emelyagr
# Author of the project: Emelyanov Grigory Andreevich @emelyagr https://github.com/emelyagr

# Проверка, что wget успешно завершил скачивание
if [ $? -ne 0 ]; then
  echo "Ошибка при скачивании сайта."
  exit 1
fi

# Извлечение ссылок на директории из скачанных HTML-страниц
grep -oP '(?<=href=")/[^"]*' "$DOWNLOAD_DIR"/*.html | sort | uniq

# Обработка относительных ссылок
for dir in $(grep -oP '(?<=href=")/[^"]*' "$DOWNLOAD_DIR"/*.html | sort | uniq); do
  if [[ ! $dir == /* ]]; then
    dir="/$dir"
  fi
  echo "$WEBSITE_URL$dir"
done | column
