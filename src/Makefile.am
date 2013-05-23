bin_PROGRAMS = \
	polymino

BUILT_SOURCES = \
	resources.c

resources.c: $(top_srcdir)/data/polymino.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/data $(top_srcdir)/data/polymino.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/data --generate-source $<

polymino_SOURCES = \
        $(BUILT_SOURCES) \
	frame.vala \
        piece.vala \
        polymino.vala \
	config.vapi

AM_LDFLAGS = \
	$(POLYMINO_LIBS)

AM_CFLAGS = \
	$(POLYMINO_CFLAGS) \
	-Wall

AM_CPPFLAGS = 


AM_VALAFLAGS = \
	--target-glib=2.36 \
	--pkg gee-1.0 \
        --pkg gmodule-2.0 \
        --enable-experimental \
	--pkg gtk+-3.0

CLEANFILES = \
	$(patsubst %.vala,%.c,$(filter %.vala, $(SOURCES))) \
	*_vala.stamp

-include $(top_srcdir)/git.mk
