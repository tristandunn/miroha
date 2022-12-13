import Actions from "actions";

describe("Actions", () => {
  describe("#exit", () => {
    let click,
      element,
      querySelector;

    beforeEach(() => {
      element = document.createElement("div");
      click = sinon.stub(element, "click");
      querySelector = sinon.stub(document, "querySelector").returns(element);
    });

    it("queries for the exit game button", () => {
      Actions.exit();

      expect(querySelector).to.have.been.calledWith("#exit_game");
    });

    it("clicks the exit game button", () => {
      Actions.exit();

      expect(click).to.have.been.called;
    });
  });
});
