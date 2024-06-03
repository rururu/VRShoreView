import solara
from solara.website.pages.examples.utilities import calculator
import ipyleaflet
import time

maps = {
    "OpenStreetMap.Mapnik": ipyleaflet.basemaps.OpenStreetMap.Mapnik,
    "OpenTopoMap": ipyleaflet.basemaps.OpenTopoMap,
    "Esri.WorldTopoMap": ipyleaflet.basemaps.Esri.WorldTopoMap,
    "Stamen.Watercolor": ipyleaflet.basemaps.Stamen.Watercolor,
}
map_name = solara.reactive(list(maps)[0])

zoom = solara.reactive(12)
center = solara.reactive((60.0, 30.0))
marker_location = solara.reactive((60.0, 30.0))

def go():
    cnt = 0
    lat = 60.0
    lon = 30.0
    while cnt < 400:
        marker_location.set([lat, lon])
        lat = lat + 0.00002
        lon = lon + 0.0001
        cnt = cnt + 1
        time.sleep(0.01)
    while cnt < 800:
        marker_location.set([lat, lon])
        lat = lat - 0.00002
        lon = lon - 0.0001
        cnt = cnt + 1
        time.sleep(0.01)
        
@solara.component
def Home():
    solara.Markdown("Home")

@solara.component
def Chart():
    def location_changed(location):
        # do things with the location
        marker_location.set(location)

    with solara.Column(style={"min-width": "500px", "height": "500px"}):
        map = maps[map_name.value]
        url = map.build_url()
        # solara components support reactive variables
        solara.Select(label="Map", value=map_name, values=list(maps), style={"z-index": "10000"})
        solara.SliderInt(label="Zoom level", value=zoom, min=1, max=20)
        # using 3rd party widget library require wiring up the events manually
        # using zoom.value and zoom.set
        ipyleaflet.Map.element(  # type: ignore
            zoom=zoom.value,
            on_zoom=zoom.set,
            center=center.value,
            on_center=center.set,
            scroll_wheel_zoom=True,
            layers=[
                ipyleaflet.TileLayer.element(url=url),
                ipyleaflet.Marker.element(location=marker_location.value, draggable=True, on_location=location_changed),
            ],
        )
        solara.Text(f"Zoom: {zoom.value}")
        solara.Text(f"Center: {center.value}")
        solara.Button(label="go", on_click=go)
        
routes = [
    solara.Route(path="/", component=Home, label="Home"),
    # the calculator module should have a Page component
    solara.Route(path="calculator", module=calculator, label="Calculator"),
    solara.Route(path="chart", component=Chart, label="Chart"),
]

