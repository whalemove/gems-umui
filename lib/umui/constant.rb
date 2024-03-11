module Umui
  module Constant
    GEM_ROOT_PATH = File.dirname(__FILE__) + "/../.."
  end
  
  SERVICE_CONFIG = YAML::load(File.read("#{Constant::GEM_ROOT_PATH}/service_configuration.yml"))[Rails.env]
end