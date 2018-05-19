# frozen_string_literal: true

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
    system "docker create #{vars} #{ports} --name test-server-#{server} #{image}" unless container_exists?(server)
  end

  def self.uninstall(server)
    name = "test-server-#{server}"
    image = SETUP::WORKBOOK[server][:docker][:image]
    image_id = `docker images -q #{image}`
    stop(server)
    system "docker rm #{name}" if container_exists?(server)
    system "docker rmi #{image_id}" unless image_id.empty?
  end

  def self.start(server)
    return unless container_exists?(server)
    system "docker start test-server-#{server}" unless container_running?(server)
  end

  def self.stop(server)
    return unless container_exists?(server)
    system "docker stop test-server-#{server}" if container_running?(server)
  end

  def self.container_exists?(server)
    `docker container ls -a -q -f name=test-server-#{server}`.size.positive?
  end

  def self.container_running?(server)
    `docker container ls -q -f name=test-server-#{server}`.size.positive?
  end

  def self.num_descendant_of(image)
    `docker ps -a -q --filter ancestor=#{image}`.split("\n").size
  end
end
