#!/bin/bash

# INIT SUBMODULES
${SED_INLINE} 's|git://git.savannah.gnu.org|https://github.com/arthenica|g' "${BASEDIR}"/src/"${LIB_NAME}"/.gitmodules || return 1
# Vocal Remover build: pin gnulib to the revision matching libiconv 1.17 (2022-05-15).
# gitsub.sh pulls gnulib master, whose m4 macros no longer match libiconv 1.17's configure.ac,
# and cannot pull once gnulib is on a pinned (detached) revision, so only clone it the first time.
if [[ ! -d gnulib/.git ]]; then
  ./gitsub.sh pull || return 1
fi
git -C gnulib checkout -q 4bc2b6f67259e3fb54d21d3b93e7cab12161f7fd || return 1

# ALWAYS CLEAN THE PREVIOUS BUILD
make distclean 2>/dev/null 1>/dev/null

# REGENERATE BUILD FILES IF NECESSARY OR REQUESTED
if [[ ! -f "${BASEDIR}"/src/"${LIB_NAME}"/configure ]] || [[ ${RECONF_libiconv} -eq 1 ]]; then
  ./autogen.sh || return 1
fi

./configure \
  --prefix="${LIB_INSTALL_PREFIX}" \
  --with-pic \
  --with-sysroot="${ANDROID_SYSROOT}" \
  --enable-static \
  --disable-shared \
  --disable-fast-install \
  --disable-rpath \
  --host="${HOST}" || return 1

make -j$(get_cpu_count) || return 1

make install || return 1

# CREATE PACKAGE CONFIG MANUALLY
create_libiconv_package_config "1.17" || return 1
