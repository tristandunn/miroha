# frozen_string_literal: true

# :nocov:
class MessagesController < ApplicationController
  layout "game"

  before_action :ensure_development_environment

  # Renders the messages preview page with all discovered message partials.
  #
  # Sets up a character instance with associated data and discovers all message
  # partials in the application for preview purposes.
  #
  # @return [void]
  def index
    @character = Character.includes(:account, :items, room: %i(items monsters)).first
    @partial_data = discover_message_partials.shuffle
  end

  private

  # Ensures this controller only works in development environment.
  #
  # Returns a 404 response if accessed in non-development environments.
  #
  # @return [void]
  def ensure_development_environment
    return if Rails.env.development?

    head :not_found
  end

  # Discovers all message partials in the views directory.
  #
  # Searches through all .html.erb files in the app/views directory
  # and filters for message partials.
  #
  # @return [Array<Hash>] Array of hashes containing partial metadata
  def discover_message_partials
    partial_files = Rails.root.glob("app/views/**/*.html.erb")
    filter_message_partials(partial_files)
  end

  # Filters files to only include message partials.
  #
  # Processes each file to determine if it's a message partial and
  # extracts relevant metadata.
  #
  # @param partial_files [Array<Pathname>] Array of file paths to filter
  # @return [Array<Hash>] Array of processed partial metadata
  def filter_message_partials(partial_files)
    partial_files.filter_map do |file_path|
      process_partial_file(file_path)
    end
  end

  # Processes a single partial file and returns its metadata.
  #
  # Extracts the relative path, partial name, and local variables
  # from a message partial file.
  #
  # @param file_path [Pathname] Path to the partial file
  # @return [Hash, nil] Hash with :path, :name, and :locals keys, or nil if not a message partial
  def process_partial_file(file_path)
    return unless message_partial?(file_path)

    relative_path = file_path.to_s.sub(Rails.root.join("app/views/").to_s, "")
    return if skip_file?(relative_path)

    {
      path:   relative_path,
      name:   convert_to_partial_name(relative_path),
      locals: extract_locals_from_file(file_path)
    }
  end

  # Checks if file contains message partial markup.
  #
  # Looks for the presence of 'data-chat-target="message"' attribute
  # which indicates a message partial.
  #
  # @param file_path [Pathname] Path to the file to check
  # @return [Boolean] true if file contains message partial markup
  def message_partial?(file_path)
    File.read(file_path.to_s).include?('data-chat-target="message"')
  end

  # Determines if file should be skipped.
  #
  # Currently skips the messages preview index file itself.
  #
  # @param relative_path [String] Relative path from app/views
  # @return [Boolean] true if file should be skipped
  def skip_file?(relative_path)
    relative_path.include?("messages/index.html.erb")
  end

  # Converts file path to partial name.
  #
  # Removes .html.erb extension and converts underscore prefixes
  # to forward slashes for proper partial naming.
  #
  # @param relative_path [String] Relative file path
  # @return [String] Partial name suitable for rendering
  def convert_to_partial_name(relative_path)
    relative_path.sub(".html.erb", "").gsub("/_", "/")
  end

  # Extracts local variables from partial file comments.
  #
  # Looks for a special comment format: <%# locals: (var1:, var2:) %>
  # and extracts the variable names.
  #
  # @param file_path [Pathname] Path to the partial file
  # @return [Hash] Hash of local variable names and their stub data
  def extract_locals_from_file(file_path)
    content = File.read(file_path.to_s)
    locals_match = content.match(/<%#\s*locals:\s*\(([^)]*)\)\s*%>/)

    return {} unless locals_match

    parse_locals_string(locals_match[1])
  end

  # Parses the locals string and generates stub data.
  #
  # Extracts parameter names from the locals string and generates
  # appropriate stub data for each parameter using StubDataGenerator.
  #
  # @param locals_string [String] String containing local variable names
  # @return [Hash] Hash mapping parameter names (as symbols) to stub data
  def parse_locals_string(locals_string)
    locals = {}
    locals_string.scan(/(\w+):/) do |match|
      param_name = match[0]
      locals[param_name.to_sym] = StubDataGenerator.generate_stub_data(param_name)
    end
    locals
  end
end
