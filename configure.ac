#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([polymino], [0.1])
AM_INIT_AUTOMAKE([1.13 foreign no-dist-gzip dist-xz])
AC_CONFIG_SRCDIR([src/polymino.vala])
AC_CONFIG_HEADERS([config.h])

# Simplifies the verbosity of the compilation output.
# m4_ifdef([AM_SILENT_RULES],[AM_SILENT_RULES([yes])])

# I18n
IT_PROG_INTLTOOL(0.50.0)
GETTEXT_PACKAGE=polymino
AC_SUBST([GETTEXT_PACKAGE])
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE],["$GETTEXT_PACKAGE"],[The gettext domain name])

# Checks for programs.
AC_PROG_CC
AC_PROG_CC_STDC
AC_PROG_INSTALL
AC_PROG_MAKE_SET
AM_PROG_VALAC([0.20])
# Checks for libraries.

PKG_PROG_PKG_CONFIG([0.22])

AC_PATH_PROG(GLIB_COMPILE_RESOURCES, glib-compile-resources)

GLIB_GSETTINGS

# Checks for modules.
pkg_modules="glib-2.0 \
             gmodule-2.0 \
             gee-1.0 \
             gtk+-3.0"

PKG_CHECK_MODULES(POLYMINO, [$pkg_modules])
# This variables are defined by pkg-config modules
# AC_SUBST(POLYMINO_CFLAGS)
# AC_SUBST(POLYMINO_LIBS)



# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile
                 data/Makefile
                 po/Makefile.in
                 data/org.el.polymino.gschema.xml.in
                 src/Makefile])
AC_OUTPUT

echo "
 
configuration summary:
 
for package: ${PACKAGE}, Ver.: ${VERSION}

source code location:......... ${srcdir} 
compiler:..................... ${CC}
valac:........................ ${VALAC}
vapigen:...................... ${VAPIGEN}
prefix:....................... ${prefix}
compiler flags:............... ${CFLAGS}
compiler pre-processor flags:. ${CPPFLAGS}
"
