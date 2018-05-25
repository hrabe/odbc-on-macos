# frozen_string_literal: true

ROOT_DIR = __dir__

require 'rake/clean'
require_relative 'rakelib/helper/setup'
require_relative 'rakelib/helper/docker'
require_relative 'rakelib/helper/odbc'

directory 'pkg/server'
CLOBBER << 'pkg'

task :dependencies do
  SETUP.check_dependencies
end

file 'pkg/freetds.conf' => [:dependencies, 'pkg'] do |f|
  ODBC::FREETDS.install(:mssql, SETUP::WORKBOOK[:mssql][:odbc][:dsn][:Servername].to_s, f.name)
end

SETUP::WORKBOOK[:names].each_pair do |server, name|
  file "pkg/#{server}.odbcinst.ini" => [:dependencies, 'pkg'] do |f|
    ODBC::DRIVER.install(server, name, f.name)
  end

  file "pkg/#{server}.odbc.ini" => [:dependencies, 'pkg'] do |f|
    ODBC::DSN.install(server, name, f.name)
  end
end

namespace :install do
  SETUP::WORKBOOK[:names].each_pair do |server, name|
    deps = [:dependencies, "pkg/#{server}.odbcinst.ini", "pkg/#{server}.odbc.ini"]
    deps << 'pkg/freetds.conf' if server == :mssql
    desc "Install #{name} Server"
    task server => deps do
      DOCKER.install(server)
    end
  end

  desc 'Install all Server'
  task :all => SETUP::WORKBOOK[:names].keys
end

namespace :start do
  SETUP::WORKBOOK[:names].each_pair do |server, name|
    desc "Start #{name} Server"
    task server do
      DOCKER.start(server)
    end
  end

  desc 'Start all Server'
  task :all => SETUP::WORKBOOK[:names].keys
end

namespace :stop do
  SETUP::WORKBOOK[:names].each_pair do |server, name|
    desc "Stop #{name} Server"
    task server do
      DOCKER.stop(server)
    end
  end

  desc 'Stop all Server'
  task :all => SETUP::WORKBOOK[:names].keys
end

namespace :test do
  SETUP::WORKBOOK[:names].each_pair do |server, name|
    desc "Test #{name} Server connection"
    task server do
      user = SETUP::WORKBOOK[server][:odbc][:dsn][:User]
      pass = SETUP::WORKBOOK[server][:odbc][:dsn][:Password]
      print ">>> Test #{name} Server connection: "
      res = `isql DSN_#{name} #{user} '#{pass}' -v -b < /dev/null 2>&1`
      puts res.empty? ? 'success.' : res.split("\n").join("\n    ")
    end
  end

  desc 'Test all Server connections'
  task :all => SETUP::WORKBOOK[:names].keys
end

namespace :uninstall do
  SETUP::WORKBOOK[:names].each_pair do |server, name|
    desc "Uninstall #{name} Server"
    task server do
      DOCKER.uninstall(server)
      ODBC::DRIVER.uninstall(name)
      ODBC::DSN.uninstall(name)
      next unless server == :mssql
      ODBC::FREETDS.uninstall(SETUP::WORKBOOK[server][:odbc][:dsn][:Servername].to_s)
    end
  end

  desc 'Uninstall all Server'
  task :all => SETUP::WORKBOOK[:names].keys
end
