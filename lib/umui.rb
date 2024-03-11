# encoding: utf-8
require "yaml"
require "umui/version"
require "umui/constant"
require 'active_resource'
require 'dalli'
require 'jwt'
require 'umui/memcached_client'

module Umui
  MEMCACHED_CLIENT = init_memcached_client
  
  class Member < ActiveResource::Base
    self.site = SERVICE_CONFIG["umms_rws"]
    self.element_name = ""
    self.prefix = "/api/v1/members"
    
    def register params
      callAPI("post" , "register" , params)
    end
    
    def login params
      callAPI("post" , "login" , params)
    end
    
    ######################################################################
    #validate token from memcached , if not found validate it in UMMS
    ######################################################################
    def validate_token params
      return format_result 30004 , "ERR_TOKEN_EMPTY"            if params["token"].blank?
      return format_result 30015 , "ERR_UID_CANNOT_BE_BLANK"    if params["uid"].blank?
      
      #validate token is match uid
      result = get_uid_decrypt_token params["token"]
      uid = result["uid"]                                         if result["return_code"] == 0
      return result                                               if result["return_code"] != 0
      return format_result 30025 , "ERR_TOKEN_AND_UID_NOT_MATCH"  if uid != params["uid"]
      
      begin
        strDateTime = MEMCACHED_CLIENT.get(params["token"].to_s)
        
        #is_expired == true  ---->> expired in memcached
        #is_expired == false ---->> no expired in memcached
        is_expired = DateTime.parse(strDateTime) < DateTime.now if !strDateTime.blank?
        
        return format_result 0 , "SUCCESS" if !is_expired.nil? && !is_expired
      rescue Exception => e
        puts e.message
      end
      
      callAPI("post" , "validate_token" , params)
    end
    
    def logout params
      callAPI("post" , "logout" , params)
    end
    
    def clean_tokens params
      callAPI("post" , "clean_tokens" , params)
    end
    
    def update params
      callAPI("post" , "update" , params)
    end
    
    def change_password params
      callAPI("post" , "change_password" , params)
    end
    
    def reset_password params
      callAPI("post" , "reset_password" , params)
    end
    
    def enable params
      callAPI("post" , "enable" , params)
    end
    
    def disable params
      callAPI("post" , "disable" , params)
    end

    def validate_invitation_code params
      self.get("validate_invitation_code" , params)
    end

    def get_invitation_code params
      self.get("get_invitation_code" , params)
    end

    def check_mobile_existence(params)
      callAPI('get', 'check_mobile_existence', params)
    end

private
    def get_uid_decrypt_token token
      begin
        info = JWT.decode token , SERVICE_CONFIG["secret_key"]
        uid = info[0]["uid"]   if !info.blank?
        result = format_result 0, "SUCCESS", uid             if !info.blank?
        result = format_result 30024 , "ERR_TOKEN_INVALID"   if  info.blank?
      rescue Exception => e
        puts e.message
        result = format_result 30024 , "ERR_TOKEN_INVALID"
      end
      
      result
    end
    
    def callAPI(post_or_get , method , params)
      result = {}
      
      begin
        if post_or_get == "post"
          result_response = Member.post(method, params)
          result_body = JSON.parse result_response.body if result_response
          result = result_body if result_body
        end
        
        if post_or_get == "get"
          result = Member.get(method, params)
        end
        
      rescue Exception => e
        Log.error e
        result = format_result 10001 , e.message
      end

      result
    end
    
    def format_result code, info, uid=""
      result = {}
      result['return_code'] = code if !code.blank?
      result['return_info'] = info if !info.blank?
      result['uid']         = uid  if !uid.blank?
      result
    end
    
  end
end
