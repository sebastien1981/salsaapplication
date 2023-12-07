import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="disablebutton"
export default class extends Controller {

  connect() {
    console.log("Hello from disablebutton_controller.js")
  }
  disable(event) {
    console.log(event);
    this.element.setAttribute("disabled", "");
  }

}
