# frozen_string_literal: true

require 'inifile'

# ODBC managment helper
module ODBC
  # odbcinst command line tool for drivers
  module Driver
    def self.add(filename)
      system "odbcinst -i -d -f #{template(filename)}"
    end

    def self.remove(name)
      system "odbcinst -u -d -n '#{name}'"
    end

    def self.template(filename)
      File.expand_path("#{__dir__}/../../templates/driver/#{filename}")
    end
  end

  # odbcinst command line tool for data sources
  module Datasource
    def self.add(filename)
      system "odbcinst -i -s -h -f #{template(filename)}"
    end

    def self.remove(name)
      system "odbcinst  -u -s -h -n '#{name}'"
    end

    def self.template(filename)
      File.expand_path("#{__dir__}/../../templates/datasource/#{filename}")
    end
  end

  # freetds.conf modification (like odbcinst tool)
  module FreeTDS
    def self.add(filename)
      conf = IniFile.load(conf_file)
      template = IniFile.load(ODBC::Driver.template(filename))
      conf.merge!(template)
      conf.save
    end

    def self.remove(name)
      conf = IniFile.load(conf_file)
      conf.delete_section(name)
      conf.save
    end

    def self.conf_file
      "#{`tsql -C`.match(/freetds.conf directory: (.*)/)[1]}/freetds.conf"
    end
  end
end
