---
title: "Custom instrumentation for Elixir"
---

## Elixir instrumentation

Using the `Appsignal.Instrumentation.Decorators` Decorators it's possible to
add custom instrumentation to your Elixir applications.

In this example, the `index/2` function in a Phoenix controller calls out to
a slow function. Since that function is instrumented using the
`transaction_event` decorator, it'll show up in AppSignal as a separate event
from the rest of the request.

```elixir
defmodule AppsignalPhoenixExample.PageController do
  use AppsignalPhoenixExample.Web, :controller
  use Appsignal.Instrumentation.Decorators

  def index(conn, _params) do
    slow
    render conn, "index.html"
  end

  @decorate transaction_event
  defp slow do
    :timer.sleep(1000)
  end
end
```

For more information please visit the [Appsignal Hex package
documentation](https://hexdocs.pm/appsignal/).
