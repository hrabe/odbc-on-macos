# frozen_string_literal: true

# helper for odbc ini files
module ODBC
  # helper for source, app or brew installations
  module BINARIES
    # helper for Application installation
    module APP
      def self.install(server)
        puts ">>> App"
      end

      def self.uninstall(server)
        puts ">>> App"
      end
    end

    # helper for Application installation
    module BREW
      def self.install(server)
        puts ">>> Brew"
      end

      def self.uninstall(server)
        puts ">>> Brew"
      end
    end

    # helper for Application installation
    module SOURCE
      def self.install(server)
        puts ">>> Source"
      end

      def self.uninstall(server)
        puts ">>> Source"
      end
    end
  end
end
