# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_account,
                  :current_character,
                  :signed_in?,
                  :signed_out?
  end

  # Deny access by redirecting to the root URL.
  #
  # @return [void]
  def access_denied
    redirect_to new_sessions_url
  end

  # Attempt to find an account from the account ID in the session.
  #
  # @return [Account, nil]
  def account_from_session
    if session[:account_id].present?
      Account.find_by(id: session[:account_id])
    end
  end

  # Attempt to find a character from the character ID in the session.
  #
  # @return [Character, nil]
  def character_from_session
    if session[:character_id].present?
      Character.find_by(id: session[:character_id])
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

  # Return the current character, if any.
  #
  # @return [Character, nil]
  def current_character
    if defined?(@current_character)
      @current_character
    else
      @current_character = character_from_session
    end
  end

  # Assign the current character.
  #
  # @param character [Character, nil]
  # @return [void]
  def current_character=(character)
    @current_character     = character
    session[:character_id] = character&.id
  end

  # Determine if a current character is selected.
  #
  # @return [Boolean]
  def current_character?
    current_character.present?
  end

  # Redirect if a character is missing or the character is not active.
  #
  # @return [void]
  def require_active_character
    if current_character.nil?
      redirect_to new_character_url
    elsif current_character.inactive?
      redirect_to characters_url
    end
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
