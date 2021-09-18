# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_account,
                  :signed_in?,
                  :signed_out?
  end

  # Deny access by redirecting to the root URL.
  #
  # @return [void]
  def access_denied
    redirect_to root_url
  end

  # Attempt to find an account from the account ID in the session.
  #
  # @return [Account, nil]
  def account_from_session
    if session[:account_id].present?
      Account.find_by(id: session[:account_id])
    end
  end

  # Require the user be authenticated, otherwise deny access.
  #
  # @return [void]
  def authenticate
    access_denied if signed_out?
  end

  # Return the current account, if any.
  #
  # @return [Account, nil]
  def current_account
    if defined?(@current_account)
      @current_account
    else
      @current_account = account_from_session
    end
  end

  # Assign the current account.
  #
  # @param account [Account, nil]
  # @return [void]
  def current_account=(account)
    @current_account     = account
    session[:account_id] = account&.id
  end

  # Determine if an account is signed in.
  #
  # @return [Boolean]
  def signed_in?
    current_account.present?
  end

  # Determine if an account is not signed in.
  #
  # @return [Boolean]
  def signed_out?
    current_account.nil?
  end
end
