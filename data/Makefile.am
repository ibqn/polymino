
gsettingsschema_in_files = org.el.polymino.gschema.xml.in
gsettings_SCHEMAS = $(gsettingsschema_in_files:.xml.in=.xml)
.PRECIOUS: $(gsettings_SCHEMAS)

@INTLTOOL_XML_RULE@

@GSETTINGS_RULES@


EXTRA_DIST = \
        polymino.gresource.xml \
	 polymino.glade

-include $(top_srcdir)/git.mk
