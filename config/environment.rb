# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'utopia/setup'
UTOPIA ||= Utopia.setup

require 'async/task'

require 'traces'
require 'async/pool'

Traces::Provider(Async::Pool::Controller) do
	def acquire
		trace('async.pool.acquire', attributes: {usage: self.usage_string}) {super}
	end
	
	def create_resource
		trace('async.pool.create_resource', attributes: {usage: self.usage_string}) {super}
	end
end
