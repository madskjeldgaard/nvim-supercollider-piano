# SuperCollider Piano for NeoVim

This plugin emulates the functionality found in digital audio work stations such as Ableton where a user may select a synth and press they computer keyboard's keys to play the synth. Except, this is a million times more cool because it is NeoVim and SuperCollider.

## Requirements

- Nvim >= v0.7
- [scnvim](https://github.com/davidgranstrom/scnvim)

## Installation

* Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use { 'madskjeldgaard/nvim-supercollider-piano' }
```

* Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'madskjeldgaard/nvim-supercollider-piano'
```

Load the extension **after** the call to `scnvim.setup`.

```lua
scnvim.setup{...}

scnvim.load_extension('piano')
```

## Usage

Play your chosen synthdef

```vim
:SCNvimExt piano.play
```
Play a particular midinote (33)

```vim
:SCNvimExt piano.play 33
```
Optionally, you can use a particular duration in the command as well (`0.75` in this case):

```vim
:SCNvimExt piano.play 63 0.75
```
This uses the `\default` synth by default. To use your own, make a SynthDef:

```supercollider
SynthDef(\mycoolsynth,{|out=0, amp=0.5, freq=444|
    var sig = SinOsc.ar(freq) * Env.perc.kr(gate:1);
    Out.ar(out, sig)
}).add
```
Then set it as the SynthDef used by piano (note that the forward slash in `\mycoolsynth` and/or the single quotes in `'mycoolsynth'` are removed when you call it in the set command):

```vim
:SCNvimExt piano.set mycoolsynth
```

Now, the synth being used is `\mycoolsynth`:

```vim
:SCNvimExt piano.play 33
```

You can use piano.midi to play arbitrary MIDIdefs.
Arguments are: midinote duration channel.

```vim
:SCNvimExt piano.midi 48 0.5 0
```

Example mapping of F5

```vim
vim.keymap.set("n", "<F5>", ":SCNvimExt piano.midi 48 0.5 0<CR>")

```

Example MIDIdefs in SuperCollider

```supercollider
MIDIdef.noteOn(\myNoteOn, {
	|vel,num,chan|
	("on " ++ [num,chan]).postln;
});
MIDIdef.noteOff(\myNoteOff, {
	|vel,num,chan|
	("off " ++ [num,chan]).postln;
});
```

## Configuration

The extension will receive its own configuration as well as the user config. It
is acceptable to modify the user config if necessary, and some extensions might
only be a "preset" of a user config.

The extension's own configuration is defined in the table given to `scnvim.setup`.

```lua
scnvim.setup{
  extensions = {
    piano = {
      default_synth = [['mycoolsynth']]
      note_dur = 0.5
    },
  },
}
```
