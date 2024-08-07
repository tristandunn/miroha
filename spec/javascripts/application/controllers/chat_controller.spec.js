import ChatController from "@app/controllers/chat_controller.js";

describe("ChatController", () => {
  let element, instance;

  beforeEach(() => {
    element = document.createElement("form");
    instance = new ChatController({ "scope": { element } });
  });

  describe("#initialize", () => {
    it("sets message count to zero", () => {
      instance.initialize();

      expect(instance.messageCount).to.eq(0);
    });
  });

  describe("#aliasCommand", () => {
    let input;

    beforeEach(() => {
      input = document.createElement("input");

      instance.inputTarget = input;

      window.Miroha = {
        "Settings": {
          "aliases": {
            "/a": "/attack",
            "/me": "/emote"
          }
        }
      };
    });

    afterEach(() => {
      delete window.Miroha;
    });

    it("adds the aliased class to the input", () => {
      input.value = "/me writes tests";

      instance.aliasCommand();

      expect(input.classList.contains("aliased")).to.eq(true);
    });

    it("expands aliases in the input on the element", () => {
      Object.
        entries(window.Miroha.Settings.aliases).
        forEach(([alias, command]) => {
          input.value = `${alias} example`;

          instance.aliasCommand();

          expect(input.value).to.eq(`${command} example`);
        });
    });

    it("ignores input that is not an alias", () => {
      input.value = "/test example";

      instance.aliasCommand();

      expect(input.value).to.eq("/test example");
    });

    it("tracks the attack command", () => {
      const trackAttackCommand = sinon.stub(instance, "trackAttackCommand");

      instance.aliasCommand();

      expect(trackAttackCommand).to.have.been.called;
    });
  });

  describe("#focusCommand", () => {
    it("focuses the input on the element", () => {
      const input = document.createElement("input"),
        inputFocus = sinon.stub(input, "focus");

      instance.inputTarget = input;

      instance.focusCommand();

      expect(inputFocus).to.have.been.calledWith();
    });
  });

  describe("#handleRedirect", () => {
    let redirect;

    beforeEach(() => {
      redirect = sinon.stub(instance, "redirect");
    });

    context("with a redirect response", () => {
      const event = {
        "detail": {
          "fetchResponse": {
            "response": {
              "redirected": true,
              "url": "https://example.com"
            }
          }
        }
      };

      it("redirects", () => {
        instance.handleRedirect(event);

        expect(redirect).to.have.been.calledWith("https://example.com");
      });
    });

    context("with no redirect response", () => {
      const event = { "detail": { "fetchResponse": { "response": {} } } };

      it("does not redirect", () => {
        instance.handleRedirect(event);

        expect(redirect).not.to.have.been.called;
      });
    });
  });

  describe("#messageTargetConnected", () => {
    const messageElement = { "offsetHeight": 3 };

    let newMessagesTarget, pruneMessages, scrollToBottom;

    beforeEach(() => {
      pruneMessages = sinon.stub(instance, "pruneMessages");
      scrollToBottom = sinon.stub(instance, "scrollToBottom");
      newMessagesTarget = document.createElement("div");
      newMessagesTarget.classList.add("hidden");

      instance.newMessagesTarget = newMessagesTarget;
    });

    context("with a negative scroll difference", () => {
      beforeEach(() => {
        instance.messagesTarget = {
          "offsetHeight": 5,
          "scrollHeight": 5,
          "scrollTop": 0
        };
      });

      it("scrolls to the bottom", () => {
        instance.messageTargetConnected(messageElement);

        expect(scrollToBottom).to.have.been.calledWith();
      });

      it("prunes the messages", () => {
        instance.messageTargetConnected(messageElement);

        expect(pruneMessages).to.have.been.calledWith();
      });

      it("does not remove the messages target hidden class", () => {
        instance.messageTargetConnected(messageElement);

        expect(newMessagesTarget.classList).to.contain(["hidden"]);
      });
    });

    context("with a scroll difference matching the scroll top", () => {
      beforeEach(() => {
        instance.messagesTarget = {
          "offsetHeight": 0,
          "scrollHeight": 0,
          "scrollTop": -3
        };
      });

      it("scrolls to the bottom", () => {
        instance.messageTargetConnected(messageElement);

        expect(scrollToBottom).to.have.been.calledWith();
      });

      it("prunes the messages", () => {
        instance.messageTargetConnected(messageElement);

        expect(pruneMessages).to.have.been.calledWith();
      });

      it("does not remove the messages target hidden class", () => {
        instance.messageTargetConnected(messageElement);

        expect(newMessagesTarget.classList).to.contain(["hidden"]);
      });
    });

    context("with positive scroll difference not matching scroll top", () => {
      beforeEach(() => {
        instance.messagesTarget = {
          "offsetHeight": 0,
          "scrollHeight": 100,
          "scrollTop": 23
        };
      });

      it("does not scroll to the bottom", () => {
        instance.messageTargetConnected(messageElement);

        expect(scrollToBottom).not.to.have.been.calledWith();
      });

      it("does not prune the messages", () => {
        instance.messageTargetConnected(messageElement);

        expect(pruneMessages).not.to.have.been.calledWith();
      });

      it("removes the messages target hidden class", () => {
        instance.messageTargetConnected(messageElement);

        expect(newMessagesTarget.classList).not.to.contain(["hidden"]);
      });
    });
  });

  describe("#pruneMessages", () => {
    let remove;

    beforeEach(() => {
      const row = document.createElement("tr");

      sinon.stub(element, "querySelector").
        withArgs("table tr:first-child").
        returns(row);

      remove = sinon.stub(row, "remove");
    });

    context("when message count exceeds the limit", () => {
      beforeEach(() => {
        instance.messageCount = 999;
      });

      it("removes the first row in the element table", () => {

        instance.pruneMessages();

        expect(remove).to.have.been.calledWith();
      });

      it("does not increment the message count", () => {
        instance.pruneMessages();

        expect(instance.messageCount).to.eq(999);
      });
    });

    context("when message count does not exceed the limit", () => {
      beforeEach(() => {
        instance.messageCount = 0;
      });

      it("does not remove the first row in the element table", () => {
        instance.pruneMessages();

        expect(remove).not.to.have.been.calledWith();
      });

      it("increments the message count", () => {
        instance.pruneMessages();

        expect(instance.messageCount).to.eq(1);
      });
    });
  });

  describe("#redirect", () => {
    let originalWindow;

    beforeEach(() => {
      originalWindow = global.window;

      global.window = {};
    });

    afterEach(() => {
      global.window = originalWindow;
    });

    it("sets the window location to the provided URL", () => {
      const url = sinon.stub();

      instance.redirect(url);

      expect(window.location).to.eq(url);
    });
  });

  describe("#resetForm", () => {
    let input;

    beforeEach(() => {
      input = document.createElement("input");
      input.classList.add("aliased");

      instance.inputTarget = input;
    });

    it("resets the element", () => {
      const reset = sinon.stub(element, "reset");

      instance.resetForm();

      expect(reset).to.have.been.calledWith();
    });

    it("removed the aliased class from the input", () => {
      instance.resetForm();

      expect(input.classList.contains("aliased")).to.eq(false);
    });
  });

  describe("#scrollToBottom", () => {
    const messagesTarget = {
      "scrollHeight": 311,
      "scrollTop": 100
    };

    let newMessagesTarget;

    beforeEach(() => {
      newMessagesTarget = document.createElement("div");

      instance.messagesTarget = messagesTarget;
      instance.newMessagesTarget = newMessagesTarget;
    });

    it("sets the scroll top to the scroll height", () => {
      instance.scrollToBottom();

      expect(messagesTarget.scrollTop).to.eq(messagesTarget.scrollHeight);
    });

    context("with an event", () => {
      it("adds hidden class to messages target", () => {
        instance.scrollToBottom({});

        expect(newMessagesTarget.classList).to.contain(["hidden"]);
      });
    });

    context("without an event", () => {
      it("does not add hidden class to messages target", () => {
        instance.scrollToBottom();

        expect(newMessagesTarget.classList).not.to.contain(["hidden"]);
      });
    });
  });

  describe("#trackAttackCommand", () => {
    let input;

    beforeEach(() => {
      input = document.createElement("input");

      instance.inputTarget = input;
    });

    context("attacking with a target name", () => {
      it("saves attack commands", () => {
        input.value = "/attack Rat";

        instance.trackAttackCommand();

        expect(instance.lastAttackCommand).to.eq("/attack Rat");
      });

      it("does not modify the command with the last attack command", () => {
        instance.lastAttackCommand = "/attack Bird";
        input.value = "/attack Rat";

        instance.trackAttackCommand();

        expect(input.value).to.eq("/attack Rat");
      });
    });

    context("attacking without a target name", () => {
      it("expands to the last attack command when present", () => {
        instance.lastAttackCommand = "/attack Rat";
        input.value = "/attack ";

        instance.trackAttackCommand();

        expect(input.value).to.eq("/attack Rat");
      });

      it("does not expand when last attack command is not present", () => {
        input.value = "/attack";

        instance.trackAttackCommand();

        expect(input.value).to.eq("/attack");
      });
    });

    context("when not attacking", () => {
      it("does not save the command", () => {
        input.value = "/say Hello!";

        instance.trackAttackCommand();

        expect(instance.lastAttackCommand).to.be.undefined;
      });

      it("does not modify the command with the last attack command", () => {
        instance.lastAttackCommand = "/attack Bird";
        input.value = "/say Hello!";

        instance.trackAttackCommand();

        expect(input.value).to.eq("/say Hello!");
      });
    });
  });

  describe("#validateCommand", () => {
    let event, input, preventDefault, stopPropagation;

    beforeEach(() => {
      event = document.createEvent("Event");
      input = document.createElement("input");
      preventDefault = sinon.stub(event, "preventDefault");
      stopPropagation = sinon.stub(event, "stopPropagation");

      instance.inputTarget = input;
    });

    context("with a blank input value", () => {
      beforeEach(() => {
        input.value = "  ";
      });

      it("prevents the default event", () => {
        instance.validateCommand(event);

        expect(preventDefault).to.have.been.calledWith();
      });

      it("stops propagation of the event", () => {
        instance.validateCommand(event);

        expect(stopPropagation).to.have.been.calledWith();
      });
    });

    context("with an input value of a forward slash", () => {
      beforeEach(() => {
        input.value = " / ";
      });

      it("prevents the default event", () => {
        instance.validateCommand(event);

        expect(preventDefault).to.have.been.calledWith();
      });

      it("stops propagation of the event", () => {
        instance.validateCommand(event);

        expect(stopPropagation).to.have.been.calledWith();
      });
    });

    context("with a present input value", () => {
      beforeEach(() => {
        input.value = " Hello. ";
      });

      it("does not prevent the default event", () => {
        instance.validateCommand(event);

        expect(preventDefault).not.to.have.been.called;
      });

      it("does not stop propagation of the event", () => {
        instance.validateCommand(event);

        expect(stopPropagation).not.to.have.been.called;
      });
    });
  });
});
