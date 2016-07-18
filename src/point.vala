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

public class Point: Object
{
    public Point.degrees(double lat, double lon)
    {
        rlat = lat * (Math.PI/180.0);
        rlon = lon * (Math.PI/180.0);
    }

    public Point.radians(double lat, double lon)
    {
        rlat = lat;
        rlon = lon;
    }

    public void set_degrees(double lat, double lon)
    {
        rlat = lat * (Math.PI/180.0);
        rlon = lon * (Math.PI/180.0);
    }

    public void get_degrees(out double lat, out double lon)
    {
        lat = rlat * (180.0/Math.PI);
        lon = rlon * (180.0/Math.PI);
    }

    public double get_lat()
    {
        return rlat * (180.0/Math.PI);
    }

    public double get_lon()
    {
        return rlon * (180.0/Math.PI);
    }

    public double rlat { get; set; }
    public double rlon { get; set; }

}


}
