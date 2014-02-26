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
	class Frame : Gtk.DrawingArea {
		private int frame_width;
		private int frame_height;

		private El.Point cur_point;

		private double ratio;

		private double square_width;
		private double square_height;

		private uint timeout_id;
		private int timeout;

		private bool is_started;
		private bool is_paused;

		private El.Shape cur_shape;
		private El.Shape next_shape;

		private El.Color background;
        private El.Color grid_line;

		private Gee.LinkedList<Gee.LinkedList<int>> frame;
		
		construct {
			this.expand = true;
			this.can_focus = true;
	
			this.add_events( Gdk.EventMask.KEY_PRESS_MASK );
			
			this.frame_height = 22;
			this.frame_width = 10;
			this.ratio = (double)this.frame_height / (double)this.frame_width;
			
			this.is_started = false;
			this.is_paused = false;
			
			this.timeout_id = 0;
			this.timeout = 500;
			
			El.PieceFactory.populate( );
			
			this.cur_shape = Shape( );
			this.next_shape = Shape( );
			this.next_shape.set_random( );

			this.create_frame( );

			this.background = { 0.094117647, 0.094117647, 0.094117647 };
            this.grid_line = { 0.188235294, 0.188235294, 0.188235294 };
		}

        private void create_frame( ) {
			this.frame = new Gee.LinkedList<Gee.LinkedList<int>>( );
			for( int i = 0; i < this.frame_height; i ++ ) {
				add_empty_line( );	
			}
		}

		private void add_empty_line( ) {
			Gee.LinkedList<int> list = new Gee.LinkedList<int>( );
			for( int j = 0; j < this.frame_width; j ++ )
				list.add( Shape.EMPTY );
			this.frame.insert( 0, list );
		}

		private void create_new_shape( ) {
			this.cur_shape = this.next_shape;
			this.next_shape.set_random( );

			stdout.printf( "name: %s\n", El.PieceFactory.pieces[this.cur_shape.id].name );

			this.cur_point.x = ( this.frame_width - this.cur_shape.max.x ) / 2;
			this.cur_point.y = -this.cur_shape.min.y;

			if( !try_move( this.cur_shape, this.cur_point ) ) {
				this.cur_shape.set_shape( Shape.EMPTY );
				this.stop_timer( );
				this.is_started = false;
			}
		}

		private void draw_square( Cairo.Context cr, double x, double y, int shape_id ) {
			Color color = El.PieceFactory.pieces[shape_id].color;
			cr.set_source_rgb( color.red, color.green, color.blue );
			cr.rectangle( x + 1, y + 1, this.square_width - 2, this.square_height - 2 );
			cr.fill( );
		}

		public override bool draw( Cairo.Context cr ) {
			double aw, ah, w, h, ox, oy, x, y;

			aw = this.get_allocated_width( );
			ah = this.get_allocated_height( );
			
			w = double.min( aw, ah / this.ratio );
			h = double.min( ah, aw * this.ratio );

			ox = ( aw - w ) / 2.0;
			oy = ( ah - h ) / 2.0;
			
			this.square_width =  w / this.frame_width;
			this.square_height = h / this.frame_height;
			
			cr.set_source_rgb( this.background.red, this.background.green, this.background.blue );
			cr.rectangle( ox, oy, w, h );
			cr.fill( );

            cr.set_source_rgb( this.grid_line.red, this.grid_line.green, this.grid_line.blue );
            cr.set_line_width( 1 );
            for( int i = 1; i < frame_width; i ++ ) {
                cr.move_to( ox + i * square_width, oy );
                cr.line_to( ox + i * square_width, oy + h );
            }
            for( int i = 1; i < frame_height; i ++ ) {
                cr.move_to( ox, oy + i * square_height );
                cr.line_to( ox + w, oy + i * square_height );
            }
            cr.stroke( );

			if( this.cur_shape.id != Shape.EMPTY ) {
				//stdout.printf( "drawing shape\n" );
				
				foreach( Point p in this.cur_shape.coordinates ) {
					x = this.cur_point.x + p.x;
					y = this.cur_point.y + p.y;

					draw_square( cr, ox + x * this.square_width,
								oy + y * this.square_height, this.cur_shape.id );
				}
			}

			Point p = Point( ) { x = 0, y = 0 };
			
			foreach( Gee.LinkedList<int> list in this.frame ) {
				p.x = 0;
				
				foreach( int id in list ) {
					if( id != Shape.EMPTY ) {
						//stdout.printf( "point %d %d %d\n", p.x, p.y, id );
						draw_square( cr, ox + p.x * this.square_width, oy + p.y * this.square_height, id );
					}
					p.x ++;
				}
				p.y ++;
			}
			
			return true;
		}

		public override bool key_press_event( Gdk.EventKey event ) {
			//stdout.printf( "%d\n", (int)event.keyval );

			if( this.cur_shape.id == Shape.EMPTY ) return true;
			
			if( event.keyval == Gdk.Key.Up ) {
				Shape shape = this.cur_shape;
				shape.rotate_right( );
				try_move( shape, this.cur_point );
			} else if( event.keyval == Gdk.Key.Down ) {
				Shape shape = this.cur_shape;
				shape.rotate_left( );
				try_move( shape, this.cur_point );
			} else if( event.keyval == Gdk.Key.Left ) {
				try_move( this.cur_shape, Point( ) { x = this.cur_point.x - 1, y = this.cur_point.y } );
			} else if( event.keyval == Gdk.Key.Right ) {
				try_move( this.cur_shape, Point( ) { x = this.cur_point.x + 1, y = this.cur_point.y } );
			} else if( event.keyval == Gdk.Key.space ) {
				fall_down( );
			} else if (event.keyval == Gdk.Key.d ) {
				one_line_down( );
			}
						
			return true;
		}
		
		private void stop_timer( ) {
			if( this.timeout_id != 0 )
				GLib.Source.remove( this.timeout_id );
			this.timeout_id = 0;
		}
 
		private void start_timer( ) {
			this.stop_timer( );

			this.timeout_id = GLib.Timeout.add( this.timeout, this.timeout_cb );
		}

		private bool timeout_cb( ) {
			//stdout.printf( "ticking..\n" );
			one_line_down( );
			return true;
		}

		private void one_line_down( ) {
			if( !try_move( this.cur_shape, Point( ) { x = this.cur_point.x, y = this.cur_point.y + 1 } ) )
				update_frame( );
		}

		private void fall_down( ) {
			while( try_move( this.cur_shape, Point( ) { x = this.cur_point.x, y = this.cur_point.y + 1 } ) ); 
			update_frame( );
		}

		private void update_frame( ) {
			Point point = Point( );
			foreach( Point p in this.cur_shape.coordinates ) {
				point.x = this.cur_point.x + p.x;
				point.y = this.cur_point.y + p.y;
				
				this.set_shape_at( this.cur_shape.id, point );
			}

			remove_full_lines( );
				
			create_new_shape( );
		}

		private void remove_full_lines( ) {
			foreach( Gee.LinkedList<int> line in this.frame ) {
				if( !(Shape.EMPTY in line) ) {
					stdout.printf( "line is full\n" );
					this.frame.remove( line );

					add_empty_line( );
				}
			}
		}

		private bool try_move( Shape new_shape, Point new_point ) {
			Point p = { 0, 0 };
			
			foreach( Point point in new_shape.coordinates ) {
				p.x = new_point.x + point.x;
				p.y = new_point.y + point.y;

				if( p.x < 0 || p.x >= this.frame_width ||
					p.y < 0 || p.y >= this.frame_height )
					return false;
				
				if( this.get_shape_at( p ) != Shape.EMPTY )
					return false;
			}

			this.cur_shape = new_shape;
			this.cur_point = new_point;
			this.queue_draw( );
			
			return true;
		}

		private int get_shape_at( Point p ) {
			return this.frame[p.y][p.x];
		}

		private void set_shape_at( int id, Point p ) {
			this.frame[p.y][p.x] = id;
		}

		private void clear_frame( ) {
			Point p = { 0, 0 };
			
			for( p.x = 0; p.x < this.frame_width; p.x ++ )
				for( p.y = 0; p.y < this.frame_height; p.y ++ )
					this.set_shape_at( Shape.EMPTY, p );
		}

		public void new_game_cb( ) {
			if( this.is_paused )
				return;
			
			this.is_started = true;

			//create_frame( );
			clear_frame( );
			create_new_shape( );
			start_timer( );
		}

		public void pause_cb( ) {
			this.is_paused = !this.is_paused;

			if( this.is_paused )
				this.stop_timer( );
			else
				this.start_timer( );
		}
	}
}
