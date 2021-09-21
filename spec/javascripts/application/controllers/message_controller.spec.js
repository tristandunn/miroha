import MessageController from "controllers/message_controller";

describe("MessageController", () => {
  let element, instance;

  beforeEach(() => {
    element = document.createElement("div");
    instance = new MessageController({ "scope": { element } });
  });

  context("#connect", () => {
    let event;

    beforeEach(() => {
      event = document.createEvent("CustomEvent");
      sinon.stub(document, "createEvent").
        withArgs("CustomEvent").
        returns(event);
    });

    it("creates a message connected event", () => {
      const initCustomEvent = sinon.stub(event, "initCustomEvent");
      sinon.stub(element, "dispatchEvent");

      instance.connect();

      expect(initCustomEvent).to.have.been.calledWith(
        "message-connected", true, true, { "height": element.offsetHeight }
      );
    });

    it("dispatches a message connected event", () => {
      const dispatchEvent = sinon.stub(element, "dispatchEvent");

      instance.connect();

      expect(dispatchEvent).to.have.been.calledWith(event);
    });
  });
});
