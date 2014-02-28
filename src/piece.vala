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
	public class PieceFactory : Object {
		public static Gee.ArrayList<Piece> pieces;
		public static int size {
			get {
				return pieces.size;
			}
		}

		/* private constructor */
		private PieceFactory( ) { }
		
		public static void populate( ) {
			pieces = new Gee.ArrayList<Piece>( );
			
			/* Z Shape */
			var zshape = new Gee.ArrayList<Point?>( );
			zshape.add( {0, -1} );
			zshape.add( {0, 0} );
			zshape.add( {-1, 0} );
			zshape.add( {-1, 1} );
			
			/*
			stdout.printf("zshape size: %d\n", zshape.size );
			foreach( Point p in zshape ) 
				stdout.printf( "{%d| %d}\n", p.x, p.y );
			*/
			
			Piece zpiece = new Piece( );
			zpiece.coordinates.add( zshape );
			zpiece.name = "Z Shape";
			zpiece.color = { 0.8, 0.6, 0.6 };
			pieces.add( zpiece );

            /* S Shape */
			var sshape = new Gee.ArrayList<Point?>( );
			sshape.add( {0, -1} );
			sshape.add( {0, 0} );
			sshape.add( {1, 0} );
			sshape.add( {1, 1} );
			
			Piece spiece = new Piece( );
			spiece.coordinates.add( sshape );
			spiece.name = "S Shape";
			spiece.color = { 0.6, 0.8, 0.6 };
			pieces.add( spiece );

			/* I Shape */
			var ishape = new Gee.ArrayList<Point?>( );
			ishape.add( {0, -1} );
			ishape.add( {0, 0} );
			ishape.add( {0, 1} );
			ishape.add( {0, 2} );
			
			Piece ipiece = new Piece( );
			ipiece.coordinates.add( ishape );
			ipiece.name = "I Shape";
			ipiece.color = { 0.6, 0.6, 0.8 };
			pieces.add( ipiece );

			/* T Shape */
			var tshape = new Gee.ArrayList<Point?>( );
			tshape.add( {-1, 0} );
			tshape.add( {0, 0} );
			tshape.add( {1, 0} );
			tshape.add( {0, -1} );
			
			Piece tpiece = new Piece( );
			tpiece.coordinates.add( tshape );
			tpiece.name = "T Shape";
			tpiece.color = { 0.8, 0.8, 0.6 };
			pieces.add( tpiece );

			/* O Shape */
			var oshape = new Gee.ArrayList<Point?>( );
			oshape.add( {0, 1} );
			oshape.add( {0, 0} );
			oshape.add( {1, 0} );
			oshape.add( {1, 1} );
			
			Piece opiece = new Piece( );
			opiece.coordinates.add( oshape );
			opiece.name = "O Shape";
			opiece.color = { 0.8, 0.6, 0.8 };
			pieces.add( opiece );

			/* L Shape */
			var lshape = new Gee.ArrayList<Point?>( );
			lshape.add( {1, 1} );
			lshape.add( {0, -1} );
			lshape.add( {0, 0} );
			lshape.add( {0, 1} );
			
			Piece lpiece = new Piece( );
			lpiece.coordinates.add( lshape );
			lpiece.name = "L Shape";
			lpiece.color = { 0.6, 0.8, 0.8 };
			pieces.add( lpiece );

			/* J Shape */
			var jshape = new Gee.ArrayList<Point?>( );
			jshape.add( {-1, 1} );
			jshape.add( {0, -1} );
			jshape.add( {0, 0} );
			jshape.add( {0, 1} );
			
			Piece jpiece = new Piece( );
			jpiece.coordinates.add( jshape );
			jpiece.name = "J Shape";
			jpiece.color = { 0.8549, 0.6666, 0.0 };
			pieces.add( jpiece );

			for( int rotation = 0; rotation < 3; rotation ++ ) {
				foreach( Piece piece in pieces ) {
					var shape = new Gee.ArrayList<Point?>( );
					
					foreach( Point point in piece.coordinates[rotation] )
						shape.add( rotate_left( point ) );
				
					piece.coordinates.add( shape );
				}
			}
			
			/*
			stdout.printf( "number of rotations %d\n",
						   zpiece.coordinates.size );
			
			foreach( Point p in zpiece.coordinates[3] ) 
				stdout.printf( "{%d| %d}\n", p.x, p.y );
			*/
			
			fill_min_max( );
		}

		private static Point rotate_left( Point point ) {
			return Point( ) {
				x =  point.y,
				y = -point.x
			};
		}
		
		private static void fill_min_max( ) {
			foreach( Piece piece in pieces ) {
				foreach( var rotation_points in piece.coordinates ) {
					Point max = rotation_points[0];
					Point min = rotation_points[0];
					foreach( Point point in rotation_points ) {
						max.x = int.max( point.x, max.x );
						max.y = int.max( point.y, max.y );
						
						min.x = int.min( point.x, min.x );
						min.y = int.min( point.y, min.y );
					}
					piece.max.add( max );
					piece.min.add( min );
				}
			}
		}
	}
	
	public class Piece : Object {
		public string name;
		public Color color;
		public Gee.ArrayList<Gee.ArrayList<Point?>> coordinates;
		public Gee.ArrayList<Point?> max;
		public Gee.ArrayList<Point?> min;
		
		public Piece( ) {
			this.coordinates = new Gee.ArrayList<Gee.ArrayList<Point?>>( );
			this.max = new Gee.ArrayList<Point?>( );
			this.min = new Gee.ArrayList<Point?>( );
		}
	}

	public struct Color {
		public double red;
		public double green;
		public double blue;
		
		/*
		public Color( double red, double green, double blue ) {
			this.red = red;
			this.green = green;
			this.blue = blue;
		}
		*/
	}
	
	public struct Point {
		public int x;
		public int y;

		public Point copy_inc_y( ) {
		    return Point( ) { x = this.x, y = this.y + 1 };
		}

		public Point copy_inc_x( ) {
		    return Point( ) { x = this.x + 1, y = this.y };
		}

		public Point copy_dec_x( ) {
		    return Point( ) { x = this.x - 1, y = this.y };
		}
	}
	
	public struct Shape {
		public int id;
		public int rotation;
		public Gee.ArrayList<Point?> coordinates;
		public Point max;
		public Point min;
		
		public static const int EMPTY = -1;
		
		public Shape( ) {
			this.id = Shape.EMPTY;
			this.rotation = 0;
		}

		public void set_shape( int id ) {
			assert( -2 < id < El.PieceFactory.size );
			
			this.id = id;
			if( this.id == -1 ) return;
			/*this.coordinates = El.PieceFactory.pieces[this.id].coordinates[this.rotation];*/
			update_points( );
		}

		public void set_random( ) {
			set_shape( Random.int_range( 0, El.PieceFactory.size ) );
		}

		public string get_name( ) {
			if( this.id == -1 ) return "empty";
			return El.PieceFactory.pieces[this.id].name;
		}

		public void rotate_left( ) {
			if( this.id == -1 ) return;
			this.rotation = (this.rotation + 1) % 4;
			this.coordinates = El.PieceFactory.pieces[this.id].coordinates[this.rotation];
		}

		public void rotate_right( ) {
			if( this.id == -1 ) return;
			
			this.rotation = (this.rotation + 3) % 4;
			stdout.printf( "rot %d\n", this.rotation );
			this.coordinates = El.PieceFactory.pieces[this.id].coordinates[this.rotation];
		}

		public void set_rotation( int rotation ) {
			assert( -1 < rotation < 4 );
			
			this.rotation = rotation;
			this.coordinates = El.PieceFactory.pieces[this.id].coordinates[this.rotation];
		}
		
		private void update_points( ) {
			this.coordinates = El.PieceFactory.pieces[this.id].coordinates[this.rotation];
			this.max = El.PieceFactory.pieces[this.id].max[this.rotation];
			this.min = El.PieceFactory.pieces[this.id].min[this.rotation];
		}
	}
}
