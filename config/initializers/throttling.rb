# frozen_string_literal: true

# Limit account creation by IP address to five per minute.
Rack::Attack.throttle("accounts/create", limit: 5, period: 60) do |request|
  if request.post? && request.path == "/accounts"
    request.ip
  end
end

# Limit command creation by account ID to 10 every five seconds.
Rack::Attack.throttle("accounts/command", limit: 10, period: 5) do |request|
  if request.post? && request.path == "/commands"
    request.session["account_id"]
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
Rack::Attack.throttled_response = lambda do |_request|
  [503, {}, ["503 Service Unavailable\n"]]
end
