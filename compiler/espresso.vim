" CoffeeScript -> JSMin compiler
" Compiler:    JSMinifier for CoffeeScript files
" Maintainer:  Josh Marshall (catchjosh@gmail.com)
" Last Change: 2011 Apr 17
" Version:     0.1
" Credits:
"     CoffeeScript syntax file is by the awesome 
"     Mick Koch, from the project vim-coffee-script
"     at https://github.com/kchmck/vim-coffee-script
"
"     This (possible horrific) compiler script is a
"     result of learning from the pylint.vim script,
"     although any deficiencies in this script are
"     certainly mine and not that excellent plugin.
"
"	  See the README.md for installation and usage.


if exists('current_compiler')
    finish
endif

let current_compiler = 'espresso'

if exists(":CompilerSet") != 2 " for older vims
	command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=(coffee\ -c\ %)
" Need to add efm setting here...

" Enable / disable automatic compile on save
if !exists('g:espresso_onwrite')
    let g:espresso_onwrite = 1
endif

" Enable / disable automatic removal of '.js' raw file
if !exists('g:espresso_remove_raw_js')
	let g:espresso_remove_raw_js = 0
endif

" Enable / disable the cwindow -- broken right now
if !exists('g:espresso_cwindow')
	let g:espresso_cwindow = 1
endif

" Enable / disable output information
if !exists('g:espresso_noisy')
	let g:espresso_noisy = 1
endif

if g:espresso_onwrite
	" Set Espresso to run on every save
	augroup coffee
		au!
		au BufWritePost * call Espresso(1)
	augroup end
endif

function! Espresso(writing)
	" Checks settings and runs coffee appropriately
	if !a:writing && &modified
		" Save before running
		write
	endif
	setlocal sp=>%s\ 2>&1

	silent make!

	if g:espresso_cwindow
		cwindow
	endif

	" This is probably a really silly way to check for errors...
	let l:error = 0
	let l:list = getqflist()
	for l:item in l:list
		if !l:error
			let l:error = 1
		endif
	endfor

	" If there are no problems compiling, pipe to JSMin
	if !l:error
		call EspressoMinify()
	endif

endfunction

function! EspressoMinify()
	" Minify Javascript and trivially watch for errors
	let l:basename = substitute(expand("%"), "\.coffee$", "", "g")
	let l:jsname = l:basename . ".js"
	let l:minname = l:basename . ".min.js"
	let l:mincmd = "jsmin < " . l:jsname . " > " . l:minname
	let l:result = system(l:mincmd)
	let l:minerrors = 0
	if l:result
		let l:minerrors = 1
		echo "ERRORS in JSMIN: " . l:result
	else
		if g:espresso_noisy
			echon " | minified " . l:minname
		endif
	endif
	if !l:minerrors
		if g:espresso_remove_raw_js
			" Would rather pipe output from coffee instead of
			" deleting a file path...
			call EspressoRemove(l:jsname)
		endif
	endif
endfunction

function! EspressoRemove(jsname)
	" Just removes a file -- is there a 'vim' way to do this better?
	let l:removeresult = system("rm " . a:jsname)
	if g:espresso_noisy
		echon " (removed " . a:jsname . ")"
	endif
endfunction
