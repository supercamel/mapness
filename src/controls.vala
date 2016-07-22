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

private class ZoomControl: Object, Layer
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

    public ZoomControl()
    {
        shade_mul = 0.2;
    }

    public void draw(Cairo.Context cr, int width, int height)
    {
        int x_pos = width-70;
        int y_pos = height-100;
        int ctrl_width = 40;
        int ctrl_height = 80;

        cr.set_source_rgba(shade_mul, shade_mul, shade_mul, 1.0);
        cr.set_line_width(2.0);
        rounded_box(cr, x_pos, y_pos, ctrl_width, ctrl_height, 3);

        var pattern = new Cairo.Pattern.linear(x_pos, y_pos, x_pos+80, y_pos+100);

        pattern.add_color_stop_rgba(0.0, 1.0, 1.0, 1.0, 0.2);
        pattern.add_color_stop_rgba(0.5, 0.0, 0.0, 0.0, 0.2);

        cr.set_source(pattern);
        rounded_box(cr, x_pos, y_pos, ctrl_width, ctrl_height, 3);
        cr.fill();

        cr.set_source_rgba(0.0, 0.0, 0.0, 1.0);
        cr.move_to(x_pos+(ctrl_width/2), y_pos+5);
        cr.line_to(x_pos+(ctrl_width/2), y_pos+(ctrl_height/2)-5);
        cr.stroke();

        cr.move_to(x_pos+5, y_pos+(ctrl_height/4));
        cr.line_to(x_pos+ctrl_width-5, y_pos+(ctrl_height/4));
        cr.stroke();

        cr.move_to(x_pos+1, y_pos+(ctrl_height/2));
        cr.line_to(x_pos+ctrl_width-1, y_pos+(ctrl_height/2));
        cr.stroke();

        cr.move_to(x_pos+5, y_pos+(ctrl_height/2)+(ctrl_height/4));
        cr.line_to(x_pos+ctrl_width-5, y_pos+(ctrl_height/2)+(ctrl_height/4));
        cr.stroke();

        last_width = width;
        last_height = height;
    }

    public bool on_click(Gdk.EventButton e)
    {
        int x_pos = last_width-70;
        int y_pos = last_height-100;
        int ctrl_width = 40;
        int ctrl_height = 80;

        if((e.x > x_pos) && (e.x < (x_pos+ctrl_width)))
        {
            if((e.y > y_pos) && (e.y < y_pos+ctrl_height/2))
            {
                zoom_changed(1);
                return true;
            }
        }

        if((e.x > x_pos) && (e.x < (x_pos+ctrl_width)))
        {
            if((e.y > y_pos+ctrl_height/2) && (e.y < y_pos+ctrl_height))
            {
                zoom_changed(-1);
                return true;
            }
        }

        return false;
    }

    public bool on_motion(Gdk.EventMotion e)
    {
        int x_pos = last_width-70;
        int y_pos = last_height-100;
        int ctrl_width = 40;
        int ctrl_height = 80;

        double orig_shade = shade_mul;
        shade_mul = 0.2;
        if((e.x > x_pos) && (e.x < (x_pos+ctrl_width)))
        {
            if((e.y > y_pos) && (e.y < y_pos+ctrl_height))
            {
                shade_mul = 0.4;
            }
        }

        if(Math.fabs(orig_shade-shade_mul) > 0.1)
            redraw();
        return false;
    }

    public signal void zoom_changed(int change);
    public signal void redraw();


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

    private void rounded_box(Cairo.Context cr, double x, double y,
        double width, double height, double radius)
    {
        double degrees = Math.PI / 180.0;

        cr.new_sub_path();
        cr.arc(x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
        cr.arc(x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
        cr.arc(x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
        cr.arc(x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
        cr.close_path();
        cr.fill();
    }

    private int last_width;
    private int last_height;

    private double shade_mul;
}

}
