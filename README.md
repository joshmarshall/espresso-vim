Espresso Vim
============
Espresso is a simple compiler plugin for vim that takes CoffeeScript
files and automatically compiles and minifies them.

DO NOT LEARN from this plugin, as it was hacked together by someone who 
has never written a vim plugin before and very likely did a horrific 
job of it. I liberally copied and edited from the pylint.vim plugin 
(http://www.vim.org/scripts/script.php?script_id=891), although
any deficiencies in this script are completely my own fault.

The syntax/coffee.vim file is from the awesome Mick Koch, and his
vim-coffee-script project available at:

* https://github.com/kchmck/vim-coffee-script

Installation
------------
This depends on a Unixy environment. You should obviously have the 
CoffeeScript executable installed (otherwise, why are you looking for a
vim plugin for it? :) as well as JSMin.

* CoffeeScript homepage: http://jashkenas.github.com/coffee-script/
* JSMin homepage: http://www.crockford.com/javascript/jsmin.html

Mick Koch's syntax/coffee.vim file should be placed in ~/.vim/syntax 
directory, and the compiler/espresso.vim file should be placed in the 
~/.vim/compiler directory.

The 'coffee' executable and the 'jsmin' executable should be available from 
the PATH environment variable.

Add the following lines to the autocmd section  of your .vimrc (either 
global or ~/.vimrc)

	" Espresso / CoffeeScript settings
	au BufRead,BufNewFile *.coffee set filetype=coffee
	autocmd FileType coffee compiler espresso

Usage
-----
By default, espresso.vim will run everytime you save a CoffeeScript file.
In the event of an error, it dumps stderr to the QuickFix window, mostly 
because I haven't figured out how to do it better (patches welcome). :) 

If there are no errors compiling CoffeeScript, it replaces the '.coffee' 
extension of the file being edited with '.js' (i.e. test.coffee becomes
test.js) and passes that file to jsmin, which writes a '.min.js' file
(i.e. test.coffee -> test.js -> test.min.js). 

If you don't want espresso to run everytime you save, a.) maybe this
plugin isn't for you :) and b.) you will want to put the following in your
.vimrc

	let g:espresso_onwrite = 0

However, note that currently (on my system anyway) :make doesn't work
properly, so this will pretty much render the thing useless.

The plugin supports removing the plain '.js' file for cleanliness (which is
how I usually run it), but I'm too frightened to release a plugin that 
removes files by default. So, if you want to enable this behavior, consider 
yourself warned and put the following in your .vimrc

	let g:espresso_remove_raw_js = 1

If the extra little echo statements at the bottom get annoying (i.e. the minified file.min.js and (removed file.js)) then you can add the following parameter
to your .vimrc

	let g:espresso_noisy = 0

Contact
-------
I seriously, SERIOUSLY invite all comments, issues, etc. If you see something
that is done horribly, dangerously, inefficiently, or you can just do it
better, please leave an Issue. If you know of a project that does this same
thing but doesn't kill kittens, also let me know.
