import { Application } from "@hotwired/stimulus";
import ChatController from "./chat_controller";
import GameController from "./game_controller";
import StreamsController from "./streams_controller";

const application = Application.start();

application.register("chat", ChatController);
application.register("game", GameController);
application.register("streams", StreamsController);
