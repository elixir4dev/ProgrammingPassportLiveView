defmodule DazzleWeb.TickerLive do
  use DazzleWeb, :live_view

  def render(assigns) do
    ~H"""
        <h1>Dazzle count tick: <%= @count %></h1>
        <div class="grid grid-cols-2">
            <!-- Extracted as a components
            <div style={style(@count)}>
              <h2>Rotated</h2>
            </div>

            <div>
              <pre>
                <h2 style="text-align: center;"><%= scrolled("scrolled", @count) %></h2>
              </pre>
            </div>
            -->
            <.rotated count={@count} message="rotated"/>
            <.rotated count={-@count} message="rotated"/>
            <.scroll count={@count} message="<- scrolled"/>
            <.scroll count={-@count} message="scrolled ->"/>
        </div>

        <h1>Dazzle Current Time tick: <%= @time %></h1>
    """
  end

  def mount(_param, _session, socket) do
      # we send a periodic tick via Erlang.
      # standard messages are events  handled by handle_info
    if connected?(socket), do: :timer.send_interval(250, self(), :tick)

    {:ok, assign(socket, count: 0, time: Time.utc_now |> Time.truncate(:second) )}
  end


  def handle_info(:tick, socket) do
    {:noreply, inc(socket) }
  end

  defp inc(socket) do
    assign(socket, count: compute_deg(socket.assigns.count + 1), time: update_time())
  end

  defp compute_deg(count) do
    rem(count, 360)
  end

  defp update_time() do
    Time.utc_now |> Time.truncate(:second)
  end


  attr :count, :integer, required: true
  def rotated(assigns) do
    ~H"""
        <div style={style(@count)}>
            <h2> <%= @message %></h2>
        </div>
      """
  end

  attr :count, :integer, required: true
  attr :message, :string
  def scroll(assigns) do
    ~H"""
      <div>
        <pre>
          <h2 style="text-align: center;"><%=scrolled(@message, @count) %></h2>
        </pre>
      </div>
    """
  end

  def style(count) do
    """
      transform: rotate(#{count}deg);
      text-align: center;
      width: 400px;"
    """
  end

  @doc """
    creates an scrolling effect.
    Add spaces before and after the string.
  """
  def scrolled(string, count) do
    len = String.length(string)
    count = rem(count, len * 2)
    spaces = String.duplicate(" ", len)
    message = spaces <> string <> spaces

    String.slice(message, count, len)
  end
end
