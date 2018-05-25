# frozen_string_literal: true

# helper for odbc ini files
module ODBC
  # helper for data source name (un)install
  module DSN
    def self.install(server, name, filename)
      IO.write(
        filename,
        ODBC.file_content("DSN_#{name}", SETUP::WORKBOOK[server][:odbc][:dsn])
      )
      system "odbcinst -i -s -h -f #{ROOT_DIR}/#{filename}"
    end

    def self.uninstall(name)
      system "odbcinst -u -s -h -n 'DSN_#{name}'"
    end
  end
end
