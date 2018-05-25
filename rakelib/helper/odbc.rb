# frozen_string_literal: true

# helper for odbc ini files
module ODBC
  def self.swap_files(file_a, file_b)
    system "touch #{file_a}"
    system "touch #{file_b}"
    system "mv #{file_a} #{file_a}.tmp"
    system "mv #{file_b} #{file_a}"
    system "mv #{file_a}.tmp #{file_b}"
  end

  def self.file_content(section, mapping)
    (["[#{section}]"] + mapping.map { |k, v| "#{k}= #{v}" }).join("\n")
  end
end
