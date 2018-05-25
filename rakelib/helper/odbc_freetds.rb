# frozen_string_literal: true

# helper for odbc ini files
module ODBC
  # helper for FreeTDS server (un)install
  module FREETDS
    def self.install(server, name, filename)
      ODBC.swap_files('~/.freetds.conf', '~/.odbc.ini')
      IO.write(
        filename,
        ODBC.file_content(name, SETUP::WORKBOOK[server][:odbc][:freetds])
      )
      system "odbcinst -i -s -h -f #{ROOT_DIR}/#{filename}"
      ODBC.swap_files('~/.freetds.conf', '~/.odbc.ini')
    end

    def self.uninstall(name)
      ODBC.swap_files('~/.freetds.conf', '~/.odbc.ini')
      system "odbcinst -u -s -h -n '#{name}'"
      ODBC.swap_files('~/.freetds.conf', '~/.odbc.ini')
    end
  end
end
