
source "https://rubygems.org"

ruby "2.6.5"

gem "utopia", "~> 2.5"
# gem "utopia-gallery"
# gem "utopia-analytics"

gem "rake"
gem "bundler"

gem "rack-freeze", "~> 1.2"

group :production do
	gem "falcon"
end

group :development do
	# For `rake server`:
	gem "guard-falcon", require: false
	gem 'guard-rspec', require: false
	
	# For `rake console`:
	gem "pry"
	gem "rack-test"
	
	# For `rspec` testing:
	gem "rspec"
	gem "covered"
end

