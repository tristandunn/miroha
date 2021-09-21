# frozen_string_literal: true

Room.find_or_initialize_by(x: 0, y: 0, z: 0).tap do |room|
  room.update(description: "The street is dusty and unkept.")
end
