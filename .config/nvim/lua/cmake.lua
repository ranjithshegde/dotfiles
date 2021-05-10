require('utils')

local CMake = {}

G.extra_cmake_flags = "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
G.cmake_build_dir = "build"

function CMake.terminal(cmd, opencmd)
	Exec(opencmd or "new")
	Exec("terminal " .. cmd) -- TODO: Exit when exit code is 0
end

function CMake.cmake_build() CMake.terminal("cmake --build " .. G.cmake_build_dir) end

function CMake.cmake_install()
	CMake.terminal("cmake --build " .. G.cmake_build_dir .. " --config Release --target install")
end

function CMake.cmake_gen_debug()
	-- cmake -DCMAKE_BUILD_TYPE='Release' -B build -S .
	CMake.terminal(
		"mkdir build; cmake -DCMAKE_BUILD_TYPE='Debug' " .. G.extra_cmake_flags .. " -B " ..
		G.cmake_build_dir .. " -S .")
end

function CMake.cmake_gen()
	CMake.terminal("mkdir build; cmake -DCMAKE_BUILD_TYPE='Release' " .. G.extra_cmake_flags ..
		" -B " .. G.cmake_build_dir .. " -S .")
end

-- TODO: Get a smarter way of doing this that picks up the executable name automatically
function CMake.catch_test()
	local test_executable_name = "tests"
	local rootDir = vim.fn.getcwd()
	CMake.terminal("cmake --build " .. G.cmake_build_dir .. " && ./" .. G.cmake_build_dir .. "/" ..
		test_executable_name, "tabnew")
end

-- Fuzzy execution of catch2 tests using tags
-- function CMake.fuzzy_catch()
-- 	local test_executable_name = "tests"
-- 	local test = "build/" .. test_executable_name
-- 	local catch2tagoutput = CMake.shell("./" .. test .. " -t")
-- 	local newtags = {}

-- 	-- Run through terminal output, get lines containing tags and filter them to only contain tags
-- 	for i = 1, #catch2tagoutput do
-- 		-- Only include lines containing square brackets (a tag in catch)
-- 		if string.match(catch2tagoutput[i], "%[") then
-- 			-- Tag line
-- 			local newtag = string.gsub(catch2tagoutput[i], "%s%d", "")
-- 			newtag = string.gsub(newtag, "%s", "")

-- 			-- Insert into new array
-- 			table.insert(newtags, newtag)
-- 		end
-- 	end

-- 	local counter = 0
-- 	local callback = function(tag)
-- 		counter = counter + 1
-- 		-- print(test)
-- 		-- print(test .. " " .. tag)
-- 		-- Exec("term " .. test .. " " .. tag)
-- 		-- testcmd = string.format("%s -t %s", test, tag)
-- 		-- M.terminal(testcmd)
-- 	end

-- 	-- Run fuzzy command on it
-- 	CMake.fzf(newtags, callback)

-- 	-- M.terminal(test .. " " .. chosentag)

-- 	print(counter)
-- end

return CMake
