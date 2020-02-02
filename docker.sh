#!/bin/bash

set -o errexit

main() {
  # arg 1 holds switch string
  # arg 2 holds node version
  # arg 3 holds tag suffix

  case $1 in
  "prepare")
    docker_prepare
    ;;
  "build")
    docker_build
    ;;
  "test")
    docker_test
    ;;
  "tag")
    docker_tag
    ;;
  "push")
    docker_push
    ;;
  "manifest-list-version")
    docker_manifest_list_version "$2" "$3"
    ;;
  "manifest-list-test-beta-latest")
    docker_manifest_list_test_beta_latest "$2" "$3"
    ;;
  *)
    echo "none of above!"
    ;;
  esac
}

function docker_prepare() {
  # Prepare the machine before any code installation scripts
  setup_dependencies

  # Update docker configuration to enable docker manifest command
  update_docker_configuration

  # Prepare qemu to build images other then x86_64 on travis
  prepare_qemu
}

function docker_build() {
  # Build Docker image
  echo "DOCKER BUILD: Build Docker image."
  echo "DOCKER BUILD: arch - ${ARCH}."
  echo "DOCKER BUILD: build version -> ${BUILD_VERSION}."
  echo "DOCKER BUILD: webtrees version -> ${WT_VERSION}."
  echo "DOCKER BUILD: qemu arch - ${QEMU_ARCH}."
  echo "DOCKER BUILD: docker file - ${DOCKER_FILE}."

  docker build --no-cache \
    --build-arg ARCH=${ARCH} \
    --build-arg BUILD_DATE=$(date +"%Y-%m-%dT%H:%M:%SZ") \
    --build-arg BUILD_VERSION=${BUILD_VERSION} \
    --build-arg BUILD_REF=${TRAVIS_COMMIT} \
    --build-arg WT_VERSION=${WT_VERSION} \
    --build-arg QEMU_ARCH=${QEMU_ARCH} \
    --file ./${DOCKER_FILE} \
    --tag ${TARGET}:build .
}

function docker_test() {
  echo "DOCKER TEST: Test Docker image."
  echo "DOCKER TEST: testing image -> ${TARGET}:build"

  docker run -d --rm --name=testing ${TARGET}:build
  if [ $? -ne 0 ]; then
    echo "DOCKER TEST: FAILED - Docker container testing failed to start."
    exit 1
  else
    echo "DOCKER TEST: PASSED - Docker container testing succeeded to start."
  fi
}

function docker_tag() {
  echo "DOCKER TAG: Tag Docker image."

  echo "DOCKER TAG: tagging image - ${TARGET}:${BUILD_VERSION}-${ARCH}"
  docker tag ${TARGET}:build ${TARGET}:${BUILD_VERSION}-${ARCH}
}

function docker_push() {
  echo "DOCKER PUSH: Push Docker image."

  echo "DOCKER TAG: pushing image - ${TARGET}:${BUILD_VERSION}-${ARCH}"
  docker push ${TARGET}:${BUILD_VERSION}-${ARCH}
}

function docker_manifest_list_version() {

  echo "DOCKER MANIFEST: Create and Push docker manifest list - ${TARGET}:${BUILD_VERSION}."

  docker manifest create ${TARGET}:${BUILD_VERSION} \
    ${TARGET}:${BUILD_VERSION}-amd64 \
    ${TARGET}:${BUILD_VERSION}-i386 \
    ${TARGET}:${BUILD_VERSION}-arm32v7 \
    ${TARGET}:${BUILD_VERSION}-arm64v8 \
    ${TARGET}:${BUILD_VERSION}-ppc64le \
    ${TARGET}:${BUILD_VERSION}-s390x

  docker manifest annotate ${TARGET}:${BUILD_VERSION} ${TARGET}:${BUILD_VERSION}-i386 --os=linux --arch=386
  docker manifest annotate ${TARGET}:${BUILD_VERSION} ${TARGET}:${BUILD_VERSION}-arm32v7 --os=linux --arch=arm --variant=v7
  docker manifest annotate ${TARGET}:${BUILD_VERSION} ${TARGET}:${BUILD_VERSION}-arm64v8 --os=linux --arch=arm64 --variant=v8
  docker manifest annotate ${TARGET}:${BUILD_VERSION} ${TARGET}:${BUILD_VERSION}-ppc64le --os=linux --arch=ppc64le
  docker manifest annotate ${TARGET}:${BUILD_VERSION} ${TARGET}:${BUILD_VERSION}-s390x --os=linux --arch=s390x
  
  docker manifest push ${TARGET}:${BUILD_VERSION}
  
  docker run --rm mplatform/mquery ${TARGET}:${BUILD_VERSION}
}

function docker_manifest_list_test_beta_latest() {

  if [[ ${BUILD_VERSION} == *"test"* ]]; then
    export TAG_PREFIX="test";
  elif [[ ${BUILD_VERSION} == *"beta"* ]]; then
    export TAG_PREFIX="beta";
  else
    export TAG_PREFIX="latest";
  fi

  echo "DOCKER MANIFEST: Create and Push docker manifest list - ${TARGET}:${TAG_PREFIX}."

  docker manifest create ${TARGET}:${TAG_PREFIX} \
    ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-amd64 \
    ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-i386 \
    ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-arm32v7 \
    ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-arm64v8 \
    ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-ppc64le \
    ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-s390x

  docker manifest annotate ${TARGET}:${TAG_PREFIX} ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-i386 --os=linux --arch=386
  docker manifest annotate ${TARGET}:${TAG_PREFIX} ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-arm32v7 --os=linux --arch=arm --variant=v7
  docker manifest annotate ${TARGET}:${TAG_PREFIX} ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-arm64v8 --os=linux --arch=arm64 --variant=v8
  docker manifest annotate ${TARGET}:${TAG_PREFIX} ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-ppc64le --os=linux --arch=ppc64le
  docker manifest annotate ${TARGET}:${TAG_PREFIX} ${TARGET}:${TAG_PREFIX}${BUILD_VERSION}-s390x --os=linux --arch=s390x

  docker manifest push ${TARGET}:${TAG_PREFIX}
  
  docker run --rm mplatform/mquery ${TARGET}:${TAG_PREFIX}
}

function setup_dependencies() {
  echo "PREPARE: Setting up dependencies."
  sudo apt update -y
  sudo apt install --only-upgrade docker-ce -y
}

function update_docker_configuration() {
  echo "PREPARE: Updating docker configuration"

  mkdir $HOME/.docker

  # enable experimental to use docker manifest command
  echo '{
    "experimental": "enabled"
  }' | tee $HOME/.docker/config.json

  # enable experimental
  echo '{
    "experimental": true,
    "storage-driver": "overlay2",
    "max-concurrent-downloads": 50,
    "max-concurrent-uploads": 50
  }' | sudo tee /etc/docker/daemon.json

  sudo service docker restart
}

function prepare_qemu() {
  echo "PREPARE: Qemu"
  # Prepare qemu to build non amd64 / x86_64 images
  docker run --rm --privileged multiarch/qemu-user-static:register --reset
  mkdir tmp
  pushd tmp &&
    curl -L -o qemu-x86_64-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-x86_64-static.tar.gz && tar xzf qemu-x86_64-static.tar.gz &&
    curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-arm-static.tar.gz && tar xzf qemu-arm-static.tar.gz &&
    curl -L -o qemu-i386-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-i386-static.tar.gz && tar xzf qemu-i386-static.tar.gz &&
    curl -L -o qemu-ppc64le-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-ppc64le-static.tar.gz && tar xzf qemu-ppc64le-static.tar.gz &&
    curl -L -o qemu-s390x-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-s390x-static.tar.gz && tar xzf qemu-s390x-static.tar.gz &&
    curl -L -o qemu-aarch64-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/$QEMU_VERSION/qemu-aarch64-static.tar.gz && tar xzf qemu-aarch64-static.tar.gz &&
    popd
}

main "$1" "$2" "$3"
