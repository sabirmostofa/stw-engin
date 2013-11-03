module StwEngine
  module Helpers
    module Common
      extend self
      
      api_key = 'f69382d572eefcf'
	  api_secret = '14964'

	#struc = {stwaccesskeyid: api_key, stwu: api_secret }

	def stw_show url
		return "HEDA"



		api_key = 'f69382d572eefcf'
		api_secret = '14964'

		purl = 'http://images.shrinktheweb.com/xino.php?'
		purl << "stwaccesskeyid=#{api_key}&stwu=#{api_secret }&stwurl=#{url}"
		ur = URI.parse(purl)
		req = Net::HTTP::Get.new(ur.to_s)
		res = Net::HTTP.start(ur.host, ur.port) {|http|
		  http.request(req)
		}
		#puts res.body

		xml_doc = Nokogiri::XML(res.body)
		b= 'heda'

		#puts xml_doc

		#puts xml_doc.xpath('stw:Response')

		#a= xml_doc.css('Response')
		#print a

		#res.inspect
	end

	def stw_show_info
		api_key = 'f69382d572eefcf'
		api_secret = '14964'
		#http://images.shrinktheweb.com/account.php?".http_build_query($args)

	end
	

    end
  end
end
