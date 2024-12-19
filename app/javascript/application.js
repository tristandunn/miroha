import { Turbo } from "@hotwired/turbo-rails";
import Actions from "actions";
import "controllers";

for (const name in Actions) {
  if (Object.hasOwn(Actions, name)) {
    Turbo.StreamActions[name] = Actions[name];
  }
}
