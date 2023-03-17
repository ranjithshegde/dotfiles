local uv = vim.loop
local shell = require('r.utils').silent_shell

local workspace = vim.env.WORKSPACE
if workspace == nil then
    workspace = vim.fn.input('Enter Worksapce Dir: ', '', 'file')
end

local boilerplate = {
    webdev = { js = { '{}' } },
    cpp = {
        of = {
            gitignore = {
                '.cache/\n',
                '.clang-format\n',
                'tags\n',
                'compile_commands.json\n',
                '*.qbs\n',
                'obj/\n',
                'bin/*\n',
                '!bin/data\n',
                'bin/data/*\n',
                '!bin/data/*.vert\n',
                '!bin/data/*.frag\n',
            },
        },
        micro = {
            cpp = {
                '#include<Arduino.h>\n',
                '\n',
                'void setup()\n',
                '{\n',
                '}\n',
                '\n',
                'void loop()\n',
                '{\n',
                '}\n',
            },
            gitignore = {
                'build/*\n',
                'compile_commands.json\n',
                '.clangd/*\n',
                '.clang-format\n',
            },
        },
        cmake = {
            cpp = {
                '#include<iostream>\n',
                '\n',
                'int main()\n',
                '{\n',
                'return 0;\n',
                '}\n',
            },
            autoBuild = {
                '#!/bin/sh\n',
                'if [[ -z $1 ]]; then\n',
                'mkdir -p build\n',
                'cd build\n',
                'cmake ..\n',
                'make\n',
                'elif [[ "$1" == "install" ]]; then\n',
                'mkdir -p build\n',
                'cd build,\n',
                'cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_TOOLCHAIN_FILE="/opt/vcpkg/scripts/buildsystems/vcpkg.cmake" .. \n',
                'sudo make install\n',
                'elif [[ "$1" == "debug" ]]; then\n',
                'mkdir -p build\n',
                'cd build\n',
                'cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_TOOLCHAIN_FILE="/opt/vcpkg/scripts/buildsystems/vcpkg.cmake" .. \n',
                'make\n',
                'elif [[ "$1" == "project" ]]; then\n',
                'mkdir -p build\n',
                'cd build\n',
                'cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_TOOLCHAIN_FILE="/opt/vcpkg/scripts/buildsystems/vcpkg.cmake" .. \n',
                'cp compile_commands.json .. \n',
                'fi\n',
            },
            gitignore = {
                'build/*\n',
                'compile_commands.json\n',
                '.clangd/*\n',
                '.clang-format\n',
            },
        },
    },
}

local function write_file(path, data)
    local fd = assert(uv.fs_open(path, 'w', 438))
    local stat = assert(uv.fs_fstat(fd))
    local err = assert(uv.fs_write(fd, data))
    if not stat and err then
        vim.print(stat, err)
    end
    assert(uv.fs_close(fd))
end

local function exec_async(cmd, args, callback, ...)
    local handle
    local c_args = { ... }
    handle = uv.spawn(cmd, {
        cwd = vim.loop.cwd(),
        args = args,
    }, function()
        handle:close()
        if callback then
            callback(unpack(c_args))
        end
    end)
end

local function exec_sync(cmd, callback, args)
    vim.fn.jobstart(cmd, {
        on_exit = function()
            callback(args)
        end,
    })
end

local projects = {}

function projects.create(type)
    if type and type ~= '' then
        projects[type]()
        return
    end

    vim.ui.select({ 'oF', 'micro', 'cmake', 'webdev' }, { prompt = 'Select type' }, function(choice)
        projects[choice]()
    end)
end

------------------------------------------------------------------------
--                              openFrameworks                        --
------------------------------------------------------------------------

local function get_addons()
    local path = vim.env.PG_OF_PATH .. '/addons'
    local addons = {}

    for i, j in vim.fs.dir(path) do
        if j == 'directory' then
            if string.find(i, 'ofx') then
                table.insert(addons, i)
            end
        end
    end

    return addons
end

local function create_of(add)
    vim.ui.input({ prompt = 'Enter  Project name: ', completion = 'file' }, function(i)
        local args = { i }
        if add and add ~= '' then
            table.insert(args, 1, "-a'" .. add .. "'")
        end

        table.insert(args, 1, 'projectGenerator')
        shell(args)
        vim.cmd.cd(i)
        shell { 'clang-format', '--style=webkit', '-dump-config', '>', '.clang_format' }
        exec_sync('compiledb -n make', vim.cmd.edit, 'src/ofApp.h')
        exec_async('git', { 'init' }, write_file, '.gitignore', boilerplate.cpp.of.gitignore)
    end)
end

local function select_addons(addon, list)
    vim.ui.select(addon, { prompt = 'Select addons' }, function(choice)
        list = list .. choice
        vim.ui.select({ 'true', 'false' }, { prompt = 'Using more addons?' }, function(cho)
            if cho == 'true' then
                list = list .. ','
                select_addons(addon, list)
            else
                create_of(list)
            end
        end)
    end)
end

function projects.oF()
    vim.cmd.cd(workspace .. '/openFrameworks')
    vim.ui.input({ prompt = 'Enter filename or directory : ', completion = 'file' }, function(input)
        shell { 'mkdir', '-p', input }
        vim.cmd.cd(input)
        vim.ui.select({ 'true', 'false' }, { prompt = 'Using addons?' }, function(choice)
            if choice == 'true' then
                select_addons(get_addons(), '')
            else
                create_of()
            end
        end)
    end)
end

------------------------------------------------------------------------
--                              MircoControllers                      --
------------------------------------------------------------------------

function projects.micro()
    vim.cmd.cd(workspace .. '/electronics')
    vim.ui.input({ prompt = 'Enter project name', completion = 'file' }, function(input)
        shell { 'mkdir', '-p', input }
        vim.cmd.cd(input)

        vim.ui.input({ prompt = 'Enter board name' }, function(board)
            shell { 'pio', 'project', 'init', '--board', board }

            exec_async('pio', { 'run', '-t', 'compiledb' }, write_file, 'src/main.cpp', boilerplate.cpp.micro.cpp)

            exec_async('git', { 'init' }, write_file, '.gitignore', boilerplate.cpp.micro.gitignore)

            shell { 'clang-format', '--style=webkit', '-dump-config', '>', '.clang_format' }

            vim.defer_fn(function()
                vim.cmd.edit 'src/main.cpp'
            end, 1000)
        end)
    end)
end

------------------------------------------------------------------------
--                              Cmake                                 --
------------------------------------------------------------------------

local function create_cmake_list(project_name, libs)
    boilerplate.cpp.cmake.make = {
        'cmake_minimum_required(VERSION 3.2.0)\n',
        'set(CMAKE_TOOLCHAIN_FILE /opt/vcpkg/scripts/buildsystems/vcpkg.cmake)\n',
        'set(CMAKE_EXPORT_COMPILE_COMMANDS ON)\n',
        '\n',
        'project( ' .. project_name .. ')\n',
        libs and string.format('find_package(%s REQUIRED)\n\n', libs) or '\n',
        'file(\n',
        '\tGLOB_RECURSE SOURCES\n',
        '\tsrc/*.cpp\n',
        ')\n',
        '\n',
        'add_compile_options (\n',
        '\t-Wall\n',
        '\t-Wextra\n',
        '\t-Wpedantic\n',
        ')\n',
        '\n',
        'add_executable(' .. project_name .. ' ${SOURCES})\n',
        '\n',
        'execute_process (\n',
        '\tCOMMAND ${CMAKE_COMMAND} -E create_symlink\n',
        '\t\t${CMAKE_BINARY_DIR}/compile_commands.json\n',
        '\t\t${CMAKE_SOURCE_DIR}/compile_commands.json\n',
        ')\n\n',
        'target_include_directories(' .. project_name .. ' PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)\n',
        libs and string.format('target_link_libraries(%s PUBLIC ${%s_LIBRARY})\n\n', project_name, libs) or '\n',
        'install(TARGETS ' .. project_name .. ' DESTINATION /usr/local/bin)\n',
    }
end

function projects.cmake()
    vim.cmd.cd(workspace .. '/cpp/Projects')
    vim.ui.input({ prompt = 'Enter project name', completion = 'file' }, function(input)
        shell { 'mkdir', '-p', input }
        vim.cmd.cd(input)

        shell { 'mkdir', 'src' }
        shell { 'mkdir', 'include' }
        shell { 'mkdir', 'build' }

        write_file('src/main.cpp', boilerplate.cpp.cmake.cpp)
        write_file('autoBuild', boilerplate.cpp.cmake.autoBuild)

        vim.ui.input({ prompt = 'Enter Libraries name', default = nil }, function(lib)
            if lib and lib ~= '' then
                create_cmake_list(input, lib)
            else
                create_cmake_list(input)
            end
            write_file('CMakeLists.txt', boilerplate.cpp.cmake.make)

            exec_async('git', { 'init' }, write_file, '.gitignore', boilerplate.cpp.cmake.gitignore)

            shell { 'clang-format', '--style=webkit', '-dump-config', '>', '.clang_format' }
            shell { 'chmod', 'u+x', 'autoBuild' }
            exec_sync('autoBuild project', vim.cmd.edit, 'src/main.cpp')
        end)
    end)
end

------------------------------------------------------------------------
--                              Frong-End                             --
------------------------------------------------------------------------

function projects.webdev()
    vim.cmd.cd(workspace .. '/websites/')
    vim.ui.input({ prompt = 'Enter project name', completion = 'file' }, function(input)
        shell { 'mkdir', '-p', input }
        vim.cmd.cd(input)

        exec_async(
            'cp',
            { vim.fs.normalize '~/.config/prettierrc.toml', '.prettierrc.toml' },
            write_file,
            'tsconfig.json',
            boilerplate.webdev.js
        )

        exec_async('mkdir', { 'css', 'res' }, exec_async, 'touch', { 'css/main.css' })

        exec_async(
            'git',
            { 'init' },
            exec_async,
            'cp',
            { vim.fs.normalize '~/.config/stylelintrc.js', '.stylelintrc.js' }
        )

        vim.cmd.edit 'index.html'
    end)
end

return projects
