# frozen_string_literal: true

if defined?(Zhong)
  Zhong.logger = Rails.logger

  Zhong.schedule do
    every(1.minute, "Activate spawns.") do
      Clock::ActivateSpawns.call
    end

    every(1.minute, "Expire spawns.") do
      Clock::ExpireSpawns.call
    end

    every(1.minute, "Sign out inactive characters.") do
      Clock::SignOutInactiveCharacters.call
    end
  end
end
