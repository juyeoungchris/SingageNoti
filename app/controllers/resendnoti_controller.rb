class ResendnotiController < ApplicationController
	before_action :find_noti, only: [:write]
	require 'net/http'
	require 'json'

	def write
		# @noti = params.require(:noti).permit(:title, :description, :timeout)
		logger.debug "[ResendControllerwrite] res #{__LINE__}"

		# @noti = Noti.new(params[:noti])

		# redirect_to @noti, notice: "Successfully created new notification"
			
		logger.debug "[ResendControllersend] #{__LINE__}, #{@noti}"
		logger.debug "[ResendControllersend] #{__LINE__}, #{@noti.title}"
		logger.debug "[ResendControllersend] #{__LINE__}, #{@noti.description}"
		logger.debug "[ResendControllersend] #{__LINE__}, #{@noti.timeout}"
		uri = URI('http://13.125.195.134:3000/api/noti')
	    http = Net::HTTP.new(uri.host, uri.port)
	    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	    # req.body = {to: "userId", data:{ type: "11" , scheduleTimeUTC: "0", timeoutSec: @noti.timeout.to_s , title: @noti.title , body: @noti.description }}.to_json
	    req.body = {to: "userId", data:{ type: "11" , scheduleTimeUTC: "0", timeoutSec: @noti.timeout.to_s , title: @noti.title , body: "http://13.124.141.239:3000/notis/" + @noti.id.to_s}}.to_json
		  # req.body = {to: "userId", data:{ type: "11" , scheduleTimeUTC: "0", timeoutSec: @noti.timeout.to_s , title: @noti.title , body: "http://13.124.141.239/:3000/notis/" + "6"}}.to_json

	    logger.debug "[ResendControllermid] res #{__LINE__} , #{req.body}"
	    res = http.request(req)
	    #http.use_ssl = true
	    puts "response #{res.body}"

	    logger.debug "[ResendControllerend] res #{__LINE__} , #{req.body}"
	end

	private

	def noti_params
		logger.debug "[LLLLLLLLLLLLLLparams] res #{__LINE__} #{:noti}"
		params.require(:noti).permit(:title, :description, :timeout)
	end

	def find_noti
		@noti = Noti.find(params[:id])
	end
end
