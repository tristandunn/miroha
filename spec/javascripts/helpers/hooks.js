exports.mochaHooks = {
  afterEach() {
    sinon.restore();
  },

  beforeEach() {
    global.createDOM();
  }
};
