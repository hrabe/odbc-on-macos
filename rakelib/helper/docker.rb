# frozen_string_literal: true

require 'timeout'

# helper for docker commands
module DOCKER
  def self.to_vars_string(server)
    SETUP::WORKBOOK[server][:docker][:environment].map { |h| "-e '#{h.to_a.join('=')}'" }.join(' ')
  end

  def self.to_ports_string(server)
    SETUP::WORKBOOK[server][:docker][:ports].map { |h| "-p #{h.values.join(':')}" }.join(' ')
  end

  def self.privileged?(server)
    SETUP::WORKBOOK[server][:docker][:privileged] || false
  end

  def self.install(server)
    image = pull(server)
    return if container_exists?(server)
    vars = to_vars_string(server)
    privileged = privileged?(server) ? '--privileged ' : ''
    ports = to_ports_string(server)
    name = container_name(server)
    system "docker create #{privileged}#{vars} #{ports} --name #{name} #{image}"
  end

  def self.uninstall(server)
    image = SETUP::WORKBOOK[server][:docker][:image]
    image_id = `docker images -q #{image}`
    stop(server)
    system "docker rm #{container_name(server)}" if container_exists?(server)
    system "docker rmi #{image_id}" unless image_id.empty? || num_descendant_of(image).positive?
  end

  def self.pull(server)
    image = SETUP::WORKBOOK[server][:docker][:image]
    system "docker pull #{image}"
    image
  end

  def self.start(server)
    return unless container_exists?(server)
    system "docker start #{container_name(server)}" unless container_running?(server)
    wait_for_dbms(server)
  end

  def self.stop(server)
    return unless container_exists?(server)
    system "docker stop #{container_name(server)}" if container_running?(server)
  end

  def self.container_name(server)
    "test-server-#{server}"
  end

  def self.container_exists?(server)
    `docker container ls -a -q -f name=#{container_name(server)}`.size.positive?
  end

  def self.container_running?(server)
    `docker container ls -q -f name=#{container_name(server)}`.size.positive?
  end

  def self.num_descendant_of(image)
    `docker ps -a -q --filter ancestor=#{image}`.split("\n").size
  end

  def self.wait_for_dbms(server)
    name = SETUP::WORKBOOK[:names][server]
    user = SETUP::WORKBOOK[server][:odbc][:dsn][:User]
    pass = SETUP::WORKBOOK[server][:odbc][:dsn][:Password]
    Timeout.timeout(10) do
      loop do
        `isql DSN_#{name} #{user} '#{pass}' -v -b < /dev/null 2>&1`
        break if $?.to_i.zero?
      end
    end
  rescue Timeout::Error # rubocop: disable Lint/HandleExceptions
  end
end
