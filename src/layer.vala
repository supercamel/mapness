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
 * Layers are used to draw your own stuff over the top of the map.
 * This is a base class.
 * To implement your own layer, you should create a class that inherits Layer
 * and implements all these functions.
 * Look at 'controls.vala' for an example - the zoom control is just a layer.
 */

public interface Layer: Object
{
    /**
     * Override this function to draw onto the Cairo.Context.
     * width and height are the dimensions of the actual map widget.
     */
    public abstract void draw(Cairo.Context cr, int width, int height);

    /**
     * Override this to receive click events (mouse down).
     * Return true to prevent subsequent layers from receiving click events.
     */
    public abstract bool on_click(Gdk.EventButton e);

    /**
     * Override this to receive mouse motion events.
     * Return true to prevent subsequent layers from receiving these events.
     */
    public abstract bool on_motion(Gdk.EventMotion e);

}

}
