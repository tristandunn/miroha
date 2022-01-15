import ChatController from "./chat_controller";
import GameController from "./game_controller";
import MessageController from "./message_controller";
import { application } from "./application";

application.register("chat", ChatController);
application.register("game", GameController);
application.register("message", MessageController);
