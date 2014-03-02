# DBus service file
servicedir = $(datadir)/dbus-1/services
service_DATA = org.el.polymino.service
dist_noinst_DATA = org.el.polymino.service.in

org.el.polymino.service: org.el.polymino.service.in Makefile
	$(AM_V_GEN) sed -e "s|\@bindir\@|$(bindir)|" $< > $@

gsettingsschema_in_files = org.el.polymino.gschema.xml.in
gsettings_SCHEMAS = $(gsettingsschema_in_files:.xml.in=.xml)
.PRECIOUS: $(gsettings_SCHEMAS)

@INTLTOOL_XML_RULE@
@GSETTINGS_RULES@


EXTRA_DIST = \
	polymino.gresource.xml \
	org.el.polymino.gschema.xml.in.in \
	$(NULL)

-include $(top_srcdir)/git.mk
