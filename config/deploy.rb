#############################################################
#	Multistaging
#############################################################

set :application, "myfunnydev.info"
set :application_path, "/var/www/#{application}"
set :default_stage, "testing"
set :stages, %w(production testing development)
require 'capistrano/ext/multistage'

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, true
 
#############################################################
#	Servers
#############################################################
 
set :user, "deploy"
set :domain, "97.107.132.58"
set :port, 23456
server domain, :app, :web
role :db, domain, :primary => true
set :runner, "deploy"
 
#############################################################
#	GIT
#############################################################
 
set :repository,  "git://github.com/vimdev/myfunnydev.git"
set :scm, "git"
set :scm_passphrase, "learnordie" #This is your custom github user password
ssh_options[:forward_agent] = true
set :branch, "master"
#set :deploy_via, :remote_cache

# =============================================================================
# SSH OPTIONS
# =============================================================================

default_run_options[:pty] = true
ssh_options[:paranoid] = false
ssh_options[:keys] = %w(/Users/michalkuklis/.ssh/id_dsa)
ssh_options[:port] = 23456

#############################################################
#	Passenger
#############################################################
 
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  after "deploy:update_code", :link_db_logs
end

#############################################################
# Linking Database and logs
#############################################################
desc "set link to database.yml in shared"
task :link_db_logs do
  run "ln -nfs #{application_path}/shared/config/database.yml #{release_path}/config/database.yml"
  run "rm -r #{release_path}/log"
  run "ln -s #{application_path}/shared/log  #{release_path}/log"
end


