# frozen_string_literal: true

require_relative 'helper/docker'
require_relative 'helper/odbc'

namespace :mssql do
  desc 'Setup MSSQL Server and ODBC'
  task :setup => ['server:install', 'odbc:install']

  desc 'Test MSSQL Server'
  task :test => []

  namespace :server do
    SERVER_NAME = 'test-server-mssql'
    IMAGE_NAME = 'microsoft/mssql-server-linux:latest'

    desc 'Install MSSQL Server'
    task :install => ['image:pull', 'container:create']

    desc 'Uninstall MSSQL Server'
    task :uninstall => ['container:rm', 'image:rmi']

    desc 'Start MSSQL Server'
    task :start => [:install, 'container:start']

    desc 'Stop MSSQL Server'
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

  namespace :odbc do
    desc 'Install the ODBC driver'
    task :install => ['driver:add', 'datasource:add']

    desc 'Uninstall the ODBC driver'
    task :uninstall => ['driver:remove', 'datasource:remove']

    namespace :driver do
      desc 'Add driver to `odbcinst.ini`'
      task :add do
        ODBC::Driver.add('mssql.ini')
        ODBC::FreeTDS.add('freetds.ini')
      end

      desc 'Remove driver from `odbcinst.ini`'
      task :remove do
        ODBC::Driver.remove('FreeTDS Driver')
        ODBC::FreeTDS.remove('MSSQLServer')
      end
    end

    namespace :datasource do
      desc 'Add User DSN to `odbc.ini`'
      task :add do
        ODBC::Datasource.add('mssql.ini')
      end

      desc 'Remove User DNS from `odbc.ini`'
      task :remove do
        ODBC::Datasource.remove('DSN_MSSQL')
      end
    end
  end
end
