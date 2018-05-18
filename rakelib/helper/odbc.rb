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

  def self.install_driver(server, name, filename)
    IO.write(
      filename,
      ODBC.file_content("Driver_#{name}", SETUP::WORKBOOK[server][:odbc][:driver])
    )
    system "odbcinst -i -d -f #{ROOT_DIR}/#{filename}"
  end

  def self.install_dsn(server, name, filename)
    IO.write(
      filename,
      ODBC.file_content("DSN_#{name}", SETUP::WORKBOOK[server][:odbc][:dsn])
    )
    system "odbcinst -i -s -h -f #{ROOT_DIR}/#{filename}"
  end

  def self.install_freetds(server, name, filename)
    swap_files('~/.freetds.conf', '~/.odbc.ini')
    IO.write(
      filename,
      ODBC.file_content(name, SETUP::WORKBOOK[server][:odbc][:freetds])
    )
    system "odbcinst -i -s -h -f #{ROOT_DIR}/#{filename}"
    swap_files('~/.freetds.conf', '~/.odbc.ini')
  end

  def self.uninstall_driver(name)
    system "odbcinst -u -d -n 'Driver_#{name}'"
  end

  def self.uninstall_dsn(name)
    system "odbcinst -u -s -h -n 'DSN_#{name}'"
  end

  def self.uninstall_freetds(name)
    swap_files('~/.freetds.conf', '~/.odbc.ini')
    system "odbcinst -u -s -h -n '#{name}'"
    swap_files('~/.freetds.conf', '~/.odbc.ini')
  end
end
