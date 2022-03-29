# frozen_string_literal: true

require "rufus-scheduler"

Rufus::Scheduler.singleton.tap do |schedule|
  schedule.every("1m", name: "Activate spawns.") do
    Clock::ActivateSpawns.call
  end

  schedule.every("1m", name: "Expire spawns.") do
    Clock::ExpireSpawns.call
  end

  schedule.every("1m", name: "Sign out inactive characters.") do
    Clock::SignOutInactiveCharacters.call
  end
end
