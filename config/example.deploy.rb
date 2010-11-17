require 'bundler/capistrano'

set :application, "vmail"
set :app_domain, "#{application}"
set :repository,  "git://github.com/rainerfrey/mini_vmail.git"

set :use_sudo, false
set :group_writeble, true
set :user, "deploy"
set :run_user, "rails-vmail"

set :scm, :git

set :deploy_via, :rsync_with_remote_cache
set :deploy_to, "/var/www/apps/#{application}"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "vmail"                                  # Your HTTP server, Apache/etc
role :app, "vmail"                                  # This may be the same as your `Web` server
role :db,  "vmail", :primary => true                # This is where Rails migrations will run
#role :db,  "your slave db-server here"

#local config templates
set :template_dir, "config/deploy"

set :apache_ctl, "apache2ctl"
set :apache_init, "/etc/init.d/apache2"
set :apache_conf, "/etc/apache2"
set :apache_sites, "#{apache_conf}/sites-available"

namespace :deploy do
  task :start, :roles => :app do
    run "touch '#{current_path}/tmp/restart.txt'"
  end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch '#{current_path}/tmp/restart.txt'"
  end
  desc <<-DESC
    First deploy on a server. Install application, setup the database, then start it.
    Replaces deploy:cold
  DESC
  task :first, :except => { :no_release => true } do
    update
    db.setup
    apache.create_site
    apache.enable_site
    start
    apache.reload
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
  
  
  task :passenger_user, :roles => :app do
    sudo "chown #{run_user} #{release_path}/config.ru #{release_path}/config/environment.rb"
  end
  
end

namespace :config do
  task :app, roles => :app do
    upload File.join(fetch(:template_dir, "config/deploy"),'config.yml'), "#{shared_path}/config/config.yml"
  end
  
  desc "Set up shared database.yml"
  task :db, :roles => :app do
    db_password = Capistrano::CLI.password_prompt("Enter PostgreSQL DB password")
    prompt = <<-MSG
      Enter database host name. Use:
       * localhost for local unix socket
       * 127.0.0.1 for local TCP access
       * an IP address or host name for remote database\n
    MSG
    db_host = Capistrano::CLI.ui.ask(prompt) { |q| q.default = "localhost" }
    location = File.join(fetch(:template_dir, "config/deploy"), 'database.yml.erb')
    template = File.read(location)
    run "mkdir -p #{shared_path}/config"
    config = ERB.new(template)
    put config.result(binding), "#{shared_path}/config/database.yml"
  end
end

namespace :db do 
  desc "Sets up the database"
  task :setup, :roles => :db, :only => { :primary => true } do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")
    run "cd #{current_release} && #{rake} RAILS_ENV=#{rails_env} db:setup"
    run "rm #{shared_path}/log/#{rails_env}.log"
  end
end

namespace :apache do
  desc "create the virtual host definition"
  task :create_site, :roles => :web do
    vhost = <<-HOST
    <VirtualHost *:80>
      ServerName #{app_domain}

      ErrorLog /var/log/apache2/mini_vmail_error.log
      CustomLog /var/log/apache2/mini_vmail_access.log vhost_combined

      DocumentRoot #{current_path}/public
      <Directory #{current_path}/public>
          Options -MultiViews
          Order Allow,Deny
          Allow from all
      </Directory>      
    </VirtualHost>
    HOST

    put vhost, "#{shared_path}/#{application}.site"
    sudo "mv #{shared_path}/#{application}.site #{apache_sites}/#{application}"
  end
  
  task :enable_site, :roles => :web do
    sudo "a2ensite #{application}"
  end
  
  task :disable_site, :roles => :web do
    sudo "a2dissite #{application}"
  end
  
  task :reload, :roles => :web do
    sudo "#{apache_ctl} graceful"
  end
  task :start, :roles => :web do
    sudo "#{apache_init} start"
  end
  
  task :stop, :roles => :web do
    sudo "#{apache_init} stop"
  end
end
after "deploy:update_code", "deploy:symlink_shared"
after "deploy:update_code", "deploy:passenger_user"
after "deploy:setup", "config:db"
after "deploy:setup", "config:app"