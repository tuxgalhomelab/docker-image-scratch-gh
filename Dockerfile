FROM tuxgal/homelab-base:master

ARG PYENV_VERSION=v2.5.3
ARG PYENV_SHA256_CHECKSUM=2068872d4f3174d697bcfd602ada3dc2b7764e84f73be7850c0de86fbf00f69e
ARG IMAGE_PYTHON_VERSION=3.12.9

RUN \
    set -E -e -o pipefail \
    && export HOMELAB_VERBOSE=y \
    # Install dependencies. \
    && homelab install build-essential libbz2-dev libffi-dev liblzma-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev zlib1g-dev \
    # Install python. \
    && homelab install-tar-dist \
        https://github.com/pyenv/pyenv/archive/refs/tags/${PYENV_VERSION:?}.tar.gz \
        ${PYENV_SHA256_CHECKSUM:?} \
        pyenv \
        pyenv-${PYENV_VERSION#"v"} \
        root \
        root \
    && pushd /opt/pyenv \
    && src/configure \
    && make -C src \
    && popd \
    && export PYENV_ROOT="/opt/pyenv" \
    && export PATH="/opt/pyenv/shims:/opt/pyenv/bin:${PATH}" \
    && eval "$(pyenv init -)" \
    && pyenv install ${IMAGE_PYTHON_VERSION:?} \
    && pyenv global ${IMAGE_PYTHON_VERSION:?} \
    # Clean up. \
    && homelab cleanup

ENV PYENV_ROOT="/opt/pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"
