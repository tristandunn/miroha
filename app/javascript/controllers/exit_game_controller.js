import { Controller } from "@hotwired/stimulus";

export default class ExitGameController extends Controller {
  /**
   * Click the exit game button.
   *
   * @return {void}
   */
  connect() { // eslint-disable-line class-methods-use-this
    document.querySelector("#exit_game").click();
  }
}
