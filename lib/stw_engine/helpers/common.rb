require 'net/http'
require 'uri'
require 'digest'
require 'open-uri'

module StwEngine
  module Helpers
    module Common
      extend self
      
	#function to create a hash
	def createsig(body)
		Digest::MD5.hexdigest( sigflat body )
	end

	def sigflat(body)
		if body.class == Hash
		arr = []
		body.each do |key, value|
		arr << "#{sigflat key}=>#{sigflat value}"
		end
		body = arr
		end
	  if body.class == Array
		str = ''
		body.map! do |value|
		  sigflat value
		end.sort!.each do |value|
		  str << value
		end
	  end
	  if body.class != String
		body = body.to_s << body.class.to_s
	  end
	  body
	end
	
	
	#struc = {stwaccesskeyid: api_key, stwu: api_secret }
	def http_get(addr, params)
	   
		uri = URI.parse(addr)
		# Add params to URI
		uri.query = URI.encode_www_form( params )

		begin
		uri.open.read
		  rescue OpenURI::HTTPError => ex
				return 'http_error'
		end
		
	end

	#function to return only url 
	
	def stw_show_url url, options={}
		stw_show url, options, only_url=true
	end
	
	def add_size size, params
			case size
				when 'xlg'
					params['stwxmax'] = 320
				when 'lg'
					params['stwxmax'] = 200
				when 'sm'
					params['stwxmax'] = 120
				when 'vsm'
					params['stwxmax'] = 100
				when 'tny'
					params['stwxmax'] = 90
				when 'mcr'
					params['stwxmax'] = 75
		
			end
		return params
	end
	
    # function to store the image and return the image url
	def stw_show url, options ={}, only_url=false
		sizes = ['xlg', 'lg', 'sm', 'vsm', 'tny', 'mcr']
		params = {:stwaccesskeyid => StwEngine.api_key , 
		:stwu => StwEngine.api_secret}
		
		if StwEngine.size
			params = add_size StwEngine.size, params
		end
		
		if options.key?(:size)
			params = add_size options[:size], params

		end
		#return params
		params[:stwurl] = url 
		
		
		filename = createsig(params)
		filename << '.jpg'
		
		#return the file if exists
		if FileTest.exist?("#{Rails.root}/public/images/#{filename}")
			img = "<img src=\"/stw/#{filename}\"/>"
			img.respond_to?(:html_safe) ? img.html_safe : img 
			return img
		
		end
		
		#else send http request to retrieve the image		
		res = http_get(StwEngine.image_url , params)
		
		if  res == 'http_error'
		 return 'http_error'
		end
		#puts res.body
		


		xml_doc = Nokogiri::XML(res)
		
		
		elems = xml_doc.xpath("//stw:ThumbnailResult/stw:Thumbnail")
		image = elems[0].inner_text.strip
		
		if elems[0].attr('Exists') == 'true'
			image = elems[0].inner_text.strip
		end
		
		#if not http error show the error image not save
		status_codes = ['fix_and_retry','noretry','noexist']
		stat = elems[1].inner_text.strip
		
		if status_codes.include?stat
			img = "<img src=\"#{image}\"/>"
			return img.respond_to?(:html_safe) ? img.html_safe : img 
			
		end
		
		
		

		
		directory =  "#{Rails.root}/public/stw"
		Dir.mkdir("#{Rails.root}/public/stw") unless Dir.exist? "#{Rails.root}/public/stw"
		path = File.join(directory, filename)
		
		open(path, 'wb') do |file|
			file << open(image).read
		end
		img_path = "/stw/#{filename}"
		
		if only_url
			return img_path
		end
		
		img = "<img src=\"/stw/#{filename}\"/>"
		img.respond_to?(:html_safe) ? img.html_safe : img 

	end
	
	def nokogiri_val(xml, tag)
		xml_doc = Nokogiri::XML(xml)
		a = xml_doc.xpath("//stw:#{tag}").inner_text.strip
		
		
		
	end
	

	#show account info
	def stw_show_info
		info = ['Status', 'Account_Level', 'Inside_Pages', 'Custom_Size', 'Full_Length', 
		'Refresh_OnDemand', 'Custom_Delay', 'Custom_Quality', 'Custom_Messages', 'Custom_Resolution']
		info_h = Hash.new
		
		#get account info
		params = {:stwaccesskeyid => StwEngine.api_key , :stwu => StwEngine.api_secret }
		res = http_get(StwEngine.account_url , params)
		
		info.each {|x| info_h[x] = nokogiri_val(res,x)  }
		
		
		
		if info_h['Account_Level'] == '1'
			info_h['Account_Level'] =  'Basic'
		
		elsif info_h['Account_Level'] == '2'
			info_h['Account_Level'] =  'Plus'
		else 
			info_h['Account_Level'] = 'Free'
		
		end
		
		return info_h
		
		
		#http://images.shrinktheweb.com/account.php?".http_build_query($args)

	end
	

    end
  end
end
