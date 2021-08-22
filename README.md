# SuperCollider Piano for NeoVim

This plugin emulates the functionality found in digital audio work stations such as Ableton where a user may select a synth and press they computer keyboard's keys to play the synth. Except, this is a million times more cool because it is NeoVim and SuperCollider.

## Requirements

- Nvim >= v0.5
- [scnvim](https://github.com/davidgranstrom/scnvim)

## Installation

for vim-plug users: Add this to your vimrc

```vim
Plug 'madskjeldgaard/nvim-supercollider-piano'
```

and run `:PlugInstall`

## Setup

Add this to your vimrc:

```
autocmd filetype supercollider,scdoc,help.supercollider lua'supercollider-piano'.setup()
``` 

## Default mappings

By default, the plugin uses Alt+[numberKey] to play these midi notes:

```
<A-1> = 58
<A-2> = 59
<A-3> = 60
<A-4> = 61
<A-5> = 62
<A-6> = 63
<A-7> = 64
<A-8> = 65
<A-9> = 66
<A-0> = 67
```

## Commands

`:SCPiano <midinote>`

Play the synth. Adding a midi note as argument is optional

`:SCPianoSynthSet <synthname>`

Set the SynthDef name to be used, eg `:SCPianoSynthSet johnnybegood`

## Options

Set the default synth to use for this

`vim.g.sc_piano_synth = 'supersaw'`

`vim.g.sc_piano_dur = 0.5`

`vim.g.sc_piano_use_default_mappings = true`
