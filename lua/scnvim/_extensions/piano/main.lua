local M = {}

-- TODO
-- Default mapping
-- Keymap, midi note number
-- local keys_for_scsynth = {
-- 	["<A-1>"] = 58,
-- 	["<A-2>"] = 59,
-- 	["<A-3>"] = 60,
-- 	["<A-4>"] = 61,
-- 	["<A-5>"] = 62,
-- 	["<A-6>"] = 63,
-- 	["<A-7>"] = 64,
-- 	["<A-8>"] = 65,
-- 	["<A-9>"] = 66,
-- 	["<A-0>"] = 67,
-- }

-- SC code to be evaluated
function M.sc_code_play_synth(synthName, midinote, noteDur)
	local noteOnTime = noteDur or M.note_dur
	synthName = synthName or "default"
	midinote = midinote or 58
	local sc_code = string.format(
		"r{var synth=Synth('%s', ['freq', %s.midicps]); %s.wait; synth.set('gate', 0)}.play;",
		synthName,
		midinote,
		noteOnTime
	)
	return sc_code
end

-- SC code to be evaluated
function M.sc_code_play_midi(midinote, noteDur, channel)
	midinote = midinote or 60
	-- MIDIIn.doNoteOnAction(src, chan, num, veloc)
	-- MIDIIn.doNoteOffAction(src, chan, num, veloc)
	local sc_code = "r{\
		MIDIIn.doNoteOnAction(0, " .. channel .. ", " .. midinote .. ", 127);\
		" .. noteDur .. ".wait;\
		MIDIIn.doNoteOffAction(0, " .. channel .. ", " .. midinote .. ", 0);\
		}.play;"
	return sc_code
end

-- Plays the synth set by the user
-- optional midi note to play
function M.play_default(midinote, noteDur)
	noteDur = noteDur or 0.5
	midinote = midinote or 58
	local sc_code = M.sc_code_play_synth(M.default_synth, midinote, noteDur)
	require("scnvim").send_silent(sc_code)
end

-- Plays the synth set by the user
-- optional midi note to play
function M.play_midi(midinote, noteDur, channel)
	midinote = midinote or 60
	noteDur = noteDur or 0.5
	channel = channel or 0
	local sc_code = M.sc_code_play_midi(midinote, noteDur, channel)
	require("scnvim").send_silent(sc_code)
end

-- Map a key to a synth
function M.map_key_to_midinote(synthName, lhs, midinote, noteDur)
	local sc_code = M.sc_code_play_synth(synthName, midinote, noteDur)

	-- Normal mode mapping
	local opts = { nowait = true, noremap = true, silent = true }
	local mode = "n"

	-- The thing that will be executed by said key:
	local rhs = string.format("<cmd> lua require'scnvim'.send_silent(\"%s\")<cr>", sc_code)

	vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
end

-- (re)Map all keys / synths
function M.remap(newSynth)
	if newSynth ~= nil then
		M.default_synth = newSynth
	end

	local synth = M.default_synth
	-- print("Setting new SuperCollider piano synth to ".. synth)

	for keymap, midinote in pairs(keys_for_scsynth) do
		M.map_key_to_midinote(synth, keymap, midinote, M.note_dur)
	end
end

-- Call setup function, used in init file
-- Takes an optional table of left hand side mappings and corresponding midi notes (see above)
function M.setup()

	-- TODO
	-- if vim.g.sc_piano_use_default_mappings then
	-- 	M.remap(vim.g.sc_piano_synth)
	-- end
end

return M
