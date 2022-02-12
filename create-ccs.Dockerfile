FROM docker pull gentoo/stage3
RUN mv /etc/portage/make.conf /etc/portage/custom
RUN mkdir -p /etc/portage/make.conf
RUN mv /etc/portage/custom /etc/portage/make.conf/custom
RUN echo 'MAKEOPTS="-j3"' >> /etc/portage/make.conf/custom
RUN echo 'EMERGE_JOBS="--jobs=3"' >> /etc/portage/make.conf/custom
RUN emerge --sync
RUN emerge --oneshot sys-apps/portage
RUN echo 'app-portage/eix \
app-text/tree \
dev-vcs/git \
sys-apps/busybox \
sys-apps/openrc' > /var/lib/portage/world
RUN emerge -uDN @world
RUN emerge -c
RUN emerge -1 app-eselect/eselect-repository
RUN eselect repository add container git https://github.com/RodionD/container.git
RUN eselect repository add calculate git https://github.com/RodionD/calculate.git
RUN eselect repository enable container
RUN eselect repository enable calculate
RUN emerge --sync container
RUN emerge --sync calculate
RUN eselect profile set container:CCS/arm64/20
RUN mkdir -p /var/calculate/tmp
RUN emerge -1O app-arch/libarchive
RUN emerge -uDN @world
RUN regenworld

RUN echo 'sys-apps/calculate-utils:3' > /var/lib/portage/world

RUN emerge -uDN @world
