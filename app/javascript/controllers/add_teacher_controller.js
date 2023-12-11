import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-teacher"
export default class extends Controller {
  static targets = ["button"]

  connect() {
    console.log("Hello from add_button_controller.js")
  }

  addteacher(event) {
    console.log(event);
    const url = `/schooltearchers`
    console.log("url:" + url);

    fetch(url)

      .then(response => response.json())
.then((data) => {
  console.log("data" + data);
})
  }
  }//addteacher
//controller
