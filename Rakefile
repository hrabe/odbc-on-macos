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
  ODBC.install_freetds(:mssql, SETUP::WORKBOOK[:mssql][:odbc][:dsn][:Servername].to_s, f.name)
end

SETUP::WORKBOOK[:names].each_pair do |server, name|
  file "pkg/#{server}.odbcinst.ini" => [:dependencies, 'pkg'] do |f|
    ODBC.install_driver(server, name, f.name)
  end

  file "pkg/#{server}.odbc.ini" => [:dependencies, 'pkg'] do |f|
    ODBC.install_dsn(server, name, f.name)
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
    task server do # TODO: deps to existing container
      DOCKER.start(server)
    end
  end
end

namespace :stop do
  SETUP::WORKBOOK[:names].each_pair do |server, name|
    desc "Stop #{name} Server"
    task server do # TODO: deps to existing container
      DOCKER.stop(server)
    end
  end
end

namespace :uninstall do
  SETUP::WORKBOOK[:names].each_pair do |server, name|
    desc "Uninstall #{name} Server"
    task server do
      DOCKER.uninstall(server)
      ODBC.uninstall_driver(name)
      ODBC.uninstall_dsn(name)
      next unless server == :mssql
      ODBC.uninstall_freetds(SETUP::WORKBOOK[server][:odbc][:dsn][:Servername].to_s)
    end
  end

  desc 'Uninstall all Server'
  task :all => SETUP::WORKBOOK[:names].keys
end
