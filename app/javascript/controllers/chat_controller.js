import { Controller } from "@hotwired/stimulus";

const ALIAS_CLASS = "aliased",
  MESSAGE_LIMIT = 256;

export default class ChatController extends Controller {
  static targets = ["input", "message", "messages", "newMessages"];

  /**
   * Initialize the controller when connected.
   *
   * @return {void}
   */
  initialize() {
    this.messageCount = 0;
  }

  /**
   * Expand command aliases in the command input element.
   *
   * @return {void}
   */
  aliasCommand() {
    const input = this.inputTarget,
      [command] = input.value.trim().split(" "),
      alias = window.Miroha.Settings.aliases[command];

    if (alias) {
      input.classList.add(ALIAS_CLASS);
      input.value = input.value.replace(command, alias);
    }

    this.trackAttackCommand();
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
  handleRedirect(event) {
    const { redirected, url } = event.detail.fetchResponse.response;

    if (redirected) {
      this.redirect(url);
    }
  }

  /**
   * Scroll to the bottom when a message is connected.
   *
   * @param {Element} element The message element connected.
   * @return {void}
   */
  messageTargetConnected(element) {
    const { offsetHeight, scrollHeight, scrollTop } = this.messagesTarget,
      difference = scrollHeight - offsetHeight - element.offsetHeight;

    if (difference < 0 || difference === scrollTop) {
      this.scrollToBottom();
      this.pruneMessages();
    } else {
      this.newMessagesTarget.classList.remove("hidden");
    }
  }

  /**
   * When the message limit is reached, remove the first message.
   *
   * @return {void}
   */
  pruneMessages() {
    if (this.messageCount < MESSAGE_LIMIT) {
      this.messageCount += 1;
    } else {
      this.element.querySelector("table tr:first-child").remove();
    }
  }

  /**
   * Redirect to the provided URL.
   *
   * This is strictly a helper method to allow stubbing in tests.
   *
   * @param {String} url The URL to redirect to.
   * @return {void}
   */
  /* istanbul ignore next */
  redirect(url) { // eslint-disable-line class-methods-use-this
    window.location = url;
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
   * Track the last attack command when a target is present, if no target is
   * present use the last attack command if available.
   *
   * @return {void}
   */
  trackAttackCommand() {
    const input = this.inputTarget,
      [command, target] = input.value.trim().split(" ");

    if (command !== "/attack") {
      return;
    }

    if (target) {
      this.lastAttackCommand = input.value;
    } else if (this.lastAttackCommand) {
      input.value = this.lastAttackCommand;
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

    if (value === "" || value === "/") {
      event.preventDefault();
      event.stopPropagation();
    }
  }
}
