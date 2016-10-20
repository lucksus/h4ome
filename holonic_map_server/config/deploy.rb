# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'h4ms'
set :repo_url, 'git@gitlab.united-earth.vision:noolab/h4ome.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/hms/production'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_files, 'holonic_map_server/config/database.yml', 'holonic_map_server/config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'
set :bundle_gemfile, -> { release_path.join('holonic_map_server/Gemfile') }

after 'deploy:cleanup', 'deploy:restart'

namespace :deploy do
  desc "Migrating the database"
  task :migrate do
    on roles(:app) do
      within "#{current_path}/holonic_map_server" do
        with rails_env: "#{fetch(:stage)}" do
          execute :rake, "db:migrate"
        end
      end
    end
   end
end

after 'deploy:restart', 'deploy:migrate'