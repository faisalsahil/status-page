#require 'httparty'

class PingdomprocessController < ApplicationController


  def index
  	# @client = Pingdom::Client.new :username => "dm@dmar.net", :password => "test123", :key => "8rlvugf578p9f99i11oabur7p8la7w7n"
	# @check = @client.checks.first #=> #<Pingdom::Check>
	# response = Pingdom.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => auth)

	

	# response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => {:username => "dm@dmar.net", :password => "test123"}, :headers => { "App-Key" => "8rlvugf578p9f99i11oabur7p8la7w7n" })
    

	##############DONT DELETE THE COMMENTS BELOW################

	response = HTTParty.get("https://api.pingdom.com/api/2.0/checks", :basic_auth => {:username => "dm@dmar.net", :password => "test1234"}, :headers => { "App-Key" => "8rlvugf578p9f99i11oabur7p8la7w7n" })

    # checks = []
    
    # response["checks"].each do |check|
    #   checks << { site: check["hostname"], value: check["status"] }
    # end
    
    # {items: checks.compact, unordered: true}

    @checkts = ""
    
    if response["error"]
    	@checkts = response['error']['errormessage'].to_s
    else
    	@checkts = "Successfully Authenticated"


    end


    


   
   	
  end  
end
