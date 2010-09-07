require 'erb'

class DownloadsController < ApplicationController
  before_filter :require_admin, :except => :index

  def index
  end

  def relay_domains
    domains = Domain.active
    transport = APP_CONFIG[:relay_transport]
    domain_file = ""
    domains.each do |domain|
      transport = domain.transport if domain.transport
      domain_file << "#{domain}\t#{transport}\n"
    end
    send_data domain_file, :filename => file_key, :type => "text/plain"
  end

  def virtual_aliases
    send_config_file file_key
  end
  
  def virtual_mailboxes
    send_config_file file_key
  end

  def virtual_mailbox_domains
    send_config_file file_key
  end

  def dovecot_auth
    send_config_file file_key
  end
  
  private
  DB_TYPES={"postgresql" => "pgsql", "sqlite3"=>"sqlite","mysql"=>"mysql","mysql2"=>"mysql"}
  
  def send_config_file(file)
    db_config = ActiveRecord::Base.configurations[Rails.env]
    db_type =  DB_TYPES[db_config["adapter"]]
    db_param = db_type == "sqlite" ? "dbpath" : "dbname"
    default_host = db_type == "sqlite" ? nil : "localhost"
    
    database = db_config["database"]
    if db_type == "sqlite"
      database = Rails.root + database unless database.start_with? "/"
    end
    user=db_config["username"]||nil
    password=db_config["password"]||nil
    host=db_config["host"] || default_host
    
    path=Rails.root + "config/mailserver/#{file}.erb"
    template = ERB.new(File.read(path))
    send_data template.result(binding), :filename => file, :type => "text/plain"
  end
  
  def request_auth
    request_http_basic_authentication
  end
  
  def file_key
    APP_CONFIG["#{action_name}_file".to_sym]
  end
end
