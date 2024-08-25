# frozen_string_literal: true

# rubocop:disable Rails/Output

class KillBasementRats < KeywordMachine
  state :initial
  state :accepted, :waiting, :success, :finished, :again
  state :declined, :tomorrow

  transition from: :initial,  to: %i(accepted declined)
  transition from: :accepted, to: [:waiting]
  transition from: :declined, to: [:tomorrow]
  transition from: :waiting,  to: [:success]
  transition from: :success,  to: [:finished]
  transition from: :finished, to: [:again]
  transition from: :again,    to: %i(accepted declined)

  keyword "yes", from: :initial, to: :accepted
  keyword "no",  from: :initial, to: :declined
  keyword "*",   method: :unknown

  # Respond to unknown keywords.
  #
  # @return [void]
  def unknown
    puts "What?"
  end
end

pp KillBasementRats.states
pp KillBasementRats.successors

machine = KillBasementRats.new
puts "Current State: #{machine.current_state}"

puts "Process yes"
machine.process("Yes, let's do it.")
puts "Current State: #{machine.current_state}"

machine = KillBasementRats.new
puts "\nCurrent State: #{machine.current_state}"

puts "Process no"
machine.process("I don't think so. No thanks.")
puts "Current State: #{machine.current_state}"

machine = KillBasementRats.new
puts "\nCurrent State: #{machine.current_state}"

puts "Process unknown"
machine.process("Hello?")
puts "Current State: #{machine.current_state}"

# rubocop:enable Rails/Output
