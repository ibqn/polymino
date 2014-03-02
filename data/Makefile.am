# Desktop file
# (we can't use INTLTOOL_DESKTOP_RULE here due to lp#605826)
%.desktop: %.desktop.in
	$(MKDIR_P) $(dir $@); LC_ALL=C $(INTLTOOL_MERGE) -d -u -c $(top_builddir)/po/.intltool-merge-cache $(top_srcdir)/po $< $@
applicationsdir = $(datadir)/applications
applications_DATA = org.el.polymino.desktop
dist_noinst_DATA = org.el.polymino.desktop.in

# DBus service file
servicedir = $(datadir)/dbus-1/services
service_DATA = org.el.polymino.service
dist_noinst_DATA += org.el.polymino.service.in

org.el.polymino.service: org.el.polymino.service.in Makefile
	$(AM_V_GEN) sed -e "s|\@bindir\@|$(bindir)|" $< > $@

gsettingsschema_in_files = org.el.polymino.gschema.xml.in
gsettings_SCHEMAS = $(gsettingsschema_in_files:.xml.in=.xml)
.PRECIOUS: $(gsettings_SCHEMAS)

@INTLTOOL_XML_RULE@
@GSETTINGS_RULES@

CLEANFILES = \
	$(applications_DATA) \
	$(service_DATA) \
	$(NULL)

DISTCLEANFILES = \
	$(gsettings_SCHEMAS) \
	$(NULL)

MAINTAINERCLEANFILES = \
	$(gsettings_SCHEMAS:.xml=.valid) \
	$(NULL)

EXTRA_DIST = \
	polymino.gresource.xml \
	org.el.polymino.gschema.xml.in.in \
	$(NULL)

-include $(top_srcdir)/git.mk
