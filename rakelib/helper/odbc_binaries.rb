# frozen_string_literal: true

# helper for odbc ini files
module ODBC
  # helper for source, app or brew installations
  module BINARIES
    # helper for Application installation
    module APP
      def self.install(server)
        puts '>>> App'
      end

      def self.uninstall(server)
        puts '>>> App'
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
          system "mkdir -p #{target}"
          system "tar xvzf #{file} -C #{target}"
        when '.zip'
          system "unzip #{file} -d #{target}"
        else
          raise 'unknown unkompress'
        end
      end

      def self.delete(target)
        system "rm -rf #{target}"
      end

      def self.symlink_lib(file)
        system "ln -s #{file} /usr/local/lib"
      end

      def self.unlink_lib(file)
        system "rm /usr/local/lib/#{File.basename(file)}"
      end

      def self.build(server)
        p "build: #{server}"
      end

      def self.install(server)
        puts '>>> Source'
        source = SETUP::WORKBOOK[server][:odbc][:binaries][:source]
        return unless source
        source[:files].each do |file|
          uncompress("#{ROOT_DIR}/binaries/source/#{file}", source[:target])
        end
        build(server) if source[:build]
        source[:symlinks].each { |file| symlink_lib(file) }
      end

      def self.uninstall(server)
        puts '>>> Source'
        source = SETUP::WORKBOOK[server][:odbc][:binaries][:source]
        return unless source
        source[:symlinks].each { |file| unlink_lib(file) }
        delete(source[:target])
      end
    end
  end
end
