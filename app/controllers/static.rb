require 'securerandom'

get '/' do
	@urls = Url.all
 	erb :"static/index"
end	

post '/shorten' do
	@url = Url.new(long_url: params['long_url'], short_url: SecureRandom.hex(4))
	if @url.save 
		#redirect '/'
	else 
		@errors = @url.errors.full_messages.join(",")
		#error messages comes from Active Record as it does not pass the validation 

	end 
	#redirect "/?errors=#{{@errors}}"
	@urls = Url.all.order("created_at  DESC")
	erb :"static/index"

end

post '/:url_id/vote' do 

	@url = Url.find(params[:url_id])
	@url.click_count +=1 
	@url.save 
	redirect '/'

end 

get '/:shortshort' do 
	#look for this url now 
	@url = Url.find_by(short_url: params[:shortshort])
	@url.click_count += 1 
	@url.save

	redirect to "#{@url.long_url}" 
end 
