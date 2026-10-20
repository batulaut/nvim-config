-- =========================================================
-- DATA FILES
-- =========================================================
-- Helper module (no side effects) for the plain-text files in
-- data/ (next to init.lua). Those files hold things I edit
-- often — words, project folders — so they stay out of Lua.
--
-- File format: one entry per line. Blank lines and lines
-- starting with "#" are ignored.

local M = {}

-- Absolute path of a file or folder inside data/.
function M.path(name)
  return vim.fn.stdpath("config") .. "/data/" .. name
end

-- Modification time as a string, or nil if the file is missing.
-- Callers compare it to the previous value to know whether the
-- file changed since they last read it.
function M.mtime(name)
  local stat = vim.uv.fs_stat(M.path(name))
  return stat and (stat.mtime.sec .. "." .. stat.mtime.nsec) or nil
end

-- Entries of a data file (trimmed), or {} if the file is missing.
function M.read_lines(name)
  local file = io.open(M.path(name), "r")
  if not file then
    return {}
  end

  local entries = {}
  for line in file:lines() do
    line = vim.trim(line)
    if line ~= "" and not vim.startswith(line, "#") then
      entries[#entries + 1] = line
    end
  end
  file:close()

  return entries
end

return M
