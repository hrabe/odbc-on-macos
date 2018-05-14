# frozen_string_literal: true

require_relative 'helper/docker'

namespace :mssql do
  namespace :server do
    SERVER_NAME = 'test-server-mssql'
    IMAGE_NAME = 'microsoft/mssql-server-linux:latest'

    desc 'Installs MSSQL Server'
    task :install => ['image:pull', 'container:create']

    desc 'Uninstalls MSSQL Server'
    task :uninstall => ['container:rm', 'image:rmi']

    desc 'Starts MSSQL Server'
    task :start => [:install, 'container:start']

    desc 'Stops MSSQL Server'
    task :stop => [:install, 'container:stop']

    namespace :image do
      desc 'Pull docker image'
      task :pull do
        print 'pull docker image: '
        Docker.pull(IMAGE_NAME)
      end

      desc 'Remove docker image'
      task :rmi do
        print 'Remove docker image: '
        Docker.rmi(IMAGE_NAME)
      end
    end

    namespace :container do
      desc 'Create docker container'
      task :create do
        print 'Create docker container: '
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

      desc 'Start docker container'
      task :start do
        print 'Start docker container: '
        Docker.start(SERVER_NAME)
        Docker.log_with(SERVER_NAME) do |log|
          print '.'
          log.include?('Service Broker manager has started.')
        end
        puts ' accepts connections now.'
      end

      desc 'Stop docker container'
      task :stop do
        print 'Stop docker container: '
        Docker.stop(SERVER_NAME)
      end

      desc 'Destroy docker container'
      task :rm => [:stop] do
        print 'Destroy docker container: '
        Docker.rm(SERVER_NAME)
      end
    end
  end
end
