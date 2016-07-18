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

using Gtk;

namespace mapness
{

public class Track: Object
{
    public Track()
    {
        points = new GLib.SList<Point>();
        color = Gdk.RGBA();
        color.alpha = 1.0;
        editable = false;
        line_width = 2;
    }

    public void add_point(Point p)
    {
        points.append(p);
        point_added();
    }

    public void remove_point(uint pos)
    {
        var p = points.nth_data(pos);
        points.remove(p);
        point_removed(pos);
    }

    public uint n_points()
    {
        return points.length();
    }

    public void insert_point(Point p, int pos)
    {
        points.insert(p, pos);
        point_inserted();
    }

    public Point get_point(uint pos)
    {
        return points.nth_data(pos);
    }

    public double get_length()
    {
        double ret = 0;

        if(n_points() < 2)
            return ret;


        uint count = 0;
        var point_b = new Point.degrees(0, 0);
        var point_a = new Point.degrees(0, 0);

        foreach(var p in points)
        {
            point_a = point_b;
            point_b = p;

            if(count >= 1)
            {
                ret += Math.acos(Math.sin(point_a.rlat)*Math.sin(point_b.rlat)
                    + Math.cos(point_a.rlat)*Math.cos(point_b.rlat)*Math.cos(point_b.rlon-point_a.rlon)) * 6371109; //the mean raduis of earth
            }
            count++;
        }

        return ret;
    }

    public void set_rgba(double r, double g, double b, double a)
    {
        color.red = r;
        color.blue = b;
        color.green = g;
        color.alpha = a;
    }

    public signal void point_added();
    public signal void point_inserted();
    public signal void point_removed(uint pos);
    public signal void point_changed(Point pt);

    public GLib.SList<Point> points;
    public Gdk.RGBA color { get; set; }

    public bool editable { get; set; }

    public uint line_width { get; set; }
}

}
