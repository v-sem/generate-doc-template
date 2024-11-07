#!/bin/bash

WORKING_DIR="$(pwd)"
BIN_DIR="${WORKING_DIR}/bin"

if [ ! -f "${BIN_DIR}/protoc-gen-doc" ]; then
    mkdir -p "${BIN_DIR}"
    GOBIN="${BIN_DIR}" go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@latest
fi

PROTO_PATH=$1
PATH="${BIN_DIR}:${PATH}"
mkdir -p ./doc
protoc -Iapi -Ivendor.proto --doc_out=./doc --doc_opt=./api.tmpl,api.md "${PROTO_PATH}"

# Используем awk для разбивки на файлы
cd ./doc
awk '
    # Ищем строки вида --FILE:file_name.txt--
    /^--FILE:.*--$/ {
        # Извлекаем имя файла, удаляя --SPLIT: и --
        out_file = substr($0, 8, length($0) - 9)
        next
    }
    # Если имя выходного файла определено, записываем в него строки
    out_file {
        print > out_file
    }
' "api.md"