
prepend Actions

on 'index' do |request|
	succeed! body: request.body.body
end