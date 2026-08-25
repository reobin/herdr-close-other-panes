# herdr-close-other-panes

A [herdr](https://herdr.dev) plugin that closes every pane in the current tab except the one you invoked it from.

## Install

```bash
herdr plugin install reobin/herdr-close-other-panes
```

Requires herdr 0.8.0 or newer.

## Use

The action shows up in the command palette as **Close other panes**. It closes every other pane in the current tab and leaves other tabs alone. Panes close without confirmation and whatever is running in them is terminated, so bind it with care.

To bind this action to a key, add this to your herdr config:

```toml
[[keys.command]]
key = "prefix+o"
type = "plugin_action"
command = "reobin.close-other-panes.close-others"
description = "close other panes"
```

To invoke it without a keybinding:

```bash
herdr plugin action invoke reobin.close-other-panes.close-others
```

## License

MIT
