# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'utopia/setup'
UTOPIA ||= Utopia.setup

require 'async/task'
require 'trace/provider'

Trace::Provider(Async::Task) do
	def make_fiber(&block)
		unless self.transient?
			parent_context = self.trace_context
		end
		
		Fiber.new do |*arguments|
			set!
			
			self.trace_context = parent_context
			
			begin
				@result = yield(self, *arguments)
				@status = :complete
				# Console.logger.debug(self) {"Task was completed with #{@children.size} children!"}
			rescue Async::Stop
				stop!
			rescue StandardError => error
				fail!(error, false)
			rescue Exception => exception
				fail!(exception, true)
			ensure
				# Console.logger.debug(self) {"Task ensure $!=#{$!} with #{@children.size} children!"}
				finish!
			end
		end
	end
end