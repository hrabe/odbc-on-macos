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
    system "docker create #{vars} #{ports} --name test-server-#{server} #{image}"
  end

  def self.uninstall(server)
    name = "test-server-#{server}"
    image = SETUP::WORKBOOK[server][:docker][:image]
    image_id = `docker images -q #{image}`
    system "docker rm #{name}"
    system "docker rmi #{image_id}" unless image_id.empty?
  end
  
  def self.start(server)
    system "docker start test-server-#{server}"
  end
  
  def self.stop(server)
    system "docker stop test-server-#{server}"
  end
end
