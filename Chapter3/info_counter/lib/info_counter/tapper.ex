defmodule InfoCounter.Tapper do

  def tap(name, count) do
    Phoenix.PubSub.broadcast(InfoCounter.PubSub, "sync", {:sync, name, count})
  end
end
