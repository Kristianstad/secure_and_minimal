ARG SaM_REPO=${SaM_REPO:-ghcr.io/kristianstad/secure_and_minimal}
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.23}

FROM ${SaM_REPO}:alpine-${ALPINE_VERSION} AS image

COPY ./rootfs /

RUN exec 2>&1 \
 && set -x \
 && chmod u+x /usr/sbin/relpath /usr/sbin/onbuildrun.sh \
 && mkdir -p /excludefs /finalfs \
 && apk --no-cache --initramfs-diskless-boot --clean-protected add \
      acl bash build-base libtool cmake automake autoconf linux-headers git libcurl \
 && apk info

# =========================================================================
# ONBUILD - Executed/available when building the main Docker image
# =========================================================================
    # ---------------------------------------------------------------------
    # ARG - Set in main Docker image
    # ---------------------------------------------------------------------
        ONBUILD ARG HUBPROFILE
        ONBUILD ARG HUBREPO
        ONBUILD ARG HUBVERSION
        ONBUILD ARG IMAGEID
        ONBUILD ARG IMAGETYPE
        ONBUILD ARG CONTENTIMAGE1
        ONBUILD ARG CONTENTSOURCE1
        ONBUILD ARG CONTENTDESTINATION1
        ONBUILD ARG CONTENTIMAGE2
        ONBUILD ARG CONTENTSOURCE2
        ONBUILD ARG CONTENTDESTINATION2
        ONBUILD ARG CONTENTIMAGE3
        ONBUILD ARG CONTENTSOURCE3
        ONBUILD ARG CONTENTDESTINATION3
        ONBUILD ARG CONTENTIMAGE4
        ONBUILD ARG CONTENTSOURCE4
        ONBUILD ARG CONTENTDESTINATION4
        ONBUILD ARG CONTENTIMAGE5
        ONBUILD ARG CONTENTSOURCE5
        ONBUILD ARG CONTENTDESTINATION5
        ONBUILD ARG ADDREPOS
        ONBUILD ARG RUNDEPS
        ONBUILD ARG RUNDEPS_UNTRUSTED
        ONBUILD ARG EXCLUDEAPKS
        ONBUILD ARG EXCLUDEDEPS
        ONBUILD ARG MAKEDIRS
        ONBUILD ARG MAKEFILES
        ONBUILD ARG BUILDDIR
        ONBUILD ARG CLONEGITS
        ONBUILD ARG CLONEGITSDIR
        ONBUILD ARG DOWNLOADS
        ONBUILD ARG DOWNLOADSDIR
        ONBUILD ARG BUILDDEPS
        ONBUILD ARG BUILDDEPS_UNTRUSTED
        ONBUILD ARG DESTDIR
        ONBUILD ARG LANG
        ONBUILD ARG CHARSET
        ONBUILD ARG CC
        ONBUILD ARG MPICC
        ONBUILD ARG MPICXX
        ONBUILD ARG JAVA_HOME
        ONBUILD ARG JRE_HOME
        ONBUILD ARG ADDTO_CFLAGS
        ONBUILD ARG CFLAGS
        ONBUILD ARG ADDTO_PATH
        ONBUILD ARG PATH
        ONBUILD ARG ADDTO_CPATH
        ONBUILD ARG CPATH
        ONBUILD ARG ADDTO_LIBRARY_PATH
        ONBUILD ARG LIBRARY_PATH
        ONBUILD ARG ADDTO_LD_LIBRARY_PATH
        ONBUILD ARG LD_LIBRARY_PATH
        ONBUILD ARG COMMON_CONFIGUREPREFIX
        ONBUILD ARG COMMON_CONFIGURECMD
        ONBUILD ARG COMMON_CMAKECMD
        ONBUILD ARG COMMON_MAKECMDS
        ONBUILD ARG COMMON_INSTALLSRC
        ONBUILD ARG EXECUTABLES
        ONBUILD ARG STARTUPEXECUTABLES
        ONBUILD ARG EXPOSEFUNCTIONS
        ONBUILD ARG GID0WRITABLES
        ONBUILD ARG GID0WRITABLESRECURSIVE
        ONBUILD ARG LINUXUSEROWNED
        ONBUILD ARG LINUXUSEROWNEDRECURSIVE
        ONBUILD ARG REMOVEDIRS
        ONBUILD ARG REMOVEFILES
        ONBUILD ARG INITCMDS
        ONBUILD ARG BUILDCMDS
        ONBUILD ARG KEEPEMPTYDIRS
        ONBUILD ARG FINALCMDS

    # ---------------------------------------------------------------------
    # ENV
    # ---------------------------------------------------------------------
        ONBUILD ENV HUBPROFILE="${HUBPROFILE}"
        # ... (resten av ENV-blocket behålls oförändrat)
        ONBUILD ENV FINALCMDS="${FINALCMDS}"

    # ---------------------------------------------------------------------
    # COPY & RUN (ONBUILD)
    # ---------------------------------------------------------------------
        ONBUILD COPY --from=base / /finalfs/
        ONBUILD COPY --from=init / /tmp/initfs/
        ONBUILD COPY --from=content1 "$CONTENTSOURCE1" "$CONTENTDESTINATION1"
        # ... (övriga COPY-rader behålls)

        ONBUILD COPY ./ /tmp/

        ONBUILD RUN /usr/sbin/onbuildrun.sh || ( echo "BUILD FAILED!" && touch "/fail" )
        ONBUILD RUN cat /build.log && [ ! -e "/fail" ]

# Final stage
FROM image
