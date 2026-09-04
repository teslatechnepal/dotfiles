""" List of vim plugins plugged by vim-plug
call plug#begin('~/.vim/plugged')

""" Easy file navigation with fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'jremmen/vim-ripgrep'

""" Easy navigation to tmux pane with C-[hjkl]
"Plug 'christoomey/vim-tmux-navigator'
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

""" Smooth scrolling
Plug 'psliwka/vim-smoothie'

""" Makes git command available from vim console
Plug 'https://tpope.io/vim/fugitive.git'

""" Shows git modifications inline
Plug 'airblade/vim-gitgutter'

""" Used mainly for buffer switching
Plug 'https://tpope.io/vim/unimpaired.git'

""" Opens ranger gui
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim'

""" Show various info on statusbar
Plug 'vim-airline/vim-airline'

""" Shows open buffer as tab in tabline
Plug 'ap/vim-buftabline'

""" Automatically save vim session
""" saves vim-session on VimLeave and loads session on VimEnter
Plug 'wilon/vim-auto-session'

""" Automatically mkdir when saving buffer
Plug 'pbrisbin/vim-mkdir'

""" Godot syntax and runner
Plug 'habamax/vim-godot'
""" AsyncRun for running godot executable
Plug 'skywind3000/asyncrun.vim'

Plug 'wfxr/minimap.vim'

"Plug 'arcticicestudio/nord-vim'
Plug 'romainl/flattened'

"let g:minimap_auto_start = 1
"let g:minimap_auto_start_win_enter = 1
"
let g:python3_host_prog = expand('~/.local/share/nvim/venv/bin/python')

"Plug 'davidhalter/jedi-vim'
"let g:jedi#completions_command = "<Tab>"

"Plug 'github/copilot.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'olimorris/codecompanion.nvim'

""" Autocompletion
Plug 'nvim-mini/mini.icons', { 'branch': 'stable' }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-omni'
Plug 'hrsh7th/cmp-cmdline'
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'


"Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' }


call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"lua <<EOF
"  require("nvim-treesitter.configs").setup({
"      -- Ensure specified parsers are installed
"      ensure_installed = { "python" },
"
"      -- Enable syntax highlighting
"      highlight = {
"          enable = true,
"      },
"
"      -- Enable indentation (optional, experimental)
"      indent = {
"          enable = true,
"      },
"
"      -- Automatically install missing parsers when a buffer is opened (optional)
"      auto_install = true,
"  })
"EOF

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require("cmp")
  
  -- The extentions needed by nvim-cmp should be loaded beforehand
  require("cmp_nvim_lsp")
  require("cmp_path")
  require("cmp_buffer")
  require("cmp_omni")
  require("cmp_nvim_ultisnips")
  require("cmp_cmdline")
  
  local MiniIcons = require("mini.icons")
  
  cmp.setup {
    snippet = {
      expand = function(args)
        -- For `ultisnips` user.
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-E>"] = cmp.mapping.close(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
    },
    sources = {
      { name = "nvim_lsp" }, -- For nvim-lsp
      { name = "ultisnips" }, -- For ultisnips user.
      { name = "path" }, -- for path completion
      { name = "buffer", keyword_length = 2 }, -- for buffer word completion
    },
    completion = {
      keyword_length = 1,
      completeopt = "menu,noselect",
    },
    view = {
      entries = "custom",
    },
    -- solution taken from https://github.com/echasnovski/mini.nvim/issues/1007#issuecomment-2258929830
    formatting = {
      format = function(_, vim_item)
        local icon, hl = MiniIcons.get("lsp", vim_item.kind)
        vim_item.kind = icon .. " " .. vim_item.kind
        vim_item.kind_hl_group = hl
        return vim_item
      end,
    },
  }
  
  cmp.setup.filetype("tex", {
    sources = {
      { name = "omni" },
      { name = "ultisnips" }, -- For ultisnips user.
      { name = "buffer", keyword_length = 2 }, -- for buffer word completion
      { name = "path" }, -- for path completion
    },
  })
  
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
  
  --  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
  vim.cmd([[
    highlight! link CmpItemMenu Comment
    " gray
    highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    " blue
    highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    " light blue
    highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
    " pink
    highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
    " front
    highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
  ]])

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  --------------------------------------
  vim.lsp.config('pyright', {
    capabilities = capabilities
  })
  vim.lsp.enable('pyright')
	--------------------------------------
--  vim.lsp.config('ty', {
--    cmd = { "uvx", "ty", "server" }, -- Command to start the language server
--    filetypes = { "python" },
--    root_dir = require('lspconfig.util').root_pattern("pyproject.toml", ".git"), -- Detect project root
--    settings = {
--      -- ty language server specific settings
--    },
--    capabilities = capabilities
--  })
--  vim.lsp.enable('ty')
	--------------------------------------
EOF

lua << EOF
  require("codecompanion").setup({
		strategies = {
      chat = {
        adapter = 'gemini',
      },
      inline = {
        adapter = 'gemini',
      },
			cmd = {
				adapter = "gemini",
			},
    },
		adapters = {
			http = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						schema = {
							model = {
								default = "gemini-2.5-pro"
							},
						},
						env = {
							api_key = "AIzaSyAwPHP8pH8L7-INt8J4xSZvHesJsVCfJZw",
						},
					})
				end,
			},
		},
	})
EOF

"colorscheme nord
colorscheme flattened_dark

""" Show line numbers
set nu


""" Let mouse-drag select only text not line numbers
set mouse+=a


""" reload file if changed from elsewhere (TODO test if working)
set autoread


""" Preserves undo history upon writing and changing buffer.
""" This has no effect on history between sessions.
set hidden


""" Search using smartcase. Both are needed for normal behavior!
set ignorecase
set smartcase

""" Searching stops at the end of file
"set nowrapscan


""" Confirm whether to save when deleting or quitting a changed buffer
set confirm


""" Automatically save undo history between sessions.
set undofile


""" set a directory to store the undo history
set undodir=~/.vim/undo/


""" Hide ~ sign at empty lines
let &fcs='eob: '


""" Elect ; to be a leader
let mapleader = ";"


""" Removes ranger default key-binding of ;f.
""" btw, ;f is used by fzf for :Files [== :FZF]
let g:ranger_map_keys = 0


""" Defines godot executable. now working though!
let g:godot_executable="/Applications/Godot.app/Contents/MacOS/Godot -t --resolution 715x400 --position 725,0"
nnoremap <leader>G :AsyncStop<cr>:sleep 1<cr>:GodotRun<cr>
nnoremap <leader>X :AsyncStop<cr>


""" Show hidden files in ranger
""" Deprecating in favor of system wide ~/.config/ranger/rc.conf'
"let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'


""" Reloads vi with ;R or ;RR
""" R is consistent with tmux also, where C-b R is used for reloading config
nnoremap <leader>R :source $MYVIMRC<cr>
nnoremap <leader>RR :source $MYVIMRC<cr>


""" Open ranger with ;e
nnoremap <leader>e :Ranger<cr>

""" Buffer search with ;b
nnoremap <leader>b :Buffers<cr>

""" Search in Git files with ;;
nnoremap <leader><leader> :GitFiles<cr>

""" FZF files search with ;f
nnoremap <leader>f :Files<cr>

""" Rg search with ;Rg
nnoremap <leader>Rg :Rg<cr>

""" ;hh for searching vim file history
nnoremap <leader>hh :History<cr>

""" ;h; for searching vim command history
nnoremap <leader>h; :History:<cr>

""" ;h/ for searching vim find history
nnoremap <leader>h/ :History/<cr>


""" Removes bclose map of deleting buffer with ;bd
let g:bclose_no_plugin_maps = 1

""" Deletes current buffer with ;w
nnoremap <leader>w :bd<cr>

""" Goto last buffer with ;Tab
nnoremap <leader><Tab> :b#<cr>

""" Removes all highlights from matched chars
nnoremap <leader>/ :noh<cr>


""" C-s to save in vi. In mac, alacritty will convert Command-s to C-s.
nnoremap <C-s> :w<cr>
inoremap <C-s> <esc>:w<cr>

""" C-q to quit in vi.
nnoremap <C-q> :q<cr>

""" Removes trailing space by "; "
nnoremap <leader><space> :%s/\s\+$//e<cr>

nnoremap <leader>m :MinimapToggle<cr>

nnoremap <leader>\ <C-W>v
nnoremap <leader>- <C-W>s

" Enable clipboard synchronization globally
set clipboard^=unnamedplus

" Automatically trigger OSC 52 when text is yanked
autocmd TextYankPost * call s:Osc52Yank()

function! s:Osc52Yank()
    " Ensure we are only syncing default or clipboard yanks
    if v:event.regname == '' || v:event.regname == '+' || v:event.regname == '*'
        " Grab the yanked text directly from the active register to avoid E716
        let l:text = getreg(v:event.regname)
        
        " Base64 encode the string cleanly
        let l:b64 = system('base64 | tr -d "\n"', l:text)
        
        " Format into standard OSC 52 terminal sequence
        let l:seq = "\e]52;c;" . l:b64 . "\x07"
        
        " Send the escape sequence straight to the terminal
        call writefile([l:seq], '/dev/stderr', 'b')
    endif
endfunction

""" In visual mode, Y to copy to clipboard
vnoremap Y "*y


""" Switches 2 buffers left
map [2b [b[b
""" Switches 2 buffers right
map ]2b ]b]b


""" Upon saving a file, this code saves current buffer state so that
""" next vi will restore current buffers.
autocmd BufWritePost * call session#MakeSession()


""" Shift enter to insert newline in normal mode

""" Fix tab space
" by default, the indent is 2 spaces.
set tabstop=2 expandtab
set shiftwidth=2 expandtab
set softtabstop=2 expandtab

" for html files, 2 spaces
autocmd Filetype         html setlocal ts=2 sw=2 expandtab

" for python/java/javascript files, 4 spaces
autocmd Filetype       python setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype           sh setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype         java setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype   javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype          xml setlocal ts=4 sw=4 sts=0 expandtab
autocmd BufRead,BufNewFile *.gradle set filetype=groovy
autocmd Filetype       groovy setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype       gdscript setlocal tabstop=4 shiftwidth=4 sts=0


""" Enables italic font on comments
highlight Comment cterm=italic
highlight Comment gui=italic
