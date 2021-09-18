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
 * mapness can download tiles from a variety of sources.
 */

public enum MapSource
{
    OPENSTREETMAP,
    GOOGLESTREET,
    GOOGLESATELLITE,
    GOOGLEHYBRID,
    OSM_CUSTOM;

    /**
     * Returns a nice, readable name for the map source.
     */
    public string to_string()
    {
        switch(this) {
            case OPENSTREETMAP:
                return "Open Street Map";
            case GOOGLESTREET:
                return "Google Street";
            case GOOGLESATELLITE:
                return "Google Satellite";
            case GOOGLEHYBRID:
                return "Google Hybrid";
            case OSM_CUSTOM:
                return "OSM Custom";
        }
        return "";
    }
}

public class Source
{
    public MapSource map_source;

    public string custom_uri;

    public string to_string()
    {
        return map_source.to_string();
    }

    /**
     * Returns the base URI of the map source.
     * Mapness uses this value to determine the actual URI for each tile.
     */
    public string get_uri()
    {
        switch(map_source) {
            case MapSource.OPENSTREETMAP:
                return "http://tile.OPENSTREETMAP.org/#Z/#X/#Y.png";
            case MapSource.GOOGLESTREET:
                return "http://mt#R.google.com/vt/lyrs=m&hl=en&x=#X&s=&y=#Y&z=#Z";
            case MapSource.GOOGLESATELLITE:
                return "http://mt#R.google.com/vt/lyrs=s&hl=en&x=#X&s=&y=#Y&z=#Z";
            case MapSource.GOOGLEHYBRID:
                return "http://mt#R.google.com/vt/lyrs=y&hl=en&x=#X&s=&y=#Y&z=#Z";
            case MapSource.OSM_CUSTOM:
                return custom_uri + "/#Z/#X/#Y.png";
        }
        return "";
    }

    /**
     * Returns the image format of the tiles from this map source.
     * This is probably 'png' or 'jpg'
     */
    public string get_format()
    {
        if((map_source == MapSource.OPENSTREETMAP) || (map_source == MapSource.OSM_CUSTOM)) 
            return "png";
        return "jpg";
    }

    public int get_min_zoom()
    {
        return 1;
    }

    public int get_max_zoom()
    {
        return 17;
    }
}

private struct UriFormat
{
    UriFormat()
    {
        has_x = false;
        has_y = false;
        has_z = false;
        has_s = false;
        has_q = false;
        has_q0 = false;
        has_ys = false;
        has_r = false;
        is_google = false;
    }
    public bool has_x;
    public bool has_y;
    public bool has_z;
    public bool has_s;
    public bool has_q;
    public bool has_q0;
    public bool has_ys;
    public bool has_r;
    public bool is_google;
}

private const string URI_MARKER_X = "#X";
private const string URI_MARKER_Y = "#Y";
private const string URI_MARKER_Z = "#Z";
private const string URI_MARKER_S = "#S";
private const string URI_MARKER_Q = "#Q";
private const string URI_MARKER_Q0 = "#W";
private const string URI_MARKER_YS = "#U";
private const string URI_MARKER_R = "#R";


private UriFormat get_uri_format(string uri)
{
    var ret = UriFormat();
    if(uri.last_index_of(URI_MARKER_X) >= 0)
        ret.has_x = true;
    if(uri.last_index_of(URI_MARKER_Y) >= 0)
        ret.has_y = true;
    if(uri.last_index_of(URI_MARKER_Z) >= 0)
        ret.has_z = true;
    if(uri.last_index_of(URI_MARKER_S) >= 0)
        ret.has_s = true;
    if(uri.last_index_of(URI_MARKER_Q) >= 0)
        ret.has_q = true;
    if(uri.last_index_of(URI_MARKER_Q0) >= 0)
        ret.has_q0 = true;
    if(uri.last_index_of(URI_MARKER_YS) >= 0)
        ret.has_ys = true;
    if(uri.last_index_of(URI_MARKER_R) >= 0)
        ret.has_r = true;
    if(uri.last_index_of("google.com") >= 0)
        ret.is_google = true;

    return ret;
}

}
