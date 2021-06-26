#!/usr/bin/env tarantool

box.cfg{}
box.once('schema', function()
	box.schema.create_space('hosts')
	box.space.hosts:create_index('primary', { type = 'hash',
		parts = {1, 'str'} })
end)

function post_item_handler(req)
	local resp = req:render({text = req.method..' '..req.path })
	resp.headers['x-test-header'] = 'test';
	resp.status = 201
	return resp
end

function put_item_handler(req)
	local id = req:stash('id')
	local resp = req:render({text = req.method..' '..req.path..' '..id})
	resp.headers['x-test-header'] = 'test';
	resp.status = 201
	return resp
end

function get_item_handler(req)
	local id = req:stash('id')
	local resp = req:render({text = req.method..' '..req.path..' '..id})
	resp.headers['x-test-header'] = 'test';
	resp.status = 201
	return resp
end

function delete_item_handler(req)
	local id = req:stash('id')
	local resp = req:render({text = req.method..' '..req.path..' '..id})
	resp.headers['x-test-header'] = 'test';
	resp.status = 201
	return resp
end

local httpd = require('http.server')
local server = httpd.new('0.0.0.0', 8080)

server:route({ path = '/item', method = 'POST' }, post_item_handler)
server:route({ path = '/item/:id', method = 'PUT' }, put_item_handler)
server:route({ path = '/item/:id', method = 'GET' }, get_item_handler)
server:route({ path = '/item/:id', method = 'DELETE' }, delete_item_handler)

server:start()