import { Controller } from "stimulus";

export default class ChatController extends Controller {
  static targets = ["input", "message", "messages", "newMessages"];

  /**
   * Focus the command input element.
   *
   * @return {void}
   */
  focusCommand() {
    this.inputTarget.focus();
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
