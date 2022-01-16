import ExitGameController from "controllers/exit_game_controller";

describe("ExitGameController", () => {
  let instance;

  beforeEach(() => {
    instance = new ExitGameController();
  });

  describe("#connect", () => {
    let click,
      element,
      querySelector;

    beforeEach(() => {
      element = document.createElement("div");
      click = sinon.stub(element, "click");
      querySelector = sinon.stub(document, "querySelector").returns(element);
    });

    it("queries for the exit game button", () => {
      instance.connect();

      expect(querySelector).to.have.been.calledWith("#exit_game");
    });

    it("clicks the exit game button", () => {
      instance.connect();

      expect(click).to.have.been.called;
    });
  });
});
