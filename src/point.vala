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

using Gee;

namespace mapness
{

/**
 * Points are used to specify a location.
 *
 * Like tracks, they can have user-defined properties added to them
 */
public class Point: Object
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

    public Point()
    {
        rlat = 0;
        rlon = 0;
        map = new HashMap<string, Value?>();
    }

/**
 * Creates a new point that is initialised to a lat/lon in degrees.
 */
    public Point.degrees(double lat, double lon)
    {
        map = new HashMap<string, Value?>();

        rlat = lat * (Math.PI/180.0);
        rlon = lon * (Math.PI/180.0);
    }

/**
 * Creates a new point that is initialised to a lat/lon in radians.
 */
    public Point.radians(double lat, double lon)
    {
        map = new HashMap<string, Value?>();

        rlat = lat;
        rlon = lon;
    }

/**
 * Sets the location of the point in degrees.
 */
    public void set_degrees(double lat, double lon)
    {
        rlat = lat * (Math.PI/180.0);
        rlon = lon * (Math.PI/180.0);
    }

/**
 * Gets the location of the point in degrees.
 */
    public void get_degrees(out double lat, out double lon)
    {
        lat = rlat * (180.0/Math.PI);
        lon = rlon * (180.0/Math.PI);
    }

/**
 * Returns latitude of point in degrees.
 */
    public double get_lat()
    {
        return rlat * (180.0/Math.PI);
    }

/**
 * Returns longitude of point in degrees.
 */
    public double get_lon()
    {
        return rlon * (180.0/Math.PI);
    }

/**
 * Latitude in radians.
 */
    public double rlat { get; set; }

/**
 * Longitude in radians.
 */
    public double rlon { get; set; }

/**
 * Adds a generic key/value to the point
 */
    public void set_property(string name, Value? v) 
    {
        map.set(name, v);
    }

/**
 * true if the point has a property of this name
 */
    public bool has_property(string name) 
    {
        return name in map;
    }

/**
 * Gets a value by key
 */
    public Value? get_property(string name)
    {
        return map.get(name);
    }

/**
 * Removes a property
 */
    public void remove_property(string name) 
    {
        if(name in map)
        {
            map.unset(name);
        }
    }



/******************************************************************************
*******************************************************************************
________  ________  ___  ___      ___ ________  _________  _______
|\   __  \|\   __  \|\  \|\  \    /  /|\   __  \|\___   ___\\  ___ \
\ \  \|\  \ \  \|\  \ \  \ \  \  /  / | \  \|\  \|___ \  \_\ \   __/|
\ \   ____\ \   _  _\ \  \ \  \/  / / \ \   __  \   \ \  \ \ \  \_|/__
 \ \  \___|\ \  \\  \\ \  \ \    / /   \ \  \ \  \   \ \  \ \ \  \_|\ \
  \ \__\    \ \__\\ _\\ \__\ \__/ /     \ \__\ \__\   \ \__\ \ \_______\
   \|__|     \|__|\|__|\|__|\|__|/       \|__|\|__|    \|__|  \|_______|

*******************************************************************************
******************************************************************************/


    private HashMap<string, Value?> map;


}


}
