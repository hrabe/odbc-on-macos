# frozen_string_literal: true

require 'yaml'

# Helper for setup.yml workbook
module SETUP
  def self.symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), result|
      result[key.to_sym] = value
      result[key.to_sym] = symbolize_keys(value) if value.is_a?(Hash)
      next unless value.is_a?(Array)
      result[key.to_sym] = value.map do |e|
        e.is_a?(Hash) ? symbolize_keys(e) : e
      end
    end
  end

  def self.check_dependencies
    WORKBOOK[:dependencies].each_pair do |_, command|
      puts `#{command}`.split("\n").first
    end
  end

  WORKBOOK ||= symbolize_keys(YAML.load_file("#{ROOT_DIR}/setup.yml"))
end
