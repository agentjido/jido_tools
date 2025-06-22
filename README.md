# Jido.Tools

This package has been deprecated. All tools have been moved to the [Jido.Action](https://github.com/agentjido/jido_action) package.

https://github.com/agentjido/jido_action

The module paths have not changed - so your code will continue to work as expected.

The package will be removed from Hex.pm sometime after 2025-09-01.

## Migration

The migration is simple. Just replace the `:jido_tools` dependency with `:jido_actions` in your `mix.exs` file.

```elixir
def deps do
  [
    {:jido_actions, "~> 0.1.0"}
  ]
end
```

