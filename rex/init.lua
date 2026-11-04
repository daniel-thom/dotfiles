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
  title = "Open Scrollback in Editor",
  run = function(ctx)
    rex.exec({ "open", write_scrollback(ctx) })
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
