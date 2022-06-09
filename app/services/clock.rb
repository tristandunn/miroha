# frozen_string_literal: true

module Clock
  class << self
    delegate :pause, to: :scheduler
  end

  # Return the single instance of the scheduler.
  #
  # @return [Rufus::Scheduler]
  def self.scheduler
    Rufus::Scheduler.singleton
  end

  # Start the scheduler.
  #
  # @return [void]
  def self.start
    Clock.constants(false).each do |name|
      service = Clock.const_get(name).new

      if service.respond_to?(:call)
        scheduler.every(service.interval, service, name: service.name)
      end
    end
  end

  # Trap signals to shutdown the scheduler and join the thread.
  #
  # @return [void]
  def self.join
    %w(INT TERM).each do |signal|
      Signal.trap(signal) do
        scheduler.shutdown(wait: ENV.fetch("CLOCK_SHUTDOWN_WAIT_SECONDS", 29).to_i)
      end
    end

    scheduler.join
  end
end
