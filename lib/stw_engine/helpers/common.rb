require 'net/http'
require 'uri'

module StwEngine
  module Helpers
    module Common
      extend self

	#struc = {stwaccesskeyid: api_key, stwu: api_secret }
	def http_get(addr, params)
		uri = URI.parse(addr)
		# Add params to URI
		uri.query = URI.encode_www_form( params )
		return Net::HTTP.get(uri)
	end

	def stw_show url
		params = {:stwaccesskeyid => StwEngine.api_key , 
		:stwu => StwEngine.api_secret, :stwurl =>url }
		
		res = http_get(StwEngine.image_url , params)
		#puts res.body

		xml_doc = Nokogiri::XML(res)


		#puts xml_doc

		#puts xml_doc.xpath('stw:Response')

		#a= xml_doc.css('Response')
		#print a

		#res.inspect
	end
	
	def nokogiri_val(xml, tag)
		xml_doc = Nokogiri::XML(xml)
		xml_doc.xpath("//stw:#{tag}").inner_text.strip
	end
	

	def stw_show_info
		info = ['Status', 'Account_Level', 'Inside_Pages', 'Custom_Size', 'Full_Length', 
		'Refresh_OnDemand', 'Custom_Delay', 'Custom_Quality', 'Custom_Messages', 'Custom_Resolution']
		info_h = Hash.new
		
		#get account info
		params = {:stwaccesskeyid => StwEngine.api_key , :stwu => StwEngine.api_secret }
		res = http_get(StwEngine.account_url , params)
		
		info.each {|x| info_h[x] = nokogiri_val(res,x)  }
		
		return info_h
		
		
		#http://images.shrinktheweb.com/account.php?".http_build_query($args)

	end
	

    end
  end
end
