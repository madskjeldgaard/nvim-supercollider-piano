-- Name of synth being played by key map
-- TODO:
vim.g.sc_piano_synth = vim.g.sc_piano_synth or "default"
vim.g.sc_piano_dur = vim.g.sc_piano_dur or 0.5
vim.g.sc_piano_use_default_mappings = vim.g.sc_piano_use_default_mappings or true

local piano = require("scnvim._extensions.piano.main")

return require("scnvim").register_extension({
	--- The setup function will run when the user loads the extension.
	--- It will receive the extension config as the first argument and the user config as the second.
	--- It is acceptable to override values in the user_config object.
	---
	--- The extension config is specified in the scnvim.setup function.
	---
	--- scnvim.setup{
	---   extensions = {
	---     logger = {
	---       path = '/tmp/my-log.txt',
	---     },
	---   },
	--- }
	setup = function(ext_config, user_config)
		piano.default_synth = ext_config.default_synth or "default"
		piano.note_dur = ext_config.note_dur or 0.5
		-- logger.path = ext_config.path or '/tmp/sclang-log.txt'
	end,

	--- This is the public API of this plugin. Try not to break it :)
	---
	--- The exported functions will be accessible from `SCNvimExt <name>.<command> <args>`
	--- Example: :SCNvimExt logger.start
	--- Example: :SCNvimExt logger.start w+ /tmp/log.txt
	---
	--- NOTE: Arguments will be passed as strings (see :help <f-args>)
	--- Use `tonumber()` in the receiving function to convert arguments if needed.
	exports = {
		play = piano.play_default,
		set_synth = piano.remap,
		midi = piano.play_midi,
	},

	--- Health checks
	--- This function will be executed by :checkhealth scnvim
	health = function()
		local health = require("health")
		health.report_ok("all is good")
	end,
})
