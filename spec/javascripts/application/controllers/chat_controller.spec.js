import ChatController from "controllers/chat_controller";

describe("ChatController", () => {
  let element, instance;

  beforeEach(() => {
    element = document.createElement("form");
    instance = new ChatController({ "scope": { element } });
  });

  context("#aliasCommand", () => {
    let input;

    beforeEach(() => {
      input = document.createElement("input");

      instance.inputTarget = input;
    });

    it("adds the aliased class to the input", () => {
      input.value = "/me writes tests";

      instance.aliasCommand();

      expect(input.classList.contains("aliased")).to.eq(true);
    });

    it("expands aliases in the input on the element", () => {
      Object.
        entries(ChatController.aliases).
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

  context("#focusCommand", () => {
    it("focuses the input on the element", () => {
      const input = document.createElement("input"),
        inputFocus = sinon.stub(input, "focus");

      instance.inputTarget = input;

      instance.focusCommand();

      expect(inputFocus).to.have.been.calledWith();
    });
  });

  context("#handleRedirect", () => {
    const { location } = window;

    beforeEach(() => {
      delete window.location;

      window.location = Object.defineProperties(
        {},
        {
          ...Object.getOwnPropertyDescriptors(location),
          "assign": {
            "configurable": true,
            "value": sinon.stub()
          }
        }
      );
    });

    afterEach(() => {
      window.location = location;
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

        expect(window.location.toString()).to.be.eq("https://example.com");
      });
    });

    context("with no redirect response", () => {
      const event = { "detail": { "fetchResponse": { "response": {} } } };

      it("does not redirect", () => {
        instance.handleRedirect(event);

        expect(window.location.toString()).to.be.eq("about:blank");
      });
    });
  });

  context("#messageConnected", () => {
    const event = { "detail": { "height": 3 } };

    let newMessagesTarget, scrollToBottom;

    beforeEach(() => {
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
        instance.messageConnected(event);

        expect(scrollToBottom).to.have.been.calledWith();
      });

      it("does not remove the messages target hidden class", () => {
        instance.messageConnected(event);

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

      it("does not scroll to the bottom", () => {
        instance.messageConnected(event);

        expect(scrollToBottom).to.have.been.calledWith();
      });

      it("does not remove the messages target hidden class", () => {
        instance.messageConnected(event);

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
        instance.messageConnected(event);

        expect(scrollToBottom).not.to.have.been.calledWith();
      });

      it("removes the messages target hidden class", () => {
        instance.messageConnected(event);

        expect(newMessagesTarget.classList).not.to.contain(["hidden"]);
      });
    });
  });

  context("#resetForm", () => {
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

  context("#scrollToBottom", () => {
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

  context("#validateCommand", () => {
    const event = document.createEvent("Event");

    let input, preventDefault, stopPropagation;

    beforeEach(() => {
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
