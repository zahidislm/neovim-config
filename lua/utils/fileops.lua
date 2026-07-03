-- Utils for file operations
-- Cuurently supports `New File`, `File Rename/Move File`

local M = {}

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------
--- Lets LSP clients know that a file has been renamed
---@param from         string
---@param to           string
---@param rename_expr? fun()
local function on_rename_file(from, to, rename_expr)
  local changes = {
    files = {
      {
        oldUri = vim.uri_from_fname(from),
        newUri = vim.uri_from_fname(to),
      },
    },
  }

  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client:supports_method("workspace/willRenameFiles") then
      local resp = client:request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end

  if rename_expr then rename_expr() end

  for _, client in ipairs(clients) do
    if client:supports_method("workspace/didRenameFiles") then
      client:notify("workspace/didRenameFiles", changes)
    end
  end
end

--- Rename a file and update buffers
---@param from string
---@param to   string
---@return boolean ok
local function rename(from, to)
  from = vim.fn.fnamemodify(from, ":p")
  to = vim.fn.fnamemodify(to, ":p")
  vim.fn.mkdir(vim.fs.dirname(to), "p") -- ensure target directory exists
  -- rename the file
  local ret = vim.fn.rename(from, to)
  if ret ~= 0 then
    vim.notify("Failed to rename file: `" .. from .. "`")
    return false
  end

  -- replace buffer in all windows
  local from_buf = vim.fn.bufnr(from)
  if from_buf >= 0 then
    local to_buf = vim.fn.bufadd(to)
    vim.bo[to_buf].buflisted = true
    for _, win in ipairs(vim.fn.win_findbuf(from_buf)) do
      vim.api.nvim_win_call(win, function ()
        vim.cmd("buffer " .. to_buf)
      end)
    end

    vim.api.nvim_buf_delete(from_buf, { force = true })
  end
  return true
end

-- ---------------------------------------------------------------------------
-- Utilities
-- ---------------------------------------------------------------------------
function M.smart_new_file()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local rel_dir = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":~:.:h") or ""

  local sep = package.config:sub(1, 1)
  local default_input = ""

  if rel_dir ~= "" and rel_dir ~= "." then
    local parts = vim.split(rel_dir, sep, { trimempty = true })
    if #parts <= 3 then
      default_input = rel_dir .. sep
    end
  end

  vim.ui.input({
    prompt = "Create file: ",
    default = default_input,
    completion = "file",
  },
    function (input)
      if not input or input == "" or input == default_input then
        return
      end

      local target_file = vim.fn.expand(input)
      local function proceed(overwrite)
        local target_dir = vim.fn.fnamemodify(target_file, ":h")

        if vim.fn.isdirectory(target_dir) == 0 then
          vim.fn.mkdir(target_dir, "p")
        end

        -- Open the file
        vim.cmd("edit " .. vim.fn.fnameescape(target_file))

        if overwrite then
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
          vim.notify("Buffer cleared for overwrite. (Press 'u' to undo)", vim.log.levels.WARN)
        end
      end

      -- Fast IO check if file already exists using Neovim's uv loop
      if vim.uv.fs_stat(target_file) then
        vim.ui.select(
          { "Yes", "No" },
          {
            prompt = string.format(
              "File '%s' already exists. Overwrite?", vim.fn.fnamemodify(target_file, ":t")
            ),
          },
          function (choice)
            if choice == "Yes" then
              proceed(true)
            else
              vim.notify("File creation aborted.", vim.log.levels.INFO)
            end
          end
        )
      else
        proceed(false)
      end
    end)
end

-- Renames the provided file, or the current buffer's file.
-- Prompt for the new filename if `to` is not provided.
-- do the rename, and trigger LSP handlers
---@param opts? { from?: string, to?: string, on_rename?: fun(to: string, from: string, ok: boolean) }
function M.rename_file(opts)
  opts = opts or {}

  local from = vim.fn.fnamemodify(opts.from or opts.file or vim.api.nvim_buf_get_name(0), ":p")
  local to = opts.to and vim.fn.fnamemodify(opts.to, ":p") or nil
  from, to = vim.fs.normalize(from), to and vim.fs.normalize(to) or nil

  local function rename_handler()
    assert(to, "to is required")
    on_rename_file(from, to, function ()
      local ok = rename(from, to)
      if opts.on_rename then
        opts.on_rename(to, from, ok)
      end
    end)
  end

  if to then return rename_handler() end
  local root = vim.fs.normalize(vim.fn.getcwd(0))

  -- file is outside cwd, use its parent dir as root
  if from:find(root, 1, true) ~= 1 then root = vim.fs.dirname(from) end
  local extra = from:sub(#root + 2)

  vim.ui.input({
    prompt = "New File Name: ",
    default = extra,
    completion = "file",
  },
    function (value)
      if not value or value == "" or value == extra then return end
      to = vim.fs.normalize(root .. "/" .. value)
      rename_handler()
    end)
end

return M
