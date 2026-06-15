using Gtk;
using mapness;

public class Demo : Gtk.Application
{
    public Demo()
    {
        Object(application_id: "org.mapness.ValaExample");
    }

    protected override void activate()
    {
        var window = new Gtk.ApplicationWindow(this);
        window.set_title("Mapness Vala");
        window.set_default_size(800, 600);

        var map = new mapness.Map();
        map.set_map_source(mapness.MapSource.OPENSTREETMAP);

        var melbourne = new mapness.Point.degrees(-37.8136, 144.9631);
        map.set_center_and_zoom(melbourne, 8);

        window.set_child(map);
        window.present();
    }
}

public int main(string[] args)
{
    return new Demo().run(args);
}
