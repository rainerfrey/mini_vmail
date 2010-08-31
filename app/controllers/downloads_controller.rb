require 'erb'

class DownloadsController < ApplicationController
  before_filter :require_user

  def index
  end

  def relay_domains
    domains = Domain.active
    transport = APP_CONFIG[:domain_transport]
    domain_file = ""
    domains.each do |domain|
      domain_file << "#{domain}\t#{transport}\n"
    end
    send_data domain_file, :filename => "relay_domains", :type => "text/plain"
  end
  
  def virtual_mailboxes
    send_config_file "virtual-mailbox.cf"
  end

  def dovecot_auth
    send_config_file "dovecot-sql.conf"
  end
  
  private
  DB_TYPES={"postgresql" => "pgsql", "sqlite3"=>"sqlite","mysql"=>"mysql","mysql2"=>"mysql"}
  
  def send_config_file(file)
    db_config = ActiveRecord::Base.configurations[Rails.env]
    db_type =  DB_TYPES[db_config["adapter"]]
    db_param = db_type == "sqlite" ? "dbpath" : "dbname"
    
    database = db_config["database"]
    user=db_config["username"]||nil
    password=db_config["password"]||nil
    host=db_config["host"] || nil
    
    path=Rails.root + "config/mailserver/#{file}.erb"
    template = ERB.new(File.read(path))
    send_data template.result(binding), :filename => file, :type => "text/plain"
  end
end
