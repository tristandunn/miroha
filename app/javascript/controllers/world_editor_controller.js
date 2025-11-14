import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "currentRoomId",
    "currentX",
    "currentY",
    "currentZ",
    "description",
    "objects",
    "saveStatus",
    "saveStatusBar",
    "npcForm",
    "npcName",
    "npcList",
    "monsterList",
    "itemForm",
    "itemName",
    "itemList",
    "spawnForm",
    "spawnType",
    "spawnBaseId",
    "spawnFrequency",
    "spawnDuration",
    "spawnList",
    "grid"
  ];

  connect() {
    this.originalDescription = this.hasDescriptionTarget
      ? this.descriptionTarget.value
      : "";
    this.originalObjects = this.hasObjectsTarget
      ? this.objectsTarget.value
      : "";
  }

  // Room Description Management
  async saveDescription() {
    const roomId = this.currentRoomIdTarget.textContent.trim();
    const description = this.descriptionTarget.value;

    // Don't save if nothing changed
    if (description === this.originalDescription) {
      return;
    }

    if (!roomId) {
      this.showSaveStatus("Please create the room first", "error");
      return;
    }

    try {
      const response = await this.updateRoom(roomId, { description });

      if (response.ok) {
        this.originalDescription = description;
        this.showSaveStatus("Saved", "success");
      } else {
        const data = await response.json();
        this.showSaveStatus(`Error: ${data.errors.join(", ")}`, "error");
      }
    } catch (error) {
      this.showSaveStatus(`Error: ${error.message}`, "error");
    }
  }

  async saveObjects() {
    const roomId = this.currentRoomIdTarget.textContent.trim();
    const objectsText = this.objectsTarget.value;

    // Don't save if nothing changed
    if (objectsText === this.originalObjects) {
      return;
    }

    if (!roomId) {
      this.showSaveStatus("Please create the room first", "error");
      return;
    }

    try {
      const objects = objectsText
        ? JSON.parse(objectsText)
        : {};
      const response = await this.updateRoom(roomId, { objects });

      if (response.ok) {
        this.originalObjects = objectsText;
        this.showSaveStatus("Objects saved", "success");
      } else {
        const data = await response.json();
        this.showSaveStatus(`Error: ${data.errors.join(", ")}`, "error");
      }
    } catch (error) {
      this.showSaveStatus(`Invalid JSON: ${error.message}`, "error");
    }
  }

  showSaveStatus(message, type) {
    const messageDisplayTimeout = 3000;

    if (!this.hasSaveStatusTarget || !this.hasSaveStatusBarTarget) return;

    // Show the bar and set message
    this.saveStatusBarTarget.classList.remove("hidden");
    this.saveStatusTarget.textContent = message;
    this.saveStatusTarget.className = `px-6 py-2 text-sm min-h-[2.5rem] flex items-center bg-gray-700 border-b border-gray-600 ${type === "success"
      ? "text-green-400"
      : "text-red-400"}`;

    setTimeout(() => {
      this.saveStatusTarget.textContent = "";
      this.saveStatusTarget.className = "px-6 py-2 text-sm min-h-[2.5rem] flex items-center bg-gray-700 border-b border-gray-600";
      this.saveStatusBarTarget.classList.add("hidden");
    }, messageDisplayTimeout);
  }

  async updateRoom(roomId, updates) {
    return fetch(`/api/rooms/${roomId}`, {
      "method": "PATCH",
      "headers": {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken()
      },
      "body": JSON.stringify({ "room": updates })
    });
  }

  // NPC Management
  toggleNpcForm() {
    this.npcFormTarget.classList.toggle("hidden");
    if (!this.npcFormTarget.classList.contains("hidden")) {
      this.npcNameTarget.value = "";
      this.npcNameTarget.focus();
    }
  }

  async createNpc() {
    const roomId = this.currentRoomIdTarget.textContent.trim();
    const name = this.npcNameTarget.value.trim();

    if (!roomId) {
      alert("Please create the room first");
      return;
    }

    if (!name) {
      alert("Please enter an NPC name");
      return;
    }

    try {
      const response = await fetch("/api/npcs", {
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken()
        },
        "body": JSON.stringify({
          "npc": { name,
            "room_id": roomId }
        })
      });

      if (response.ok) {
        const data = await response.json();
        this.addNpcToList(data);
        this.toggleNpcForm();
      } else {
        const data = await response.json();
        alert(`Error: ${data.errors.join(", ")}`);
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  }

  async deleteNpc(event) {
    const id = event.target.dataset.id;
    const isSpawned = event.target.dataset.spawned === "true";
    const message = isSpawned
      ? "Delete this spawned NPC? (It may respawn)"
      : "Delete this NPC?";

    if (!confirm(message)) return;

    try {
      const response = await fetch(`/api/npcs/${id}`, {
        "method": "DELETE",
        "headers": {
          "X-CSRF-Token": this.csrfToken()
        }
      });

      if (response.ok) {
        event.target.closest(".flex").remove();
      } else {
        alert("Error deleting NPC");
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  }

  addNpcToList(npc) {
    const html = `
      <div class="flex justify-between items-center p-2 bg-gray-700 rounded text-sm text-white">
        <div>
          <span>${npc.name}</span>
        </div>
        <button
          data-action="click->world-editor#deleteNpc"
          data-id="${npc.id}"
          data-spawned="false"
          class="text-red-400 hover:text-red-300"
        >Delete</button>
      </div>
    `;
    this.npcListTarget.insertAdjacentHTML("beforeend", html);
  }

  // Monster Management
  async deleteMonster(event) {
    const id = event.target.dataset.id;
    const isSpawned = event.target.dataset.spawned === "true";
    const message = isSpawned
      ? "Delete this spawned monster? (It may respawn)"
      : "Delete this monster?";

    if (!confirm(message)) return;

    try {
      const response = await fetch(`/api/monsters/${id}`, {
        "method": "DELETE",
        "headers": {
          "X-CSRF-Token": this.csrfToken()
        }
      });

      if (response.ok) {
        event.target.closest(".flex").remove();
      } else {
        alert("Error deleting monster");
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  }

  // Item Management
  toggleItemForm() {
    this.itemFormTarget.classList.toggle("hidden");
    if (!this.itemFormTarget.classList.contains("hidden")) {
      this.itemNameTarget.value = "";
      this.itemNameTarget.focus();
    }
  }

  async createItem() {
    const roomId = this.currentRoomIdTarget.textContent.trim();
    const name = this.itemNameTarget.value.trim();

    if (!roomId) {
      alert("Please create the room first");
      return;
    }

    if (!name) {
      alert("Please enter an item name");
      return;
    }

    try {
      const response = await fetch("/api/items", {
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken()
        },
        "body": JSON.stringify({
          "item": {
            name,
            "owner_id": roomId,
            "owner_type": "Room"
          }
        })
      });

      if (response.ok) {
        const data = await response.json();
        this.addItemToList(data);
        this.toggleItemForm();
      } else {
        const data = await response.json();
        alert(`Error: ${data.errors.join(", ")}`);
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  }

  async deleteItem(event) {
    const id = event.target.dataset.id;

    if (!confirm("Delete this item?")) return;

    try {
      const response = await fetch(`/api/items/${id}`, {
        "method": "DELETE",
        "headers": {
          "X-CSRF-Token": this.csrfToken()
        }
      });

      if (response.ok) {
        event.target.closest(".flex").remove();
      } else {
        alert("Error deleting item");
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  }

  addItemToList(item) {
    const html = `
      <div class="flex justify-between items-center p-2 bg-gray-700 rounded text-sm">
        <span>${item.name}</span>
        <button
          data-action="click->world-editor#deleteItem"
          data-id="${item.id}"
          class="text-red-400 hover:text-red-300"
        >Delete</button>
      </div>
    `;
    this.itemListTarget.insertAdjacentHTML("beforeend", html);
  }

  // Spawn Management
  toggleSpawnForm() {
    this.spawnFormTarget.classList.toggle("hidden");
    if (!this.spawnFormTarget.classList.contains("hidden")) {
      this.spawnTypeTarget.value = "";
      this.spawnBaseIdTarget.value = "";
      this.spawnFrequencyTarget.value = "";
      this.spawnDurationTarget.value = "";
      this.spawnTypeTarget.focus();
    }
  }

  async createSpawn() {
    const roomId = this.currentRoomIdTarget.textContent.trim();
    const baseType = this.spawnTypeTarget.value;
    const baseId = parseInt(this.spawnBaseIdTarget.value);
    const frequency = parseInt(this.spawnFrequencyTarget.value);
    const duration = parseInt(this.spawnDurationTarget.value);

    if (!roomId) {
      alert("Please create the room first");
      return;
    }

    if (!baseType || !baseId) {
      alert("Please select a type and enter a base template ID");
      return;
    }

    try {
      const response = await fetch("/api/spawns", {
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken()
        },
        "body": JSON.stringify({
          "spawn": {
            "base_type": baseType,
            "base_id": baseId,
            "room_id": roomId,
            frequency,
            duration
          }
        })
      });

      if (response.ok) {
        const data = await response.json();
        this.addSpawnToList(data);
        this.toggleSpawnForm();
      } else {
        const data = await response.json();
        alert(`Error: ${data.errors.join(", ")}`);
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  }

  async deleteSpawn(event) {
    const id = event.target.dataset.id;

    if (!confirm("Delete this spawn?")) return;

    try {
      const response = await fetch(`/api/spawns/${id}`, {
        "method": "DELETE",
        "headers": {
          "X-CSRF-Token": this.csrfToken()
        }
      });

      if (response.ok) {
        event.target.closest(".flex").remove();
      } else {
        alert("Error deleting spawn");
      }
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  }

  addSpawnToList(spawn) {
    const html = `
      <div class="flex justify-between items-center p-2 bg-gray-700 rounded text-sm">
        <div>
          <div>${spawn.base_name} (${spawn.base_type})</div>
          <div class="text-xs text-gray-400">
            Freq: ${spawn.frequency}s, Dur: ${spawn.duration}s
          </div>
        </div>
        <button
          data-action="click->world-editor#deleteSpawn"
          data-id="${spawn.id}"
          class="text-red-400 hover:text-red-300"
        >Delete</button>
      </div>
    `;
    this.spawnListTarget.insertAdjacentHTML("beforeend", html);
  }

  // Helpers
  csrfToken() {
    return document.querySelector("meta[name=\"csrf-token\"]").content;
  }
}
