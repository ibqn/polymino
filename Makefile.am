ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}

SUBDIRS = src data po

MAINTAINERCLEANFILES = \
	ABOUT-NLS \
	aclocal.m4 \
	config.guess \
	config.sub \
	config.h.in \
	depcomp \
	install-sh \
	ltmain.sh \
	missing \
	$(VALA_SOURCES:.vala=.c) \
	*/*~ \
	*/*/*~ \
	*.stamp

-include $(top_srcdir)/git.mk
