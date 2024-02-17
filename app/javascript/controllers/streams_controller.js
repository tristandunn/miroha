/* global MutationObserver */

import { Controller } from "@hotwired/stimulus";

export default class StreamsController extends Controller {
  static targets = ["notice", "stream"];

  /**
   * Add observer for the target stream to monitor connection status.
   *
   * @return {void}
   */
  connect() {
    this.observer = new MutationObserver(this.onElementChange.bind(this));
    this.observer.observe(this.streamTarget, {
      "attributes": true,
      "attributeFilter": ["connected"]
    });
  }

  /**
   * Remove observer for the target stream.
   *
   * @return {void}
   */
  disconnect() {
    this.observer.disconnect();
  }

  /**
   * Triggered when the target stream element connected attribute changes.
   *
   * @param {Array<MutationRecord>} mutationList An array of mutation records.
   * @return {void}
   */
  onElementChange(mutationList) {
    const input = document.querySelector("#input");

    mutationList.forEach(() => {
      if (this.streamTarget.hasAttribute("connected")) {
        this.noticeTarget.classList.add("hidden");

        input.removeAttribute("disabled");
        input.focus();
      } else {
        this.noticeTarget.classList.remove("hidden");

        input.setAttribute("disabled", true);
      }
    });
  }
}

