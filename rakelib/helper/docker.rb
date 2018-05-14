# frozen_string_literal: true

# Interface for docker command line tool
module Docker
  def self.create(name, env, ports, image)
    conf = env.map { |key, value| "-e '#{key}=#{value}'" }.join(' ')
    mapping = ports.map { |key, value| "-p #{key.to_s.to_i}:#{value.to_i}" }.join(' ')
    system "docker create #{conf} #{mapping} --name #{name} #{image}"
  end
  def self.destroy(name)
    system "docker rm #{name}"
  end
  
  def self.pull(image)
    system "docker pull #{image}"
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
    return self.log(name) unless block_given?
    until yield(self.log(name)) do
    end
  end
  def self.exists?(name)
    `docker container ls -a -q -f name=#{name}`.nil?
  end
  def self.running?(name)
    `docker container ls -q -f name=#{name}`.nil?
  end
end
