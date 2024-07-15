import GameController from "@app/controllers/game_controller.js";

describe("GameController", () => {
  let instance;

  beforeEach(() => {
    instance = new GameController();
  });

  describe("#connect", () => {
    let addEventListener;

    beforeEach(() => {
      addEventListener = sinon.stub(document, "addEventListener");
    });

    it("adds an event listener for turbo:before-stream-render", () => {
      instance.connect();

      expect(addEventListener).to.have.been.calledWith(
        "turbo:before-stream-render", instance.onBeforeStreamRender
      );
    });
  });

  describe("#disconnect", () => {
    let removeEventListener;

    beforeEach(() => {
      removeEventListener = sinon.stub(document, "removeEventListener");
    });

    it("removes the event listener for turbo:before-stream-render", () => {
      instance.disconnect();

      expect(removeEventListener).to.have.been.calledWith(
        "turbo:before-stream-render", instance.onBeforeStreamRender
      );
    });
  });

  context("#onBeforeStreamRender", () => {
    let element,
      event,
      main;

    beforeEach(() => {
      element = document.createElement("div");
      event = {
        "preventDefault": sinon.stub(),
        "target": element
      };
      main = document.createElement("main");

      main.dataset.characterId = Math.random();

      document.body.appendChild(main);
    });

    context("with a matching character ID on the source element", () => {
      beforeEach(() => {
        element.dataset.characterId = main.dataset.characterId;
      });

      it("prevents the event default", () => {
        instance.onBeforeStreamRender(event);

        expect(event.preventDefault).to.have.been.called;
      });
    });

    context("with a matching character ID on the source template", () => {
      const querySelector = sinon.stub().returns(true);

      beforeEach(() => {
        event.target = {
          "dataset": {},
          "firstChild": {
            "content": { querySelector }
          }
        };
      });

      it("queries for the character ID", () => {
        instance.onBeforeStreamRender(event);

        expect(querySelector).to.have.been.calledWith(
          `[data-character-id="${main.dataset.characterId}"]`
        );
      });

      it("prevents the event default", () => {
        instance.onBeforeStreamRender(event);

        expect(event.preventDefault).to.have.been.called;
      });
    });

    context("with no character ID on the source element", () => {
      beforeEach(() => {
        delete element.dataset.characterId;
      });

      it("does not prevent the event default", () => {
        instance.onBeforeStreamRender(event);

        expect(event.preventDefault).to.not.have.been.called;
      });
    });

    context("with a non-matching character ID on the source element", () => {
      beforeEach(() => {
        element.dataset.characterId = Math.random();
      });

      it("does not prevent the event default", () => {
        instance.onBeforeStreamRender(event);

        expect(event.preventDefault).to.not.have.been.called;
      });
    });
  });
});
