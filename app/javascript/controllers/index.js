import ChatController from "./chat_controller";
import ExitGameController from "./exit_game_controller";
import GameController from "./game_controller";
import MessageController from "./message_controller";
import { application } from "./application";

application.register("chat", ChatController);
application.register("exit-game", ExitGameController);
application.register("game", GameController);
application.register("message", MessageController);
