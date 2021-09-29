import { Controller } from "@hotwired/stimulus";

export default class GameController extends Controller {
  /**
   * Add listener for the +turbo:before-stream-render+ event.
   *
   * @return {void}
   */
  connect() {
    document.addEventListener(
      "turbo:before-stream-render",
      this.onBeforeStreamRender
    );
  }

  /**
   * Remove listener for the +turbo:before-stream-render+ event.
   *
   * @return {void}
   */
  disconnect() {
    document.removeEventListener(
      "turbo:before-stream-render",
      this.onBeforeStreamRender
    );
  }

  /**
   * Prevent the stream render event if the element or element template is for
   * the current character.
   *
   * @param {Event} event The stream render event.
   * @return {void}
   */
  onBeforeStreamRender(event) { // eslint-disable-line class-methods-use-this
    const { target } = event,
      currentId = document.querySelector("main").dataset.characterId,
      eventId = target.dataset.characterId,
      eventTemplate = target?.firstChild?.content;

    if (
      eventId === currentId ||
      eventTemplate?.querySelector(`[data-character-id="${currentId}"]`)
    ) {
      event.preventDefault();
    }
  }
}
