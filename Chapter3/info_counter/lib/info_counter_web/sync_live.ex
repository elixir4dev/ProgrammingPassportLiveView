defmodule InfoCounterWeb.SyncLive do
  use InfoCounterWeb, :live_view

  def mount(%{"count" => count, "name" => name}, _session, socket) do
    # name = String.to_atom(name)
    # count = String.to_integer(count)

    # Process.register(self(), name)
    # {:ok, assign(socket, name: name, count: count)}
    Phoenix.PubSub.subscribe(InfoCounter.PubSub, "sync")
    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
      <h1 class="text-2x1"><%= @name %>: <%= @count %></h1>
    """
  end

  def handle_params(%{"count" => count, "name" => name}, _url, socket) do
    {:noreply, assign(socket, name: name, count: String.to_integer(count))}
  end

  def handle_info({:sync, name, count}, socket) do
    {:noreply, push_patch(socket, to: "/sync/#{name}/#{count}")}
  end

  def handle_info({:share, count}, socket) do
    {:noreply, assign(socket, count: count)}
  end
end
