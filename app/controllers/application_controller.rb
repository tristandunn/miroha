# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include BasicAuthentication

  allow_browser versions: :modern
end
