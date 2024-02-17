import StreamsController from "@app/controllers/streams_controller.js";

describe("StreamsController", () => {
  let instance;

  beforeEach(() => {
    instance = new StreamsController();
  });

  describe("#connect", () => {
    let observe,
      observer;

    beforeEach(() => {
      observe = sinon.stub();
      observer = sinon.stub();
      observer.prototype.observe = observe;

      global.MutationObserver = observer;
    });

    it("creates a MutationObserver", () => {
      sinon.stub(instance.onElementChange, "bind").
        withArgs(instance).
        returns(instance.onElementChange);

      instance.connect();

      expect(observer).to.have.been.calledWith(instance.onElementChange);
    });

    it("observes the stream target", () => {
      instance.streamTarget = sinon.stub();

      instance.connect();

      expect(observe).to.have.been.calledWith(instance.streamTarget, {
        "attributes": true,
        "attributeFilter": ["connected"]
      });
    });
  });

  describe("#disconnect", () => {
    it("disconnects the observer", () => {
      const disconnect = sinon.stub(),
        observer = sinon.stub();

      observer.disconnect = disconnect;
      instance.observer = observer;

      instance.disconnect();

      expect(disconnect).to.have.been.calledWith();
    });
  });

  describe("#onElementChange", () => {
    let input,
      noticeTarget,
      streamTarget;

    beforeEach(() => {
      input = document.createElement("div");
      noticeTarget = document.createElement("div");
      streamTarget = document.createElement("div");

      sinon.stub(document, "querySelector").
        withArgs("#input").
        returns(input);

      instance.noticeTarget = noticeTarget;
      instance.streamTarget = streamTarget;
    });

    context("when stream target has connected attribute", () => {
      let add,
        focus,
        removeAttribute;

      beforeEach(() => {
        sinon.stub(streamTarget, "hasAttribute").returns(true);

        add = sinon.stub(noticeTarget.classList, "add");
        focus = sinon.stub(input, "focus");
        removeAttribute = sinon.stub(input, "removeAttribute");
      });

      it("adds the hidden class to notice target", () => {
        instance.onElementChange([true]);

        expect(add).to.have.been.calledWith("hidden");
      });

      it("removes disabled attribute from the input", () => {
        instance.onElementChange([true]);

        expect(removeAttribute).to.have.been.calledWith("disabled");
      });

      it("focuses the input", () => {
        instance.onElementChange([true]);

        expect(focus).to.have.been.calledWith();
      });
    });

    context("when stream target does not have the connected attribute", () => {
      let remove,
        setAttribute;

      beforeEach(() => {
        sinon.stub(streamTarget, "hasAttribute").returns(false);

        remove = sinon.stub(noticeTarget.classList, "remove");
        setAttribute = sinon.stub(input, "setAttribute");
      });

      it("removes the hidden class from the notice target", () => {
        instance.onElementChange([true]);

        expect(remove).to.have.been.calledWith("hidden");
      });

      it("adds disabled attribute to the input", () => {
        instance.onElementChange([true]);

        expect(setAttribute).to.have.been.calledWith("disabled");
      });
    });
  });
});
