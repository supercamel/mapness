/*
    Copyright (C) 2016 Samuel Cowen <samuel.cowen@camelsoftware.com>

    This file is part of mapness.

    Foobar is free software: you can redistribute it and/or modify
    it under the terms of the Lesser GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Foobar is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    Lesser GNU General Public License for more details.

    You should have received a copy of the Lesser GNU General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/

namespace mapness
{

public class Layer: Object
{
    public virtual void draw(Cairo.Context cr, int width, int height)
    {

    }

    public virtual bool on_click(Gdk.EventButton e)
    {
        return false;
    }

    public virtual bool on_motion(Gdk.EventMotion e)
    {
        return false;
    }

}

}
