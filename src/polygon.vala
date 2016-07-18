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

public class Polygon: Track
{
    public Polygon()
    {
        fill_center = false;
        breakable = true;
        fill_color = Gdk.RGBA();
        fill_color.parse("rgba(255, 255, 0, 0.9)");
    }

    public bool fill_center { get; set; }
    public bool breakable { get; set; }
    public Gdk.RGBA fill_color { get; set; }
}

}
