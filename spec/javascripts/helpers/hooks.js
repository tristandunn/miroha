export const mochaHooks = {
  afterEach() {
    sinon.restore();
  },

  beforeEach() {
    global.createDOM();
  }
};
