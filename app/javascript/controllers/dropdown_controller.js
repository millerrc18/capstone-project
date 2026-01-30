import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.close = this.close.bind(this)
    document.addEventListener("click", this.close)
  }

  disconnect() {
    document.removeEventListener("click", this.close)
  }

  toggle(event) {
    event.stopPropagation()
    this.element.classList.toggle("is-open")
  }

  close(event) {
    if (this.element.contains(event.target)) return
    this.element.classList.remove("is-open")
  }
}
