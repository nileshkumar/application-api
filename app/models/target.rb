class Target < ActiveRecord::Base
  require 'net/ping'
  
  belongs_to :appliance

  validates :appliance_id, presence:   true

  validates :hostname,     presence:   true,
                           uniqueness: true

  validates :address,      presence:   true,
                           format:     {with: Resolv::IPv4::Regex}


  def self.find_reachable_target(appliances)
    appliances.each do |appl|
      appl.targets.each do |tar|
        res = tar.url_response
        tar.is_reachable = true if res.eql?(true)
        tar.save
      end
    end
  end

  def url_response
   begin
   host_name = hostname.split("-")[1]
   host_url = 'www.'+host_name
   res = Net::Ping::TCP.new(host_url, 'http').ping?
#   uri = URI(host_url)
#   res = timeout(120) {Net::HTTP.get_response(uri).message}
   rescue SocketError => se
     puts "Got socket error: #{se}"
    rescue EOFError
      puts "End of the file reached"
    rescue Net::ReadTimeout
      nil
   end
  end
end
