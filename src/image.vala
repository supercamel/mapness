/*
    Copyright (C) 2016 Samuel Cowen <samuel.cowen@camelsoftware.com>

    This file is part of mapness.

    mapness is free software: you can redistribute it and/or modify
    it under the terms of the Lesser GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    mapness is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Lesser GNU General Public License for more details.

    You should have received a copy of the Lesser GNU General Public License
    along with mapness.  If not, see <http://www.gnu.org/licenses/>.
*/

namespace mapness
{

/**
 * Images can be displayed over points on the map.
 * If you need to display an image is fixed to a point on the screen rather
 * than a point on the map, you should use a Layer.
 */

public class Image: Object
{
    /**
     * Creates a new image from a Gdk.Pixbuf
     */
    public Image(Gdk.Pixbuf pb)
    {
        pixbuf = pb;
        width = pixbuf.get_width();
        height = pixbuf.get_height();
        point = new Point.degrees(0, 0);
    }

    /**
     * Creates a new image from a file and positions it at a point.
     */
    public Image.from_file(string path, Point pt)
    {
        pixbuf = new Gdk.Pixbuf.from_file(path);
        width = pixbuf.get_width();
        height = pixbuf.get_height();
        point = pt;
    }

    /**
     * Draws the image on to a Cairo.Context
     */
    public void draw(Cairo.Context cr, Gdk.Rectangle rect)
    {
        int x = rect.x - (width/2);
        int y = rect.y - (height/2);

        cr.translate(x+(width/2), y+(height/2));
        cr.rotate(rotation * (Math.PI/180.0));
        cr.translate(-(x+(width/2)), -(y+(height/2)));

        Gdk.cairo_set_source_pixbuf(cr, pixbuf, x, y);
        cr.paint();
        cr.translate(x+(width/2), y+(height/2));
        cr.rotate(-rotation * (Math.PI/180.0));
        cr.translate(-(x+(width/2)), -(y+(height/2)));

        rect.width = width;
        rect.height = height;
    }

    /**
     * Sets the rotation of the image in degrees.
     */
    public double rotation { get; set; }

    /**
     * The location of the image on the map.
     */
    public Point point { get; set; }


    /**************************************************************************
    ***************************************************************************
    ________  ________  ___  ___      ___ ________  _________  _______
    |\   __  \|\   __  \|\  \|\  \    /  /|\   __  \|\___   ___\\  ___ \
    \ \  \|\  \ \  \|\  \ \  \ \  \  /  / | \  \|\  \|___ \  \_\ \   __/|
    \ \   ____\ \   _  _\ \  \ \  \/  / / \ \   __  \   \ \  \ \ \  \_|/__
     \ \  \___|\ \  \\  \\ \  \ \    / /   \ \  \ \  \   \ \  \ \ \  \_|\ \
      \ \__\    \ \__\\ _\\ \__\ \__/ /     \ \__\ \__\   \ \__\ \ \_______\
       \|__|     \|__|\|__|\|__|\|__|/       \|__|\|__|    \|__|  \|_______|

    ***************************************************************************
    **************************************************************************/

    private Gdk.Pixbuf pixbuf;
    private int width;
    private int height;
}

}
