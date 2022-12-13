import { Application } from "@hotwired/stimulus";
import ChatController from "./chat_controller";
import GameController from "./game_controller";

const application = Application.start();

application.register("chat", ChatController);
application.register("game", GameController);
