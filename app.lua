#!/usr/bin/env tarantool

box.cfg{}
box.once('schema', function()
	box.schema.create_space('items')
	box.space.items:create_index('primary', { type = 'hash',
		parts = {1, 'str'} })
end)

function validate_item(item)
	return true
end

function check_element_exist(key)
	local res = box.space.items:select({key})
	if table.getn(res)==0 then return false end
	return true
end

function post_item_handler(req)
	local my_table = req:json()

	if check_element_exist(my_table['key']) then
		return {status = 409, body="key already exist"}
	end

	if not validate_item(my_table['key']) then
		return {status = 400, body="body incorrect"}
	end

	box.space.items:insert({my_table['key'], my_table['value']})
	return {status = 200}
end

function put_item_handler(req)
	local id = req:stash('id')
	local my_table = req:json()

	if not check_element_exist(id) then
		return {status = 404, body="key not exist"}
	end

	if not validate_item(id) then
		return {status = 400, body="body incorrect"}
	end

	box.space.items:update({id}, {{'=', 2, my_table['value']}})
	return {status = 200}
end

function get_item_handler(req)
	local id = req:stash('id')
	local res = box.space.items:select({id})
	if table.getn(res)==0 then
		return {status = 404, body="key not exist"}
	end
	return req:render{status = 200, json=res}
end

function delete_item_handler(req)
	local id = req:stash('id')
	if not check_element_exist(id) then
		return {status = 404, body="key not exist"}
	end
	box.space.items:delete({id})
	return {status = 200}
end

local httpd = require('http.server')
local server = httpd.new('0.0.0.0', 8080)

server:route({ path = '/item', method = 'POST' }, post_item_handler)
server:route({ path = '/item/:id', method = 'PUT' }, put_item_handler)
server:route({ path = '/item/:id', method = 'GET' }, get_item_handler)
server:route({ path = '/item/:id', method = 'DELETE' }, delete_item_handler)

server:start()