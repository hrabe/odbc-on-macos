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
        brew = SETUP::WORKBOOK[server][:odbc][:binaries][:brew]
        return unless brew
        options = brew.fetch(:options, []).join(' ')
        system "brew install #{brew[:formula]} #{options}"
      end

      def self.uninstall(server)
        brew = SETUP::WORKBOOK[server][:odbc][:binaries][:brew]
        return unless brew
        system "brew uninstall #{brew[:formula]}"
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
