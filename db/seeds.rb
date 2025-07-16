# frozen_string_literal: true

Room.find_or_initialize_by(x: 0, y: 0, z: 0).tap do |room|
  room.update(
    description: <<~DESCRIPTION.squish
      The street is dusty and unkept. There is a small tavern to the west.
    DESCRIPTION
  )
end

Room.find_or_initialize_by(x: -1, y: 0, z: 0).tap do |room|
  room.update(
    description: <<~DESCRIPTION.squish,
      You enter a small, mostly empty tavern. It's as dreary inside as it is on
      the outside. Wooden beams support the upper floor and the sconces
      attached to them. The walls are decorated, if you can call it that, with
      old paintings covered in dust. A small window provides a view of the
      street to the east.
    DESCRIPTION
    objects:     {
      "paintings" => <<~DESCRIPTION.squish
        You attempt to squint to see through the dust on the
        paintings but you still can't tell what they are.
      DESCRIPTION
    }
  )

  Item.find_or_create_by(owner: room).tap do |item|
    item.update(name: "Empty Jug")
  end
end

Room.find_or_initialize_by(x: -1, y: 0, z: -1).tap do |room|
  room.update(
    description: <<~DESCRIPTION.squish
      You stumble into the tavern's basement. Old stairs lead up to the
      main room.
    DESCRIPTION
  )

  Monster.find_or_create_by(name: "Rat").tap do |rat|
    rat.update(
      experience:     25,
      event_handlers: ["Monster::Hate"]
    )

    Spawn
      .create_with(
        activates_at: Time.current,
        duration:     nil,
        frequency:    1.minute
      )
      .find_or_create_by(base: rat, room: room)
  end

  Account.find_or_initialize_by(email: "bob@example.com").tap do |account|
    account.update(
      aliases:  I18n.t("account_form.default_aliases"),
      password: "password"
    )

    Character.find_or_create_by!(
      account: account,
      room:    room,
      name:    "Yinohoo"
    ).tap do |character|
      Item.find_or_create_by(owner: character).tap do |item|
        item.update(name: "Shield")
      end
    end
  end
end
