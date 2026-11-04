-- Name each tab after the git repo its terminal cd's into; outside a repo the name is left alone.
-- Run: rex do ~/.config/rex/tab_repo.lua --all
rex.on("terminal.pwd_changed", function(ctx, ev)
  local dir = ev.pwd:gsub("^file://[^/]*", "")
  local r = rex.exec({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
  if not (r and r.ok) then return end
  local b = rex.session.describe_block{ block_id = ctx.block_id }
  local w = b and b.block.window_id
  if not w then return end -- detached pane: no tab to rename
  rex.session.set_window_label{ window_id = w, label = r.stdout:match("([^/]+)%s*$") }
end)
