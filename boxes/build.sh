cd FreeBSD-10.1-RELEASE \
    && (rm -rf build || true) \
    && packer build freebsd.json \
    && cd - \
    && cd DevBox \
    && packer build devbox.json \
    && vagrant box add --force devbox build/devbox.box
