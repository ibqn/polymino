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
    [GtkTemplate (ui = "/org/el/polymino/ui/window.ui")]
    public class Window : Gtk.ApplicationWindow {
        [GtkChild]
        private El.Frame frame;
        private GLib.Settings settings;
        private const GLib.ActionEntry[] action_entries = {
            { "new-game", new_game_callback },
        };

        public Window( Application app ) {
            Object( application: app );

            add_action_entries( action_entries, this );

            settings = new Settings( "org.el.polymino.state.window" );
            settings.delay( );

            destroy.connect( () => { settings.apply( ); } );

            // Setup window geometry saving
            Gdk.WindowState window_state = (Gdk.WindowState)settings.get_int( "state" );
            if( Gdk.WindowState.MAXIMIZED in window_state ) {
                maximize( );
            }

            int width, height;
            settings.get( "size", "(ii)", out width, out height );
            resize( width, height );

            int position_type = settings.get_enum( "position-type" );
            switch( position_type ) {
            case 0:
                // leave position set up for the window manager
                break;
            case 1:
                set_position( Gtk.WindowPosition.CENTER );
                break;
            case 2:
                int pos_x, pos_y;
                settings.get( "position", "(ii)", out pos_x, out pos_y );
                if( pos_x > 0 && pos_y > 0 ) {
                    move( pos_x, pos_y );
                }
                break;
            default:
                assert_not_reached( );
                break;
            };

            new_game_callback( );
        }

        private void new_game_callback( ) {
            frame.new_game_cb( );
        }

        protected override bool window_state_event( Gdk.EventWindowState event ) {
            settings.set_int( "state", event.new_window_state );
            return base.window_state_event( event );
        }

        protected override bool configure_event( Gdk.EventConfigure event ) {
            if( get_realized( ) && !(Gdk.WindowState.MAXIMIZED in get_window( ).get_state( ) ) ) {
                settings.set( "size", "(ii)", event.width, event.height );
                settings.set( "position", "(ii)", event.x, event.y );
            }

            return base.configure_event( event );
        }
    }
}

