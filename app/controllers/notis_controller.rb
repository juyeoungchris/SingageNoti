class NotisController < ApplicationController
	before_action :find_noti, only: [:show, :edit, :update, :destroy, :send, :write]


	require 'net/http'
	require 'json'

	def index
		@notis = Noti.all.order("created_at DESC")
	end

	def new
		@noti = current_user.notis.build
	end

	def create
		@noti = current_user.notis.build(noti_params)
		
		if @noti.save
			redirect_to @noti, notice: "Successfully created new notification"
			
			logger.debug "[send] #{__LINE__}"
			uri = URI('http://13.125.195.134:3000/api/noti')
		    http = Net::HTTP.new(uri.host, uri.port)
		    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
		    req.body = {to: "userId", data:{ type: "11" , scheduleTimeUTC: "0", timeoutSec: @noti.timeout.to_s , title: @noti.title , body: "http://13.209.193.243:3000/notis/" + @noti.id.to_s}}.to_json
		    res = http.request(req)
		    http.use_ssl = true
		    puts "response #{res.body}"

		    logger.debug "[end] res #{__LINE__} , #{req.body}"
		
		else
			render 'new'
		end
	end

	def show
		if current_user
			render layout: true
		else
			render layout: false
		end
	end

	def edit
		
		
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
		logger.debug "[LLLLLLLLLLLLLLparams] res #{__LINE__} #{:noti}"
		params.require(:noti).permit(:title, :description, :timeout, :image)
	end

	def find_noti
		@noti = Noti.find(params[:id])
	end

	def standard_http_request
	  uri = URI.parse("http://www.google.com")

	  # Shortcut
	  response = Net::HTTP.get_response(uri)

	  # Will print response.body
	  Net::HTTP.get_print(uri)

	  # Full
	  http = Net::HTTP.new(uri.host, uri.port)
	  response = http.request(Net::HTTP::Get.new(uri.request_uri))  
	end

	def make_post_req  
    require 'net/http'
    require 'json'
    begin
        uri = URI('http://13.125.195.134:3000/api/noti')
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json',  
          'Authorization' => ''})
        req.body = {title: "test", body: "body"}.to_json
        res = http.request(req)
        puts "response #{res.body}"
        puts JSON.parse(res.body)
    rescue => e
        puts "failed #{e}"
    end
  end
end
