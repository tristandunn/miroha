# frozen_string_literal: true

Rufus::Scheduler.singleton.tap do |schedule|
  %w(INT TERM).each do |signal|
    handler = Signal.trap(signal) do
      schedule.shutdown(
        wait: ENV.fetch("CLOCK_SHUTDOWN_WAIT_SECONDS", 29).to_i
      )

      if handler.respond_to?(:call)
        handler.call
      else
        exit
      end
    end
  end

  schedule.join
end
