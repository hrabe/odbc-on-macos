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
      def self.uncompress(file, target)
        case File.extname(file)
        when '.gz'
          p "tar xvzf #{file} -C #{target}"
        when '.zip'
          p "unzip #{file} -d #{target}"
        else
          raise 'unknown unkompress'
        end
      end
      
      def self.install(server)
        puts ">>> Source"
        source = SETUP::WORKBOOK[server][:odbc][:binaries][:source]
        return unless source
        files = source[:files].map{ |file| "#{ROOT_DIR}/binaries/source/#{file}" }
        target = source[:target]
        symlinks = source[:symlinks]
        # TODO: unpack (unzip or tar) to target location
        files.each { |file| uncompress(file, target) }
        # TODO: build if required
        p source[:build] ? "YES" : "NO"
        # TODO: symlink build results or binaries
        symlinks.each do |symlink|
          p "ln -s #{symlink} /usr/local/lib"
        end
      end

      def self.uninstall(server)
        puts ">>> Source"
        source = SETUP::WORKBOOK[server][:odbc][:binaries][:source]
        return unless source
        target = source[:target]
        symlinks = source[:symlinks]
        # TODO: unlink build results or binaries
        symlinks.each do |symlink|
          p "rm /usr/local/lib/#{File.basename(symlink)}"
        end
        # TODO: erase the traget location
        p "rm -rf #{target}"
      end
    end
  end
end
