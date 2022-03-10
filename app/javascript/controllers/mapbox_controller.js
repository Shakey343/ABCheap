import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"


export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: 'mapbox://styles/alxtyl/cl0l3x0jt003w14qy1x5fnuoa',
      center: [-4.045050, 54.663169], // starting position
      zoom: 3 // starting zoom
    })

    if (this.element.id === "map") {
      // this.#currentLocation();
      this.#addCurrentLocationToMap();
    }

    this.#fitMapToMarker();

    if (this.element.id === "map-routes") {
      this.#addMarkersToMap();
      this.#fitMapToMarkers();
      // this.#addLineToMap();
    }
  }

  #fitMapToMarker() {
    const bounds = new mapboxgl.LngLatBounds()
    // if (this.element.id === "map-routes") {
    //   this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    //   this.map.fitBounds(bounds, { padding: 20, maxZoom: 10, duration: 0 })
    // } else {
    bounds.extend([-4.045050, 54.663169 ])
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 3.1, duration: 0 })
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      // Create a HTML element for your custom marker
      const customMarker = document.createElement("div")
      customMarker.className = "marker"
      customMarker.style.backgroundImage = `url('${marker.image_url}')`
      customMarker.style.backgroundSize = "contain"
      customMarker.style.width = "100px"
      customMarker.style.height = "50px"

      new mapboxgl.Marker(customMarker)
      .setLngLat([ marker.lng, marker.lat ])
      .addTo(this.map)
    });
  }

  #addCurrentLocationToMap() {
    const geoLocate = new mapboxgl.GeolocateControl({
      positionOptions: {
        enableHighAccuracy: true
      },
      trackUserLocation: true,
      showUserHeading: true
    })
    this.map.addControl(geoLocate)
    // console.log(geoLocate)
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 50, speed: 3000, maxZoom: 15, duration: 4000 })
  }


  // #addLineToMap() {
  //   const apiKey = "MAPBOX_API_KEY";
  //   const basemapEnum = "ArcGIS:Navigation";
  //   const map = new mapboxgl.Map({
  //     container: "map-routes", // the id of the div element
  //     style: `https://basemaps-api.arcgis.com/arcgis/rest/services/styles/${basemapEnum}?type=style&token=${apiKey}`,
  //     zoom: 12, // starting zoom

  //     center: [-4.045050, 54.663169]

  //   });

  //   function addCircleLayers() {

  //     map.addSource("start", {
  //       type: "geojson",
  //       data: {
  //         type: "FeatureCollection",
  //         features: []
  //       }
  //     });
  //     map.addSource("end", {
  //       type: "geojson",
  //       data: {
  //         type: "FeatureCollection",
  //         features: []
  //       }
  //     });
  //   }

  //   function addRouteLayer() {

  //     map.addSource("route", {
  //       type: "geojson",
  //       data: {
  //         type: "FeatureCollection",
  //         features: []
  //       }
  //     });

  //     map.addLayer({
  //       id: "route-line",
  //       type: "line",
  //       source: "route",

  //       paint: {
  //         "line-color": "hsl(205, 100%, 50%)",
  //         "line-width": 4,
  //         "line-opacity": 0.6
  //       }
  //     });

  //     function updateRoute() {

  //       const authentication = new arcgisRest.ApiKey({
  //         key: apiKey
  //       });

  //       arcgisRest
  //         .solveRoute({
  //           stops: [startCoords, endCoords],
  //           endpoint: "https://route-api.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World/solve",
  //           authentication
  //         })

  //         .then((response) => {
  //           map.getSource("route").setData(response.routes.geoJson);

  //         })

  //         .catch((error) => {
  //           console.error(error);
  //           alert("There was a problem using the route service. See the console for details.");
  //         });

  //     }

  //   }
  // }

  //"stroke:rgb(255,0,0);stroke-width:2"

  // #addLineToMap() {
  //   const origin = [this.markersValue[0].lat, this.markersValue[0].lng]
  //   const destination = [this.markersValue[1].lat, this.markersValue[1].lng]

  //   console.log(origin);
  //   console.log(destination);

  //   // const route = {

  //   //   'features': [
  //   //     {




  //   // }}]};
  //   // console.log(route);
  //   this.map.on('load', () => {
  //     // Add a source and layer displaying a point which will be animated in a circle.
  //     // console.log(route);
  //     this.map.addSource('route', {
  //       'type': 'geojson',
  //       'data': {
  //         'type': 'Feature',
  //         'properties': {},
  //         'geometry': {
  //           'type': 'LineString',
  //           'coordinates': [this.markersValue[0].lat, this.markersValue[0].lng, this.markersValue[1].lat, this.markersValue[1].lng]
  //         }
  //       },
  //     });

  //     this.map.addLayer({
  //       'id': 'route',
  //       'source': 'route',
  //       'type': 'line',
  //       'layout': {
  //         'line-join': 'round',
  //         'line-cap': 'round'
  //       },
  //       'paint': {
  //       'line-width': 8,
  //       'line-color': '#000'
  //       }
  //     });
  //   });
  // }
}
