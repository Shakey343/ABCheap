import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    apiKey: String,
    // markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.fitMapToMarker();
  }

  fitMapToMarker() {
    const bounds = new mapboxgl.LngLatBounds()
    bounds.extend([-4.045050, 54.663169 ])
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 3.1, duration: 0 })
  }
}
