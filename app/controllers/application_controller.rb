# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include BasicAuthentication
end
