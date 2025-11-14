import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["svg"]
  static values = {
    currentX: Number,
    currentY: Number,
    currentZ: Number,
    currentExists: Boolean,
    northExists: Boolean,
    southExists: Boolean,
    eastExists: Boolean,
    westExists: Boolean,
    upExists: Boolean,
    downExists: Boolean
  }

  connect() {
    this.renderGrid()
  }

  renderGrid() {
    const svg = this.svgTarget
    svg.innerHTML = "" // Clear existing content

    // Room positions in SVG coordinates
    const positions = {
      center: { x: 400, y: 300 },
      north: { x: 400, y: 150 },
      south: { x: 400, y: 450 },
      east: { x: 550, y: 300 },
      west: { x: 250, y: 300 },
      up: { x: 600, y: 150 },
      down: { x: 600, y: 450 }
    }

    // Room coordinates relative to current room
    const rooms = {
      center: { x: this.currentXValue, y: this.currentYValue, z: this.currentZValue },
      north: { x: this.currentXValue, y: this.currentYValue + 1, z: this.currentZValue },
      south: { x: this.currentXValue, y: this.currentYValue - 1, z: this.currentZValue },
      east: { x: this.currentXValue + 1, y: this.currentYValue, z: this.currentZValue },
      west: { x: this.currentXValue - 1, y: this.currentYValue, z: this.currentZValue },
      up: { x: this.currentXValue, y: this.currentYValue, z: this.currentZValue + 1 },
      down: { x: this.currentXValue, y: this.currentYValue, z: this.currentZValue - 1 }
    }

    // Room existence data from server
    const roomData = {
      center: this.currentExistsValue,
      north: this.northExistsValue,
      south: this.southExistsValue,
      east: this.eastExistsValue,
      west: this.westExistsValue,
      up: this.upExistsValue,
      down: this.downExistsValue
    }

    // Draw connections first (so they appear behind rooms)
    this.drawConnections(svg, positions, roomData)

    // Draw rooms
    Object.entries(positions).forEach(([direction, pos]) => {
      const room = rooms[direction]
      const exists = roomData[direction]
      this.drawRoom(svg, pos, direction, room, exists)
    })
  }

  drawConnections(svg, positions, roomData) {
    const connections = [
      { from: "center", to: "north", exists: roomData.center && roomData.north },
      { from: "center", to: "south", exists: roomData.center && roomData.south },
      { from: "center", to: "east", exists: roomData.center && roomData.east },
      { from: "center", to: "west", exists: roomData.center && roomData.west },
      { from: "center", to: "up", exists: roomData.center && roomData.up },
      { from: "center", to: "down", exists: roomData.center && roomData.down }
    ]

    connections.forEach(conn => {
      if (conn.exists) {
        const line = document.createElementNS("http://www.w3.org/2000/svg", "line")
        line.setAttribute("x1", positions[conn.from].x)
        line.setAttribute("y1", positions[conn.from].y)
        line.setAttribute("x2", positions[conn.to].x)
        line.setAttribute("y2", positions[conn.to].y)
        line.setAttribute("stroke", "#4B5563")
        line.setAttribute("stroke-width", "2")
        svg.appendChild(line)
      }
    })
  }

  drawRoom(svg, position, direction, coords, exists) {
    const isCurrent = direction === "center"
    const size = isCurrent ? 100 : 80

    // Create room group
    const group = document.createElementNS("http://www.w3.org/2000/svg", "g")
    group.setAttribute("cursor", "pointer")
    group.dataset.direction = direction
    group.dataset.x = coords.x
    group.dataset.y = coords.y
    group.dataset.z = coords.z

    // Room rectangle
    const rect = document.createElementNS("http://www.w3.org/2000/svg", "rect")
    rect.setAttribute("x", position.x - size / 2)
    rect.setAttribute("y", position.y - size / 2)
    rect.setAttribute("width", size)
    rect.setAttribute("height", size)
    rect.setAttribute("rx", "8")

    if (exists) {
      rect.setAttribute("fill", isCurrent ? "#3B82F6" : "#1F2937")
      rect.setAttribute("stroke", isCurrent ? "#60A5FA" : "#4B5563")
      rect.setAttribute("stroke-width", "2")
    } else {
      rect.setAttribute("fill", "none")
      rect.setAttribute("stroke", "#374151")
      rect.setAttribute("stroke-width", "2")
      rect.setAttribute("stroke-dasharray", "4")
    }

    group.appendChild(rect)

    // Room label
    const text = document.createElementNS("http://www.w3.org/2000/svg", "text")
    text.setAttribute("x", position.x)
    text.setAttribute("y", position.y - 10)
    text.setAttribute("text-anchor", "middle")
    text.setAttribute("fill", "#D1D5DB")
    text.setAttribute("font-size", "14")
    text.setAttribute("pointer-events", "none")
    text.textContent = `${coords.x}, ${coords.y}, ${coords.z}`
    group.appendChild(text)

    // Direction label (skip for center room)
    if (!isCurrent) {
      const dirLabel = document.createElementNS("http://www.w3.org/2000/svg", "text")
      dirLabel.setAttribute("x", position.x)
      dirLabel.setAttribute("y", position.y + 10)
      dirLabel.setAttribute("text-anchor", "middle")
      dirLabel.setAttribute("fill", "#9CA3AF")
      dirLabel.setAttribute("font-size", "14")
      dirLabel.setAttribute("font-weight", "bold")
      dirLabel.setAttribute("pointer-events", "none")
      dirLabel.textContent = direction.toUpperCase()
      group.appendChild(dirLabel)
    }

    // Click handler
    group.addEventListener("click", () => this.handleRoomClick(coords, exists))

    svg.appendChild(group)
  }

  handleRoomClick(coords, exists) {
    if (exists) {
      // Navigate to existing room
      window.location.href = `/world_editor?x=${coords.x}&y=${coords.y}&z=${coords.z}`
    } else {
      // Create new room
      if (confirm(`Create room at (${coords.x}, ${coords.y}, ${coords.z})?`)) {
        this.createRoom(coords)
      }
    }
  }

  async createRoom(coords) {
    try {
      const response = await fetch("/api/rooms", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          room: {
            x: coords.x,
            y: coords.y,
            z: coords.z,
            description: "A new room."
          }
        })
      })

      if (response.ok) {
        // Navigate to the new room
        window.location.href = `/world_editor?x=${coords.x}&y=${coords.y}&z=${coords.z}`
      } else {
        const data = await response.json()
        alert(`Error creating room: ${data.errors.join(", ")}`)
      }
    } catch (error) {
      alert(`Error creating room: ${error.message}`)
    }
  }
}
