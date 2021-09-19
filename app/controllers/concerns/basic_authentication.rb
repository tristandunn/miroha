# frozen_string_literal: true

module BasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :basic_authentication, if: :basic_authentication?
  end

  # Authenticate with basic authentication.
  #
  # @return [void]
  def basic_authentication
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTHENTICATION_USERNAME"] &&
        password == ENV["BASIC_AUTHENTICATION_PASSWORD"]
    end
  end

  # Determine if basic authentication is enabled.
  #
  # @return [Boolean]
  def basic_authentication?
    ENV["BASIC_AUTHENTICATION_USERNAME"].present? &&
      ENV["BASIC_AUTHENTICATION_PASSWORD"].present?
  end
end
