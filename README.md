# Marked

Persistent single-line marks per file for Vim.  
Lets you quickly set a mark with `Z` and jump back to it later, even across sessions.  
Marks are saved to a single JSON file (`~/.vim/marks.json`), keyed by absolute file path.

## Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'saltytine/marked'
````

then run:

```vim
:PlugInstall
```

## Usage

* Press `Z`
  If a mark exists in the current file → jumps to it.
  Otherwise → sets a new mark at the current line.

* Press `Shift + Z`
  Clears the mark for the current file.

## Example

If you set a mark in:

```
/home/user/Coding/tivOS/src/kernel/networking/socket.c
```

your `~/.vim/marks.json` might look like:

```json
{
  "/home/user/Coding/tivOS/src/kernel/networking/socket.c": { "line": 233 },
  "/home/user/Coding/tivOS/src/kernel/Makefile": { "line": 88 }
}
```

## Notes

* Only one mark per file is stored.
* Marks persist across Vim sessions.
* Data is stored in `~/.vim/marks.json`.
* Uses Vim’s built-in `json_encode` and `json_decode`.
