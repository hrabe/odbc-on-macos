# frozen_string_literal: true

# Interface for docker command line tool
module Docker
  def self.pull(image)
    system "docker pull #{image}"
  end

  def self.rmi(image)
    system "docker rmi $(docker images -q #{image})"
  end

  def self.create(name, env, ports, image)
    conf = env.map { |k, v| "-e '#{k}=#{v}'" }.join(' ')
    mapping = ports.map { |k, v| "-p #{k.to_s.to_i}:#{v.to_i}" }.join(' ')
    system "docker create #{conf} #{mapping} --name #{name} #{image}"
  end

  def self.rm(name)
    system "docker rm #{name}"
  end

  def self.start(name)
    system "docker start #{name}"
  end

  def self.stop(name)
    system "docker stop #{name}"
  end

  def self.log(name)
    `docker logs #{name}`
  end

  def self.log_with(name)
    return log(name) unless block_given?
    until yield(log(name)); end
  end

  def self.exists?(name)
    `docker container ls -a -q -f name=#{name}`.nil?
  end

  def self.running?(name)
    `docker container ls -q -f name=#{name}`.nil?
  end
end
