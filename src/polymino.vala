namespace El {
	public class Polymino {
		private Frame frame;
		public Polymino( ) {
			this.frame = new Frame( );
		
            Gtk.Builder builder = new Gtk.Builder( );

            try {
                builder.add_from_resource ("/org/polymino/".concat ("polymino.glade", null));
            } catch( Error e ) {
                error ("loading main builder file: %s", e.message);
            }
                
            builder.connect_signals( this );
				
            Gtk.Grid grid = builder.get_object( "grid1" ) as Gtk.Grid;
            grid.attach( frame, 0, 2, 1, 1 );
            
            this.frame.is_focus = true;
			
            Gtk.Window window = builder.get_object( "window1" ) as Gtk.Window;
            window.show_all( );				
        }

		[CCode( instance_pos=-1 )]
		public void new_game_cb( Gtk.ToolButton btn ) {
			this.frame.new_game_cb( );
		}

		[CCode( instance_pos=-1 )]
		public void pause_cb( Gtk.ToolButton btn ) {
			this.frame.pause_cb( );
		}

		public static void main( string[] args ) {
			Gtk.init( ref args );

			var p = new Polymino( );
			Gtk.main( );
		}
	}
}