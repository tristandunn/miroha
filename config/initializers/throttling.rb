# frozen_string_literal: true

# Limit account creation by IP address to five per minute.
Rack::Attack.throttle("accounts/create", limit: 5, period: 60) do |request|
  if request.post? && request.path == "/accounts"
    request.ip
  end
end

# Limit command creation by account ID and command, with the limit and periods
# defined based on the command.
Rack::Attack.throttle(
  "accounts/command",
  limit:  proc { |request| request.env["miroha.command"].limit },
  period: proc { |request| request.env["miroha.command"].period }
) do |request|
  if request.post? && request.path == "/commands"
    command = request.env["miroha.command"] = Command.parse(request.params["input"])

    [
      request.session["account_id"],
      command.name.delete_prefix("Commands::").underscore
    ].join("/")
  end
end

# Limit signing in by e-mail address to five per minute.
Rack::Attack.throttle("sessions/email", limit: 5, period: 60) do |request|
  if request.post? && request.path == "/sessions"
    email = request.params.dig("session_form", "email")
    email.to_s.downcase.tr(" ", "")
  end
end

# Limit signing in by IP address to one per second.
Rack::Attack.throttle("sessions/ip", limit: 1, period: 1) do |request|
  if request.post? && request.path == "/sessions"
    request.ip
  end
end

# Customize the throttled response.
Rack::Attack.throttled_responder = lambda do |_request|
  [503, {}, ["503 Service Unavailable\n"]]
end
