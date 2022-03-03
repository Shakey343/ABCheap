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
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#fitMapToMarker();

    if (this.element.id === "map-routes") {
      this.#addMarkersToMap();
    }
  }

  #fitMapToMarker() {
    const bounds = new mapboxgl.LngLatBounds()
    // if (this.element.id === "map-routes") {
    //   this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    //   this.map.fitBounds(bounds, { padding: 20, maxZoom: 10, duration: 0 })
    // } else {
    // bounds.extend([-4.045050, 54.663169 ])
    // this.map.fitBounds(bounds, { padding: 70, maxZoom: 3.1, duration: 0 })
    // }
    bounds.extend([-4.045050, 54.663169 ])
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 3.1, duration: 0 })
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(this.map)
    });
  }
}
