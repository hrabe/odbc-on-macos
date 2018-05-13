require_relative 'helper/docker'

namespace :mssql do
  namespace :server do
    SERVER_NAME = 'test-server-mssql'
    IMAGE_NAME = 'microsoft/mssql-server-linux:latest'
    
    desc 'pull docker image'
    task :pull do
      print 'pull docker image: '
      Docker.pull(IMAGE_NAME)
    end

    desc 'create docker container'
    task :create do
      print 'create docker container: '
      Docker.create(
        SERVER_NAME,
        {
          'ACCEPT_EULA': 'Y',
          'SA_PASSWORD': 'yourStrong(!)Password',
          'MSSQL_PID': 'Developer',
          'no_proxy': '*.local, 169.254/16'
        },
        { '1433': '1433' },
        IMAGE_NAME
      )
    end

    desc 'start docker container'
    task :start do
      print 'start docker container: '
      Docker.start(SERVER_NAME)
      Docker.log_with(SERVER_NAME) do |log|
        print '.'
        !log.match('Service Broker manager has started.').nil?
      end
      puts ' accepts connections now.'
    end

    desc 'stop docker container'
    task :stop do
      print 'stop docker container: '
      Docker.stop(SERVER_NAME)
    end

    desc 'destroy docker container'
    task :destroy => [:stop] do
      print 'destroy docker container: '
      Docker.destroy(SERVER_NAME)
    end
  end
end
