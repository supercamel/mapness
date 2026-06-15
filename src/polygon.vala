/*
    Copyright (C) 2021 Samuel Cowen <samuel.cowen@camelsoftware.com>

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
 * A polygon is a special type of track with the first and last points of the track are
 * joined together.
 * Polygons can also be filled with a colour.
 */

public class Polygon: Track
{
    /**************************************************************************
    ***************************************************************************
    ________  ___  ___  ________  ___       ___  ________
    |\   __  \|\  \|\  \|\   __  \|\  \     |\  \|\   ____\
    \ \  \|\  \ \  \\\  \ \  \|\ /\ \  \    \ \  \ \  \___|
    \ \   ____\ \  \\\  \ \   __  \ \  \    \ \  \ \  \
     \ \  \___|\ \  \\\  \ \  \|\  \ \  \____\ \  \ \  \____
      \ \__\    \ \_______\ \_______\ \_______\ \__\ \_______\
       \|__|     \|_______|\|_______|\|_______|\|__|\|_______|

    ***************************************************************************
    **************************************************************************/

    public Polygon()
    {
        fill_center = false;
        fill_color = Gdk.RGBA();
        fill_color.alpha = 1.0f;
    }

    /**
     * Sets the color & alpha of the fill area.
     * Values should be between 0.0 and 1.0. For alpha, 1.0 is solid
     * and 0.0 is transparent.
     */
    public void set_fill_color(double r, double g, double b, double a)
    {
        fill_color.red = (float)r;
        fill_color.green = (float)g;
        fill_color.blue = (float)b;
        fill_color.alpha = (float)a;
    }

    /**
     * Gets the RGBA values for the fill area.
     */
    public void get_fill_color(out double r, out double g, out double b, out double a)
    {
        r = fill_color.red;
        g = fill_color.green;
        b = fill_color.blue;
        a = fill_color.alpha;
    }

    /**
     * If true, the center of the polygon will be filled with the fill_color.
     */
    public bool fill_center { get; set; }

    /**
     * The fill colour. Default colour is yellow with a hint of transparency.
     */
    private Gdk.RGBA fill_color;
}

}
