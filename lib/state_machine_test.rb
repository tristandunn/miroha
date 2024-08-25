# frozen_string_literal: true

# rubocop:disable Rails/Output
class KillBasementRats < StateMachine
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
end

pp KillBasementRats.states
pp KillBasementRats.successors

machine = KillBasementRats.new

puts "Current State: #{machine.current_state}"

puts "\nTransition to Accepted:"
p machine.transition_to(:accepted)

puts "\nTransition to Decline:"
p machine.transition_to(:declined)

puts "\nTransition to Waiting:"
p machine.transition_to(:waiting)

puts "\nTransition to Success:"
p machine.transition_to(:success)

puts "\nTransition to Finished:"
p machine.transition_to(:finished)

puts "\nTransition to Again:"
p machine.transition_to(:again)

puts "\nTransition to Declined:"
p machine.transition_to(:declined)

puts "\nTransition to Accepted:"
p machine.transition_to(:accepted)

puts "\nTransition to Tomorrow:"
p machine.transition_to(:tomorrow)

# rubocop:enable Rails/Output
