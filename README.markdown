# vim-textobj-quote

> “Extending Vim to better support typographic (‘curly’) quote characters.”

*Note: this project replaces the deprecated [vim-quotable][vq]*

[vq]: https://github.com/reedes/vim-quotable

While Vim is renown for its text manipulation capabilities, it
nevertheless retains a bias towards ASCII that stretches back to its vi
roots on Unix. This can limit Vim’s appeal for those who prefer
typographic characters like “curly quotes” over ASCII "straight quotes" in
the prose and documentation they write.

Core features of this plugin:

* Text object supporting “typographic quotes”, incl. motion commands
* Implemented with regular expressions via the [kana/vim-textobj-user][vt] plugin
* Supports quoted strings containing contractions (`“don’t”`, e.g.)
* Configurable to support [international variations in quotation marks][iq]

[iq]: http://en.wikipedia.org/wiki/International_variation_in_quotation_marks

Includes four additional features:

* _educate_ - automatic entry of ‘typographic quotes’ from the 'straight quote' keys
* _replace_ - transform quotes from straight to typographic, and visa versa
* _matchit_ - `%` matching for typographic quote pairs
* _surround_ - surround a word or visual selection with quotes

## Requirements

Requires a recent version of Vim compiled with Unicode support.

## Installation

Install using Pathogen, Vundle, Neobundle, or your favorite Vim package
manager.

This plugin has an essential dependency that you will need to install:

* [kana/vim-textobject-user][vt] - a Vim plugin to create your own text objects without pain

[vt]: https://github.com/kana/vim-textobj-user

## Configuration

Because you won't want typographic quotes in your code, the behavior of
this plugin can be configured per file type. For example, to enable
typographic quote support in `markdown` and `textile` files, place in your
`.vimrc`:

```vim
set nocompatible
filetype plugin on       " may already be in your .vimrc

augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init()
  autocmd FileType textile call textobj#quote#init()
  autocmd FileType text call textobj#quote#init({'educate': 0})
augroup END
```

The last `autocmd` statement initializes the plugin for buffers of `text`
file type, but disables the ‘educate’ feature by default. More on that
below.

## Motion commands

Motion commands on text objects are a powerful feature of Vim.

By default, for motion commands, `q` denotes an operation on “double”
quotes. `Q` for ‘single’ quotes. For example, with the `c` change
operator:

* `caq` - change _around_ “double” quotes - includes quote chars
* `ciq` - change _inside_ “double” quotes - excludes quote chars
* `caQ` - change _around_ ‘single’ quotes - includes quote chars
* `ciQ` - change _inside_ ‘single’ quotes - excludes quote chars

Apart from `c` for change, you can `v` for visual selection, `d` for
deletion, `y` for yanking to clipboard, etc. Note that count isn’t
supported at present (due to limitations of the underlying
vim-textobj-user) but repeat with `.` should work.

_quote_’s motion command is smart too, able to distinguish between an
apostrophe and single closing quote, even though both are represented by
the same glyph. For example, try out `viQ` on the following sentence:

```
‘Really, I’d rather not relive the ’70s,’ said zombie Elvis.
```

You can change these key mappings from their defaults in your `.vimrc`:

```vim
let g:textobj#quote#doubleMotion = 'q'
let g:textobj#quote#singleMotion = 'Q'
```

## Additional features

The four additional features of this plugin include: _educate_, _matchit_,
_replace_, and _surround_.

### Educate

This plugin will ‘educate’ quotes, meaning that while in _Insert_ mode,
your straight quote key presses (`"` or `'`) will be dynamically
transformed into the appropriate typographic quote characters.

For example, entering the following sentence without the _educate_ feature
using the straight quote keys:

```
"It's Dr. Evil. I didn't spend six years in Evil Medical
School to be called 'mister,' thank you very much."
```

As expected all the quotes are straight ones. But with the _educate_
feature, the straight quotes are transformed into the typographic
equivalent as you type:

```
“It’s Dr. Evil. I didn’t spend six years in Evil Medical
School to be called ‘mister,’ thank you very much.”
```

You can configure the default settings for the _educate_ feature in your
`.vimrc`:

```vim
let g:textobj#quote#educate = 1       " 0=disable, 1=enable (def)
```

You can change educating behavior with the following commands:

* `Educate`
* `NoEducate`
* `ToggleEducate`

As seen above, educating behavior can be configured as a parameter in the
`textobj#quote#init()` call.

#### Entering straight quotes

In some cases, straight (ASCII) quotes are needed, such as:

```
“print "Hello World!"” is a simple program you can write in Python.
```

To insert a straight quote while educating, enter `«Ctrl-V»` (mnemonic is
_verbatim_) before the quote key:

* `«Ctrl-V» "` - straight double quote
* `«Ctrl-V» '` - straight single quote

Note that for units of measurement you’ll want to use the prime symbol(s)
rather than straight quotes, as in:

```
Standing at 7′3″ (2.21 m), Hasheem Thabeet of the Oklahoma City Thunder
is the tallest player in the NBA.
```

### Matchit support

_matchit_ enables jumping to matching typographic quotes.

* `%` - jump to the matching typographic (curly) quote character

You can configure this feature in your `.vimrc`:

```vim
let g:textobj#quote#matchit = 1       " 0=disable, 1=enable (def)
```

### Replace support

You can replace straight quotes in existing text with curly quotes, and
visa versa. Add key mappings of your choice to your `.vimrc`:

```vim
map <silent> <leader>qc <Plug>ReplaceWithCurly
map <silent> <leader>qs <Plug>ReplaceWithStraight
```

Both _Normal_ and _Visual_ modes are supported by this feature.

To transform all quotes in a document, use _Visual_ mode to select all the
text in the document.

### Surround support

By default there are no key mappings for `surround` support.

#### Basic support

This feature supports basic surround capabilities. Add to your `.vimrc`
key mappings of your choice:

```vim
" NOTE: remove these mappings if using the tpope/vim-surround plugin!
map <silent> Sq <Plug>SurroundWithDouble
map <silent> SQ <Plug>SurroundWithSingle
```

Then you can use ‘motion commands’ to surround text with quotes:

(an asterisk is used to denote the cursor position)

* `visSq` - My senten\*ce. => “My sentence.”
* `visSQ` - My senten\*ce. => ‘My sentence.’

#### Using Tim Pope’s vim-surround

Using Tim Pope’s [vim-surround][] plugin your text object key mappings
should be available. For example,

* `cs'q` - 'Hello W\*orld' => “Hello World”
* `cs"q` - "Hello W\*orld" => “Hello World”
* `cs(q` - (Hello W\*orld) => “Hello World”
* `cs(Q` - (Hello W\*orld) => ‘Hello World’

[vim-surround]: https://github.com/tpope/vim-surround

## Entering special characters

Sometimes you must enter special characters (like typographic quotes)
manually, such as in a search expression. You can do so through Vim’s digraphs
or via your operating system’s keyboard shortcuts.

| Glyph | Vim Digraph | OS X               | Description
| ----- | ----------- | ------------------ | ----------------------------
| `‘`   | `'6`        | `Opt-]`            | left single quotation mark
| `’`   | `'9`        | `Shift-Opt-]`      | right single quotation mark
| `“`   | `"6`        | `Opt-[`            | left double quotation mark
| `”`   | `"9`        | `Shift-Opt-[`      | right double quotation mark
| `‚`   | `.9`        |                    | single low-9 quote
| `„`   | `:9`        | `Shift-Opt-w`      | double low-9 quote
| `‹`   | `1<`        | `Opt-\`            | left pointing single quotation mark
| `›`   | `1>`        | `Shift-Opt-\`      | right pointing single quotation mark
| `«`   | `<<`        | `Opt-\`            | left pointing double quotation mark
| `»`   | `>>`        | `Shift-Opt-\`      | right pointing double quotation mark
| `′`   | `1'`        |                    | single prime
| `″`   | `2'`        |                    | double prime
| `–`   | `-N`        | `Opt-hyphen`       | en dash
| `—`   | `-M`        | `Shift-Opt-hyphen` | em dash
| `…`   | `..`        | `Opt-;`            | horizontal ellipsis
| ` `   | `NS`        |                    | non-breaking space
| `ï`   | `i:`        | `Opt-U` `i`        | lowercase i, umlaut
| `æ`   | `ae`        | `Opt-'`            | lowercase ae

For example, to enter left double quotation mark `“`, precede the digraph code
`"6` with `Ctrl-K`, like

* `«Ctrl-K» "6`

Alternatively, if you’re on OS X, you can use `Opt-[` to enter this
character.

For more details, see:

* `:help digraphs`

## International support

Many international keyboards feature keys to allow you to input
typographic quote characters directly. In such cases, you won’t need to
change the behavior of the straight quote keys.

But if you do, you can override the defaults. For example, those users
editing most of their prose in German could change those defaults to:

```vim
let g:textobj#quote#doubleDefault = '„“'     " „doppel“
let g:textobj#quote#singleDefault = '‚‘'     " ‚einzel‘
```

Or on a file type initialization...

```vim
augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init({ 'double':'„“', 'single':'‚‘' })
  ...
augroup END
```

Or in a key mapping...

```vim
nnoremap <silent> <leader>qd :call textobj#quote#init({ 'double':'„“', 'single':'‚‘' })<cr>
```

## See also

If you find this plugin useful, check out these others by [@reedes][re]:

* [vim-colors-pencil][cp] - color scheme for Vim inspired by IA Writer
* [vim-lexical][lx] - building on Vim’s spell-check and thesaurus/dictionary completion
* [vim-litecorrect][lc] - lightweight auto-correction for Vim
* [vim-one][vo] - make use of Vim’s _+clientserver_ capabilities
* [vim-pencil][pn] - rethinking Vim as a tool for writers
* [vim-textobj-sentence][ts] - improving on Vim's native sentence motion command
* [vim-thematic][th] - modify Vim’s appearance to suit your task and environment
* [vim-wheel][wh] - screen-anchored cursor movement for Vim
* [vim-wordy][wo] - uncovering usage problems in writing
* [vim-wordchipper][wc] - power tool for shredding text in Insert mode

[re]: http://github.com/reedes
[cp]: http://github.com/reedes/vim-colors-pencil
[lx]: http://github.com/reedes/vim-lexical
[lc]: http://github.com/reedes/vim-litecorrect
[vo]: http://github.com/reedes/vim-one
[pn]: http://github.com/reedes/vim-pencil
[th]: http://github.com/reedes/vim-thematic
[ts]: http://github.com/reedes/vim-textobj-sentence
[wh]: http://github.com/reedes/vim-wheel
[wo]: http://github.com/reedes/vim-wordy
[wc]: http://github.com/reedes/vim-wordchipper

## Future development

If you’ve spotted a problem or have an idea on improving this plugin,
please post it to the github project issue page.

Needs better integration with existing surround plugins.

<!-- vim: set tw=74 :-->
