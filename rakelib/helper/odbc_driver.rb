# frozen_string_literal: true

# helper for odbc ini files
module ODBC
  # helper for driver (un)install
  module DRIVER
    def self.install(server, name, filename)
      IO.write(
        filename,
        ODBC.file_content("Driver_#{name}", SETUP::WORKBOOK[server][:odbc][:driver])
      )
      system "odbcinst -i -d -f #{ROOT_DIR}/#{filename}"
    end

    def self.uninstall(name)
      system "odbcinst -u -d -n 'Driver_#{name}'"
    end
  end
end
