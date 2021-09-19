# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_authenticated_account, if: :signed_in?

  # Display the session form.
  def new
    @form = SessionForm.new
  end

  # Attempt to create a session from the provided parameters.
  #
  # If successful redirect, otherwise render the session form.
  def create
    @form = SessionForm.new(session_parameters)

    if @form.valid?
      self.current_account = @form.account

      redirect_authenticated_account
    else
      render :new
    end
  end

  protected

  # Redirect to the character list.
  #
  # @return [void]
  def redirect_authenticated_account
    redirect_to characters_url
  end

  # Return the permitted parameters from the required session parameter.
  #
  # @return [ActionController::Parameters]
  def session_parameters
    params.require(:session_form).permit(:email, :password)
  end
end
