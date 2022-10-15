# frozen_string_literal: true

Room.find_or_initialize_by(x: 0, y: 0, z: 0).tap do |room|
  room.update(
    description: <<~DESCRIPTION.squish
      The street is dusty and unkept. There is a small tavern to the west.
    DESCRIPTION
  )

  Monster.find_or_create_by(name: "Rat").tap do |rat|
    rat.update(experience: 25)

    Spawn.find_or_create_by(base: rat, room: room).tap do |spawn|
      spawn.update(
        activates_at: Time.current,
        duration:     nil,
        frequency:    1.minute
      )
    end
  end
end

Room.find_or_initialize_by(x: -1, y: 0, z: 0).tap do |room|
  room.update(
    description: <<~DESCRIPTION.squish
      You enter a small, mostly empty tavern. It's as dreary inside as it is on
      the outside. Wooden beams support the upper floor and the sconces
      attached to them. The walls are decorated, if you can call it that, with
      old paintings covered in dust. A small window provides a view of the
      street to the east.
    DESCRIPTION
  )
end

Room.find_or_initialize_by(x: -1, y: 0, z: -1).tap do |room|
  room.update(
    description: <<~DESCRIPTION.squish
      You stumble into the tavern's basement. Old stairs lead up to the
      main room.
    DESCRIPTION
  )
end
