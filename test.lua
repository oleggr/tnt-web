-- Some super function to test
function my_super_function( arg1, arg2 ) return arg1 + arg2 end

-- Unit testing starts
local lu = require('luaunit')

function TestListCompare:test1()
    local A = { 121221, 122211, 121221, 122211, 121221, 122212, 121212, 122112, 122121, 121212, 122121 }
    local B = { 121221, 122211, 121221, 122211, 121221, 122212, 121212, 122112, 121221, 121212, 122121 }
    lu.assertEquals( A, B )
end

-- class TestMyStuff

lu.TestListCompare:run()