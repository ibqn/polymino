 /*
  * Copyright (c) 2014 Evgeny Bobkin <evgen.ibqn@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 of the License, or (at your
  * option) any later version.
  *
  * This program is distributed in the hope that it will be useful, but
  * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
  * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
  * for more details.
  *
  * You should have received a copy of the GNU General Public License along
  * with this program; if not, write to the Free Software Foundation,
  * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */

namespace El {
    public class Application : Gtk.Application {
        private const OptionEntry[] option_entries = {
            { "version", 'v', 0, OptionArg.NONE, null, N_( "Print version information and exit" ), null },
            { null },
        };

        private Window? window;

        public Application( ) {
            Object( application_id: "org.el.polymino" );

            add_main_option_entries( option_entries );

            window = null;
        }

        protected override void activate( ) {
            if( window == null ) {
                window = new Window( this );
            }
            window.present( );
        }

        protected override void startup( ) {
            base.startup( );
            
            var settings = Gtk.Settings.get_default( );
            settings.gtk_application_prefer_dark_theme = true;

            try {
                var builder = new Gtk.Builder.from_resource( "/org/el/polymino/ui/menu.ui" );
                var app_menu = builder.get_object( "appmenu" ) as GLib.MenuModel;
                set_app_menu( app_menu );
            } catch( Error e ) {
                warning( "loading app menu: %s", e.message );
            }

            try {
                var css_provider = new Gtk.CssProvider( );
                var file = File.new_for_uri( "resource:///org/el/polymino/css/styles.css" );
                css_provider.load_from_file( file );

                Gtk.StyleContext.add_provider_for_screen( Gdk.Screen.get_default( ),
                                                          css_provider,
                                                          Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION );
            } catch( Error e ) {
                warning( "loading css: %s", e.message );
            }
        }

        protected override int handle_local_options( GLib.VariantDict options ) {
            if( options.contains( "version" ) ) {
                print( "%s %s\n", Environment.get_application_name( ), Config.PACKAGE_VERSION );
                return 0;
            }

            return -1;
        }
    }
}
