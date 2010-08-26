class DownloadsController < ApplicationController
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

end
