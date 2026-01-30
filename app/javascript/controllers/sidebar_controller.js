import { Controller } from "@hotwired/stimulus"

const COLLAPSE_KEY = "pm-copilot:sidebar-collapsed"

export default class extends Controller {
  connect() {
    const collapsed = window.localStorage.getItem(COLLAPSE_KEY) === "true"
    document.body.classList.toggle("sidebar-collapsed", collapsed)
  }

  toggle() {
    const collapsed = !document.body.classList.contains("sidebar-collapsed")
    document.body.classList.toggle("sidebar-collapsed", collapsed)
    window.localStorage.setItem(COLLAPSE_KEY, collapsed)
  }

  toggleMobile() {
    document.body.classList.toggle("sidebar-open")
  }
}
