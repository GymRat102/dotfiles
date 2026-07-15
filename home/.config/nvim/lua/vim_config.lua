local o = vim.opt
local g = vim.g
local cmd = vim.cmd

-- Leader
g.mapleader = " "

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true

-- Scroll
o.scrolloff = 8

-- Line numbers
o.number = true
o.relativenumber = true

-- Syntax
cmd("syntax on")

-- Regex engine
o.regexpengine = 0 -- auto-select regex engine

-- Colorscheme
o.background = "dark"
-- cmd.colorscheme("hybrid")

-- Search
o.hlsearch = true
o.incsearch = true
cmd("nohlsearch")

-- matchparen
g.matchparen_disable_cursor_hl = 1

-- Folding
o.foldmethod = "indent"

-- Clipboard
o.clipboard = "unnamedplus"

-- Search case sensitivity
o.ignorecase = true
o.smartcase = true
