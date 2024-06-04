import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocompletion"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("autocomplete test yotototoototottototot")
  }

  autocomplete() {
    // Implement the autocomplete logic here
  }
}
