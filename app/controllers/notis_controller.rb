class NotisController < ApplicationController
	before_action :find_noti,:check_login, only: [:show, :edit, :update, :destroy, :send, :write]

	@render = true
	require 'net/http'
	require 'json'

	def index
		@render = true
		@notis = Noti.all.order("created_at DESC")
	end

	def new
		@render = true
		@noti = current_user.notis.build
	end

	def create
		@render = true
		@noti = current_user.notis.build(noti_params)
		
		if @noti.save
			redirect_to @noti, notice: "Successfully created new notification"
			
			logger.debug "[send] #{__LINE__}"
			uri = URI('http://13.125.195.134:3000/api/noti')
		    http = Net::HTTP.new(uri.host, uri.port)
		    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
		    req.body = {to: "userId", data:{ type: "11" , scheduleTimeUTC: "0", timeoutSec: @noti.timeout.to_s , title: @noti.title , body: "http://13.124.141.239/:3000/notis/" + @noti.id.to_s}}.to_json
		    # req.body = {to: "userId", data:{ type: "11" , scheduleTimeUTC: "0", timeoutSec: @noti.timeout.to_s , title: @noti.title , body: "http://13.124.141.239/:3000/notis/" + "6"}}.to_json
		    res = http.request(req)
		    http.use_ssl = true
		    puts "response #{res.body}"

		    logger.debug "[end] res #{__LINE__} , #{req.body}"
		
		else
			render 'new'
		end
	end

	def show
		## render layout: 'application', except: :show ## by Max
		
	end

	def edit
		@render = true
		
		
	end

	def update
		if @noti.update(noti_params)
			redirect_to @noti, notice: "Noti was Successfully updated!"
		else
			render 'edit'
		end
	end

	def destroy
		@noti.destroy
		redirect_to root_path
	end

	def write
		@noti = current_user.notis.build(noti_params)
		logger.debug "[!!!!write] res #{__LINE__}"

		@noti = Noti.new(params[:client])

		redirect_to @noti, notice: "Successfully created new notification"
			
		logger.debug "[send] #{__LINE__}"
		uri = URI('http://13.125.195.134:3000/api/noti')
	    http = Net::HTTP.new(uri.host, uri.port)
	    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
	    req.body = {to: "userId", data:{ type: "11" , scheduleTimeUTC: "0", timeoutSec: @noti.timeout.to_s , title: @noti.title , body: @noti.description }}.to_json
	    logger.debug "[mid] res #{__LINE__} , #{req.body}"
	    # res = http.request(req)
	    # #http.use_ssl = true
	    # puts "response #{res.body}"

	    logger.debug "[end] res #{__LINE__} , #{req.body}"
	end



	private

	def noti_params
		params.require(:noti).permit(:title, :description, :timeout, :image)
	end

	def find_noti
		@noti = Noti.find(params[:id])
	end

	def check_login
		logger.debug "[before log-in check ] res #{__LINE__} , #{current_user}"
		if current_user
			@render = true
		else
			@render = false
		end
	end

	
end
