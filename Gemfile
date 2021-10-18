# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.2'

gem "ddtrace", require: "ddtrace/auto_instrument"
gem "traces-backend-datadog"
gem "async-http", git: "https://github.com/socketry/async-http", branch: "main"

group :preload do
	gem 'utopia', '~> 2.18.4'
	# gem 'utopia-gallery'
	# gem 'utopia-analytics'
	
	gem 'variant'
	
	gem 'async-websocket'
end

gem 'rake'
gem 'bake'
gem 'bundler'
gem 'rack-test'

group :development do
	gem 'guard-falcon', require: false
	gem 'guard-rspec', require: false
	
	gem 'rspec'
	gem 'covered'
	
	gem 'async-rspec'
	gem 'benchmark-http'
end

group :production do
	gem 'falcon'
end
