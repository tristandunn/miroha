import { Controller } from "@hotwired/stimulus";

const ALIAS_CLASS = "aliased";

export default class ChatController extends Controller {
  static aliases = {
    "/me": "/emote",
    "d": "/move down",
    "e": "/move east",
    "n": "/move north",
    "s": "/move south",
    "u": "/move up",
    "w": "/move west"
  };

  static targets = ["input", "message", "messages", "newMessages"];

  /**
   * Expand command aliases in the command input element.
   *
   * @return {void}
   */
  aliasCommand() {
    const input = this.inputTarget,
      [command] = input.value.trim().split(" "),
      alias = ChatController.aliases[command];

    if (alias) {
      input.classList.add(ALIAS_CLASS);
      input.value = input.value.replace(command, alias);
    }
  }

  /**
   * Focus the command input element.
   *
   * @return {void}
   */
  focusCommand() {
    this.inputTarget.focus();
  }

  /**
   * Handle redirect responses.
   *
   * @param {Event} event The submit event.
   * @return {void}
   */
  handleRedirect(event) { // eslint-disable-line class-methods-use-this
    const { redirected, url } = event.detail.fetchResponse.response;

    if (redirected) {
      window.location = url;
    }
  }

  /**
   * Scroll to the bottom when a message is connected.
   *
   * @param {Event} event The dispatched event.
   * @return {void}
   */
  messageConnected(event) {
    const { offsetHeight, scrollHeight, scrollTop } = this.messagesTarget,
      difference = scrollHeight - offsetHeight - event.detail.height;

    if (difference < 0 || difference === scrollTop) {
      this.scrollToBottom();
    } else {
      this.newMessagesTarget.classList.remove("hidden");
    }
  }

  /**
   * Reset the form element.
   *
   * @return {void}
   */
  resetForm() {
    this.element.reset();
    this.inputTarget.classList.remove(ALIAS_CLASS);
  }

  /**
   * Scroll to the bottom of the messages element.
   *
   * @param {Event} event The click event.
   * @return {void}
   */
  scrollToBottom(event) {
    const element = this.messagesTarget;

    element.scrollTop = element.scrollHeight;

    if (event) {
      this.newMessagesTarget.classList.add("hidden");
    }
  }

  /**
   * Ensure a command is present before submitting.
   *
   * @param {Event} event The submit event.
   * @return {void}
   */
  validateCommand(event) {
    const input = this.inputTarget,
      value = input.value.toString().trim();

    if (value === "") {
      event.preventDefault();
      event.stopPropagation();
    }
  }
}
