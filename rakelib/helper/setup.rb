# frozen_string_literal: true

require 'yaml'
require 'pp'

# Helper for setup.yml workbook
module SETUP
  def self.symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), result|
      result[key.to_sym] = value
      result[key.to_sym] = symbolize_keys(value) if value.is_a?(Hash)
      next unless value.is_a?(Array)
      result[key.to_sym] = value.map do |e|
        e.is_a?(Hash) ? symbolize_keys(e) : e
      end
    end
  end

  def self.check_dependencies
    WORKBOOK[:dependencies].each_pair do |_, command|
      puts `#{command}`.split("\n").first
    end
  end

  WORKBOOK ||= symbolize_keys(YAML.load_file("#{ROOT_DIR}/setup.yml"))
end

# helper for docker commands
module DOCKER
  def self.to_vars_string(hash)
    hash.map { |h| "-e '#{h.to_a.join('=')}'" }.join(' ')
  end

  def self.to_ports_string(hash)
    hash.map { |h| "-p #{h.values.join(':')}" }.join(' ')
  end

  def self.install(server)
    vars = to_vars_string(SETUP::WORKBOOK[server][:docker][:environment])
    ports = to_ports_string(SETUP::WORKBOOK[server][:docker][:ports])
    image = SETUP::WORKBOOK[server][:docker][:image]
    system "docker pull #{image}"
    system "docker create #{vars} #{ports} --name test-server-#{server} #{image}"
  end

  def self.uninstall(server)
    name = "test-server-#{server}"
    image = SETUP::WORKBOOK[server][:docker][:image]
    image_id = `docker images -q #{image}`
    system "docker rm #{name}"
    system "docker rmi #{image_id}" unless image_id.empty?
  end
end

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
      ODBC.file_content("#{name} Driver", SETUP::WORKBOOK[server][:odbc][:driver])
    )
    system "odbcinst -i -d -f #{ROOT_DIR}/#{filename}"
  end

  def self.install_dsn(server, name, filename)
    IO.write(
      filename,
      ODBC.file_content("#{name} DSN", SETUP::WORKBOOK[server][:odbc][:dsn])
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
    system "odbcinst -u -d -n '#{name} Driver'"
  end

  def self.uninstall_dsn(name)
    system "odbcinst -u -s -h -n '#{name} DSN'"
  end

  def self.uninstall_freetds(name)
    swap_files('~/.freetds.conf', '~/.odbc.ini')
    system "odbcinst -u -s -h -n '#{name}'"
    swap_files('~/.freetds.conf', '~/.odbc.ini')
  end
end

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
