
require 'json'
require 'trenni'

module Live
	class Node
		def initialize(id, **data)
			@id = id
			@data = data
			@data[:class] ||= self.class.name
			
			@page = nil
		end
		
		attr :id
		
		def forward(details = nil)
			if details
				"live.forward(#{Trenni::Script.json(@id)}, event, #{Trenni::Script.json(details)})"
			else
				"live.forward(#{Trenni::Script.json(@id)}, event)"
			end
		end
		
		def bind(page)
			@page = page
		end
		
		def handle(event, details)
		end
		
		def update(message)
			@page.updates.enqueue(message)
		end
	end
	
	class Element < Node
		def update!
			update({id: @id, html: self.to_html})
		end
		
		def render(builder)
		end
		
		def to_html
			Trenni::Builder.fragment do |builder|
				builder.tag :div, id: @id, class: 'live', data: @data do
					render(builder)
				end
			end
		end
	end
	
	class ClickCounter < Element
		def initialize(id, **data)
			super
			
			@data[:count] ||= 0
		end
		
		def handle(event, details)
			@data[:count] = Integer(@data[:count]) + 1
			
			update!
		end
		
		def render(builder)
			builder.tag :button, onclick: forward do
				builder.text("Add an image. (#{@data[:count]} images so far).")
			end
			
			builder.tag :div do
				Integer(@data[:count]).times do
					builder.tag :img, src: "https://picsum.photos/200/300"
				end
			end
		end
	end
	
	class Page
		def initialize(connection)
			@connection = connection
			
			@tags = {}
			@updates = Async::Queue.new
			
			@reader = start_reader
		end
		
		attr :updates
		
		def start_reader
			Async do
				while message = @connection.read
					Console.logger.info(self) {"Reading message: #{message}"}
					if id = message[:bind] and data = message[:data]
						bind(resolve(id, data))
					elsif id = message[:id]
						@tags[id].handle(message[:event], message[:details])
					end
				end
			ensure
				@reader = nil
			end
		end
		
		def resolve(id, data)
			# This line is a major security issue:
			klass = Object.const_get(data[:class])
			
			return klass.new(id, **data)
		end
		
		def bind(tag)
			@tags[tag.id] = tag
			tag.bind(self)
		end
		
		def run
			while update = @updates.dequeue
				Console.logger.info(self) {"Sending update: #{update}"}
				@connection.write(update)
				@connection.flush if @updates.empty?
			end
		end
	end
end
