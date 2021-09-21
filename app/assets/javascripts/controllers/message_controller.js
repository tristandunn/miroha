import { Controller } from "stimulus";

export default class MessageController extends Controller {
  /**
   * Dispatch event to messages controller.
   *
   * @return {void}
   */
  connect() {
    const event = document.createEvent("CustomEvent"),
      { element } = this;

    event.initCustomEvent(
      "message-connected", true, true, { "height": element.offsetHeight }
    );

    element.dispatchEvent(event);
  }
}
