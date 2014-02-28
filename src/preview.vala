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
    class Preview : Gtk.DrawingArea {
        private El.Frame frame;
        private El.Point point;
        private int shape_id;
        private El.Shape shape;

        private double square_width;
        private double square_height;
        private double frame_width;
        private double frame_height;
        private int width;
        private int height;

        construct {
            frame_width = 100.0;
            frame_height = 80.0;

            set_size_request( (int)frame_width, (int)frame_height );

            width = 5;
            height = 4;

            square_width = square_height = 20;

            shape_id = El.Shape.EMPTY;
            shape = Shape( );
        }

        public void set_frame( El.Frame frame ) {
            this.frame = frame;

            this.frame.new_shape.connect(( id ) => {
                shape_id = id;

                shape.set_shape( shape_id );

                point.x = ( width - shape.max.x ) / 2;
                point.y = ( height - shape.max.y ) / 2;

                queue_draw ();
            });
        }

        private void draw_square( Cairo.Context cr, double x, double y, int shape_id ) {
            Color color = El.PieceFactory.pieces[shape_id].color;
            cr.set_source_rgb( color.red, color.green, color.blue );
            cr.rectangle( x + 1, y + 1, square_width - 2, square_height - 2 );
            cr.fill( );
        }

        public override bool draw( Cairo.Context cr ) {
            cr.set_source_rgb( 0.094117647, 0.094117647, 0.094117647 );
            cr.rectangle( 0.0, 0.0, frame_width, frame_height );
            cr.fill( );

            cr.set_source_rgb( 0.188235294, 0.188235294, 0.188235294 );
            cr.set_line_width( 1 );
            for( int i = 1; i < frame_width; i ++ ) {
                cr.move_to( i * square_width, 0.0 );
                cr.line_to( i * square_width, frame_height );
            }
            for( int i = 1; i < frame_height; i ++ ) {
                cr.move_to( 0.0, i * square_height );
                cr.line_to( frame_width, i * square_height );
            }
            cr.stroke( );

            double x, y;
            if( shape_id != El.Shape.EMPTY ) {
                foreach( var p in shape.coordinates ) {
                    x = point.x + p.x;
                    y = point.y + p.y;

                    draw_square( cr, x * square_width, y * square_height, shape_id );
                }
            }

            return true;
        }
    }
}
