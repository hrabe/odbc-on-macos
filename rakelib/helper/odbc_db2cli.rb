# frozen_string_literal: true

# helper for odbc ini files
module ODBC
  # helper for db2cli.ini (un)install
  module DB2CLI
    def self.install(server, name, filename)
      IO.write(
        filename,
        ODBC.file_content("DSN_#{name}", SETUP::WORKBOOK[server][:odbc][:db2cli])
      )
      target = SETUP::WORKBOOK[server][:odbc][:binaries][:source][:target]
      system "cp #{filename} #{target}/clidriver/cfg"
    end

    def self.uninstall(server)
      target = SETUP::WORKBOOK[server][:odbc][:binaries][:source][:target]
      system "rm #{target}/clidriver/cfg/db2cli.ini"
    end
  end
end
