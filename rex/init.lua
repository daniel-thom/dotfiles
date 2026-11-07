-- Ghostty's write_scrollback_file:open / :paste.
local REX = os.getenv("HOME") .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"

local function write_scrollback(ctx)
  local tmp = os.tmpname()
  os.remove(tmp)
  local path = tmp .. ".txt"
  -- Shell redirect so large scrollback doesn't hit the API reply size limit.
  local r, err = rex.exec({ "sh", "-c", '"$0" capture -s "$1" -b "$2" --trim > "$3"',
    REX, ctx.session_id, ctx.block_id, path })
  if not r then error(err, 0) end
  if not r.ok then error(r.stderr, 0) end
  return path
end

rex.action{
  name = "scrollback_open",
  title = "Open Scrollback in Floating nvim",
  run = function(ctx)
    local path = write_scrollback(ctx)
    local _, err = rex.session.new_layer({
      bounds = { 0.05, 0.05, 0.9, 0.85 }, focus = true,
      layout = rex.layout.block{ flavor = "com.superlogical.terminal.shell", label = "scrollback",
        options = { command = { "zsh", "-lc", 'nvim + "$1"; rm -f "$1"', "zsh", path } } },
    })
    if err then error(err, 0) end
  end,
}

rex.action{
  name = "scrollback_paste",
  title = "Paste Scrollback File Path",
  run = function(ctx)
    local path = write_scrollback(ctx)
    rex.block.call("com.superlogical.terminal", "write", { block_id = ctx.block_id, data = path })
  end,
}

-- Fuzzy-pick any terminal across all sessions (app + cwd), Enter switches to it.
-- Switching sessions needs Remote Control on (Settings > Rex Server).
local PICK_SH = [[
sel=$(fzf --delimiter='\t' --with-nth=1,2,3 --prompt='pane> ' < "$1"); rm -f "$1"
[ -n "$sel" ] || exit 0
sid=$(printf %s "$sel" | cut -f4); wid=$(printf %s "$sel" | cut -f5); bid=$(printf %s "$sel" | cut -f6)
"$2" do -C "$3" session.select session_id="$sid" window_id="$wid" || { read -r _; exit 1; }
"$2" focus -s "$sid" "$bid"
]]

rex.action{
  name = "pane_pick",
  title = "Pick Pane Across Sessions…",
  keywords = "find search jump terminal cwd",
  run = function(ctx)
    -- Attach to every session, or calls into the others fail with "not attached".
    local sessions = assert(rex.call("session.attach_all", { event_scope = "session" })).sessions
    local lines = {}
    for _, s in ipairs(sessions) do
      local r = rex.session.list_blocks({ session_id = s.session_id })
      for _, b in ipairs(r and r.blocks or {}) do
        if b.creator_name == "com.superlogical.terminal" and b.window_id then
          local p = rex.block.call(b.creator_name, "process", { session_id = s.session_id, block_id = b.block_id })
          local fg = p and p.foreground or {}
          lines[#lines + 1] = table.concat({ s.label or "-", fg.script or fg.argv0 or fg.name or "-",
            fg.cwd or "-", s.session_id, b.window_id, b.block_id }, "\t")
        end
      end
    end
    local list = os.tmpname()
    local f = assert(io.open(list, "w"))
    f:write(table.concat(lines, "\n"), "\n")
    f:close()
    local _, err = rex.session.new_layer({
      bounds = { 0.15, 0.15, 0.7, 0.6 },
      focus = true,
      layout = rex.layout.block{ flavor = "com.superlogical.terminal.shell",
        options = { command = { "sh", "-c", PICK_SH, "sh", list, REX, ctx.client_id } } },
    })
    if err then error(err, 0) end
  end,
}
rex.bind("cmd+shift+j", "pane_pick")

rex.bind("cmd+shift+o", "scrollback_open")
rex.bind("alt+cmd+shift+o", "scrollback_paste")

-- Run pytest in a floating pane in the focused pane's directory; drops to a shell when done.
rex.action{
  name = "pytest_float",
  title = "Run pytest in Floating Pane",
  keywords = "test python",
  run = function(ctx)
    local r = rex.block.call("com.superlogical.terminal", "pwd", { block_id = ctx.block_id })
    -- ponytail: pwd is a file:// URL; percent-encoded paths (spaces) aren't decoded
    local cwd = r and r.pwd and r.pwd:gsub("^file://[^/]*", "") or nil
    local l, err = rex.session.new_layer({
      bounds = { 0.1, 0.1, 0.8, 0.7 },
      focus = true,
      layout = rex.layout.block{ flavor = "com.superlogical.terminal.shell", label = "pytest",
        options = { cwd = cwd, command = { "zsh", "-c", "[ -f .venv/bin/activate ] && . .venv/bin/activate; pytest tests; exec zsh" } } },
    })
    if err then error(err, 0) end
    return { layer_id = l.layer_id }
  end,
}
rex.bind("cmd+shift+u", "pytest_float")

-- Open a floating shell in the focused pane's directory.
rex.action{
  name = "shell_float",
  title = "New Floating Shell",
  keywords = "float floating terminal scratch",
  run = function(ctx)
    local r = rex.block.call("com.superlogical.terminal", "pwd", { block_id = ctx.block_id })
    local cwd = r and r.pwd and r.pwd:gsub("^file://[^/]*", "") or nil
    local l, err = rex.session.new_layer({
      bounds = { 0.1, 0.1, 0.8, 0.7 }, focus = true,
      layout = rex.layout.block{ flavor = "com.superlogical.terminal.shell", options = { cwd = cwd } },
    })
    if err then error(err, 0) end
    return { layer_id = l.layer_id }
  end,
}
rex.bind("cmd+shift+f", "shell_float")

-- Detach the focused pane: it keeps running but leaves its tab.
rex.action{
  name = "pane_detach",
  title = "Detach Pane",
  keywords = "hide park background",
  run = function(ctx)
    local _, err = rex.session.detach_block{ block_id = ctx.block_id }
    if err then error(err, 0) end
  end,
}

-- Pick a detached pane with fzf and split it in below the focused pane.
local REATTACH_SH = [[
sel=$(fzf --delimiter='\t' --with-nth=1,2,3 --prompt='reattach> ' < "$1"); rm -f "$1"
[ -n "$sel" ] || exit 0
bid=$(printf %s "$sel" | cut -f4)
"$2" api call -s "$3" session.move_block "{\"block_id\":\"$bid\",\"anchor_block_id\":\"$4\",\"direction\":\"vertical\"}" >/dev/null || { read -r _; exit 1; }
"$2" focus -s "$3" "$bid"
]]

rex.action{
  name = "pane_reattach",
  title = "Reattach Detached Pane…",
  keywords = "restore unhide detached bring back",
  run = function(ctx)
    local r = rex.session.list_blocks{}
    local lines = {}
    for _, b in ipairs(r and r.blocks or {}) do
      if not b.window_id and b.creator_name == "com.superlogical.terminal" then
        local p = rex.block.call(b.creator_name, "process", { block_id = b.block_id })
        local fg = p and p.foreground or {}
        lines[#lines + 1] = table.concat({ b.label or "-", fg.script or fg.argv0 or fg.name or "-",
          fg.cwd or "-", b.block_id }, "\t")
      end
    end
    if #lines == 0 then error("no detached panes", 0) end
    local list = os.tmpname()
    local f = assert(io.open(list, "w"))
    f:write(table.concat(lines, "\n"), "\n")
    f:close()
    local here = rex.session.describe_block{ block_id = ctx.block_id }
    local _, err = rex.session.new_layer({
      bounds = { 0.15, 0.15, 0.7, 0.5 },
      window_id = here and here.block.window_id,
      focus = true,
      layout = rex.layout.block{ flavor = "com.superlogical.terminal.shell",
        options = { command = { "sh", "-c", REATTACH_SH, "sh", list, REX, ctx.session_id, ctx.block_id } } },
    })
    if err then error(err, 0) end
  end,
}

rex.bind("cmd+shift+h", "pane_detach")
rex.bind("cmd+shift+r", "pane_reattach")
