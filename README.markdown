# stw_engine gem

## What is it?
A Ruby gem wrapping the http://shrinktheweb.com API.

## Who should use it?
Any Ruby on Rails developer who wants/needs to generate screenshots from sites using shrinktheweb.com.


## Installation

	gem install nokogiri
	
    gem install stw_engine
    
    


### Configuration

You must define your Access key or secret key, they are required:

	StwEngine.config({

		# required
		:api_key      => 'xXXXXXXXXXXXXX',
		:private_key  => 'xxxx,

		#optional use if supported
		:size  => 'lg',


	})
	

mount the gem in your apps routes.rb file using

	mount StwEngine::Engine => "/stw_engine"
	
Then you'll be able to access the account info at
	 yourwebsite.com/stw



##### size
The following sizes are available depending on the account level


* xlg
* lg
* sm
* vcm
* tny
* mcr




##### mode


## Usage


Generate an image tag:

    stw_show url

Generate an image tag with size option:

	stw_show url, :size => 'xlg'
    


To only get the image url with lg size:

    stw_show_url url, :size => 'lg'
    








