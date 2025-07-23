return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    suppressed_dirs = { '~/' },
    cwd_change_handling = true,
    purge_after_minutes = 1440,
    -- log_level = 'debug',
  }
}
