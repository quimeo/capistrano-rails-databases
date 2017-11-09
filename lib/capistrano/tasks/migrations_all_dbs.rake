require 'byebug'
require 'yaml'
load File.expand_path("../set_rails_env.rake", __FILE__)

namespace :deploy do

  def get_all_env host
    yml_file = "#{fetch :deploy_to}/shared/config/database.yml"
    # puts "get_all_env/yml_file\t(#{yml_file})"

    cmd = "ssh #{host} \"cat #{yml_file}\""
    # puts cmd
    envs = YAML.load(`#{cmd}`)
  end

  desc 'Runs rake db:migrate_all_dbs if migrations are set'
  task :migrate_all_dbs => [:set_rails_env] do
    on fetch(:migration_servers) do
      conditionally_migrate = fetch(:conditionally_migrate)
      info '[deploy:migrate_all_dbs] Checking changes in db' if conditionally_migrate
      if conditionally_migrate && test(:diff, "-qr #{release_path}/db #{current_path}/db")
        info '[deploy:migrate_all_dbs] Skip `deploy:migrate_all_dbs` (nothing changed in db)'
      else
        info '[deploy:migrate_all_dbs] Run `rake db:migrate_all_dbs`'
        # NOTE: We access instance variable since the accessor was only added recently. Once capistrano-rails depends on rake 11+, we can revert the following line
        invoke :'deploy:migrating_all_dbs' unless Rake::Task[:'deploy:migrating_all_dbs'].instance_variable_get(:@already_invoked)
      end
    end
  end

  desc 'Runs rake db:migrate'
  task migrating_all_dbs: [:set_rails_env] do
    colors = SSHKit::Color.new($stderr)
    on roles :all do |host|
      info "Task migrating_all_dbs is invoked for #{host}"
      envs = get_all_env host
      envs.each do |rails_env|
        on fetch(:migration_servers) do
          # puts fetch(:migration_servers)
          within release_path do
            with rails_env: rails_env.first do
              info colors.colorize("Migration for\t\t\t#{rails_env.first}", :cyan)
              execute :rake, 'db:migrate'
            end
          end
        end
      end
    end
  end

  after 'deploy:updated', 'deploy:migrate_all_dbs'
end

namespace :load do
  task :defaults do
    set :conditionally_migrate,           fetch(:conditionally_migrate, false)
    set :migration_role,                  fetch(:migration_role, :db)
    set :migration_servers, -> { primary( fetch(:migration_role)) }
  end
end
