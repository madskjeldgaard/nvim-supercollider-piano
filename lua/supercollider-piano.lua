local M = {}

-- Name of synth being played by key map
vim.g.sc_piano_synth = vim.g.sc_piano_synth or 'default'
vim.g.sc_piano_dur = vim.g.sc_piano_dur or 0.5
vim.g.sc_piano_use_default_mappings = vim.g.sc_piano_use_default_mappings or true

-- Default mapping
-- Keymap, midi note number
local keys_for_scsynth = {
	["<A-1>"] = 58,
	["<A-2>"] = 59,
	["<A-3>"] = 60,
	["<A-4>"] = 61,
	["<A-5>"] = 62,
	["<A-6>"] = 63,
	["<A-7>"] = 64,
	["<A-8>"] = 65,
	["<A-9>"] = 66,
	["<A-0>"] = 67,
}

-- SC code to be evaluated
function M.sc_code_play_synth(synthName, midinote, noteDur)
	local noteOnTime = noteDur or vim.g.sc_piano_dur or 0.5
	synthName = synthName or 'default'
	midinote = midinote or 58
	local sc_code = string.format(
		"r{var synth=Synth(\'%s\', [\'freq\', %s.midicps]); %s.wait; synth.set(\'gate\', 0)}.play;",
		synthName, midinote, noteOnTime)

	return sc_code
end

-- Plays the synth set by the user
-- optional midi note to play
function M.play_default(midinote)
	midinote = midinote or 58
	local sc_code = M.sc_code_play_synth(vim.g.sc_piano_synth, midinote)
	require'scnvim'.send_silent(sc_code)
end

-- Map a key to a synth
function M.map_key_to_midinote(synthName, lhs, midinote, noteDur)
	local sc_code = M.sc_code_play_synth(synthName, midinote, noteDur)

	-- Normal mode mapping
	local opts = { nowait = true, noremap = true, silent = true }
	local mode = "n"

	-- The thing that will be executed by said key:
	local rhs = string.format("<cmd> lua require'scnvim'.send_silent(\"%s\")<cr>", sc_code)
	-- print(rhs)
	vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)

end

-- (re)Map all keys / synths
function M.remap(newSynth)
	if newSynth ~= nil then
		vim.g.sc_piano_synth = newSynth
	end

	local synth = vim.g.sc_piano_synth
	print("Setting new SuperCollider piano synth to ".. synth)

	for keymap, midinote in pairs(keys_for_scsynth) do
		-- print(synth, keymap, midinote, vim.g.sc_piano_dur)
		M.map_key_to_midinote(synth, keymap, midinote, vim.g.sc_piano_dur)
	end
end

-- Call setup function, used in init file
-- Takes an optional table of left hand side mappings and corresponding midi notes (see above)
function M.setup()

	if vim.g.sc_piano_use_default_mappings then
		M.remap(vim.g.sc_piano_synth)
	end

	vim.cmd("command! -nargs=? SCPiano lua require('supercollider-piano').play_default(<args>)")
	vim.cmd("command! -nargs=1 SCPianoSynthSet lua require('supercollider-piano').remap(\'<args>\')")

end

return M
