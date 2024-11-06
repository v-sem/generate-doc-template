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
