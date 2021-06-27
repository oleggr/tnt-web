#!/usr/bin/env tarantool

box.cfg{
	log = 'tarantool.log',
	log_format='plain'
}

box.once('schema', function()
	box.schema.create_space('items')
	box.space.items:create_index('primary', { type = 'hash',
		parts = {1, 'str'} })
end)

function validate_item_body(item)
	--todo: fix body validation
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
		log.error('post_item_handler - key already exist')
		return {status = 409, body="key already exist"}
	end

	if not validate_item_body(my_table['value']) then
		log.error('post_item_handler - body incorrect')
		return {status = 400, body="body incorrect"}
	end

	log.info('post_item_handler - key %s inserted', my_table['key'])
	box.space.items:insert({my_table['key'], my_table['value']})
	return {status = 200}
end

function put_item_handler(req)
	local id = req:stash('id')
	local my_table = req:json()

	if not check_element_exist(id) then
		log.error('put_item_handler - key not exist')
		return {status = 404, body="key not exist"}
	end

	if not validate_item_body(my_table['value']) then
		log.error('put_item_handler - body incorrect')
		return {status = 400, body="body incorrect"}
	end

	log.info('put_item_handler - key %s updated', id)
	box.space.items:update({id}, {{'=', 2, my_table['value']}})
	return {status = 200}
end

function get_item_handler(req)
	local id = req:stash('id')
	local res = box.space.items:select({id})
	if table.getn(res)==0 then
		log.error('get_item_handler - key not exist')
		return {status = 404, body="key not exist"}
	end
	return req:render{status = 200, json=res}
end

function delete_item_handler(req)
	local id = req:stash('id')
	if not check_element_exist(id) then
		log.error('delete_item_handler - key not exist')
		return {status = 404, body="key not exist"}
	end
	log.info('delete_item_handler - key %s deleted', id)
	box.space.items:delete({id})
	return {status = 200}
end

log = require('log')

local httpd = require('http.server')
local server = httpd.new('0.0.0.0', 8080)

server:route({ path = '/item', method = 'POST' }, post_item_handler)
server:route({ path = '/item/:id', method = 'PUT' }, put_item_handler)
server:route({ path = '/item/:id', method = 'GET' }, get_item_handler)
server:route({ path = '/item/:id', method = 'DELETE' }, delete_item_handler)

server:start()