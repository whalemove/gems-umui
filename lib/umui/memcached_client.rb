module Umui
  
  def self.init_memcached_client
    options = {}
    options["namespace"]  = SERVICE_CONFIG["memcached_namespace"]
    options["compress"]   = true
    options["username"]   = SERVICE_CONFIG["memcached_username"] if SERVICE_CONFIG["memcached_authentication"] == 1
    options["password"]   = SERVICE_CONFIG["memcached_password"] if SERVICE_CONFIG["memcached_authentication"] == 1
    return Dalli::Client.new(SERVICE_CONFIG["memcached_service"], options)
  end
  
end