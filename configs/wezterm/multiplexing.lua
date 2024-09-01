-- ----------------------------------------------------------- 
-- User defined variables
-- ----------------------------------------------------------- 
local shell = 'Posix'
local use_multiplexing = 'None'
-- ----------------------------------------------------------- 
local wezterm = require 'wezterm'
local module = {}
local ssh_domains = {}

function module.emulate_ssh_hosts()
    for host, config in pairs(wezterm.emulate_ssh_hosts())
    do
        table.insert(ssh_domains, {
                name = host,
                remote_address = host,
                multiplexing = use_multiplexing,
                assume_shell = shell,
            })

    --return config
end

function module.setup_multiplexing()
    --
end

return module
