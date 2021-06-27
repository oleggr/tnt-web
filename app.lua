#!/usr/bin/env tarantool

box.cfg{}
box.once('schema', function()
	box.schema.create_space('hosts')
	box.space.hosts:create_index('primary', { type = 'hash',
		parts = {1, 'str'} })
end)

function validate_item(item)
	return true
end

function post_item_handler(req)
	local my_table = req:json()
	box.space.hosts:insert({my_table['key'], my_table['value']})
	return {status = 200}
end

function put_item_handler(req)
	local id = req:stash('id')
	local my_table = req:json()
	box.space.hosts:update({id}, {{'=', 2, my_table['value']}})
	return {status = 200}
end

function get_item_handler(req)
	local id = req:stash('id')
	local res = box.space.hosts:select(id)
	return tostring(res)
	--return {status = 200}
end

function delete_item_handler(req)
	local id = req:stash('id')
	box.space.hosts:delete({id})
	return id
	--return {status = 200}
end

local httpd = require('http.server')
local server = httpd.new('0.0.0.0', 8080)

server:route({ path = '/item', method = 'POST' }, post_item_handler)
server:route({ path = '/item/:id', method = 'PUT' }, put_item_handler)
server:route({ path = '/item/:id', method = 'GET' }, get_item_handler)
server:route({ path = '/item/:id', method = 'DELETE' }, delete_item_handler)

server:start()