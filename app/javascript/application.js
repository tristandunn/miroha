import "./controllers";
import "@hotwired/turbo-rails";
import Actions from "./actions";
import { StreamActions } from "@hotwired/turbo";

for (const name in Actions) {
  if (Object.hasOwn(Actions, name)) {
    StreamActions[name] = Actions[name];
  }
}
