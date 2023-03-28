const chai = require("chai"),
  sinon = require("sinon"),
  sinonChai = require("sinon-chai"),
  { JSDOM } = require("jsdom");

chai.use(sinonChai);

global.expect = chai.expect;
global.navigator = { "userAgent": "node.js" };
global.sinon = sinon.createSandbox();

global.createDOM = () => {
  const dom = new JSDOM("", { "pretendToBeVisual": true });

  global.window = dom.window;
  global.document = global.window.document;
};
