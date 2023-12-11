defmodule DazzleWeb.TickerLive do
  use DazzleWeb, :live_view

  alias DazzleWeb.TickerLive.FormData

  def render(assigns) do
    ~H"""
        <div phx-window-keydown="keydown">
          <h1 class="text-lg font-semibold">
              <.arrow_link direction="decrement" />
              <br>
              <%= @count %>
              <br>
              <.arrow_link direction="increment" />
          </h1>
          <div class="grid grid-cols-2">
             <.rotated count={@count} message={@message}/>
             <.rotated count={-@count} message={@message}/>
             <.scroll count={@count} message={"<-#{@scroll}"}/>
             <.scroll count={-@count} message={"#{@scroll}->"}/>
         </div>

         <.simple_form
           for={@changeset}
           id="user-form"
           phx-change="validate"
           phx-submit="save"
           as={:form}
        >
          <.input field={@changeset[:message]} type="text" label="Message" />
          <.input field={@changeset[:scroll]}    type="text" label="Scroll" />
          <.input field={@changeset[:count]}    type="number" label="Count" />
          <.button type="submit" phx-disable-with="Saving...">Update Dazzle </.button>
        </.simple_form>

        </div>
    """
  end

  @spec mount(any(), any(), Phoenix.LiveView.Socket.t()) :: {:ok, any()}
  def mount(_param, _session, socket) do
    count = 20
    message = "Dazzle"
    scroll = "Scrolled"

    changeset =
       FormData.new(message, scroll, count)
       |> FormData.change(%{})
       |> to_form(as: "form")

    {:ok, assign(socket, count: count, message: message, scroll: scroll, changeset: changeset)}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    {:noreply, validate(socket, params)}
  end


  def handle_event("save", %{"form" => params}, socket) do
    {:noreply, save(socket, params)}
  end


  def handle_event("change", %{"direction" => "decrement"}, socket) do
    {:noreply, dec(socket)}
  end

  def handle_event("change", %{"direction" => "increment"}, socket) do
    {:noreply, inc(socket)}
  end


  def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
    {:noreply, inc(socket)}
  end

  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply, dec(socket)}
  end

  def handle_event("keydown", _, socket) do
    {:noreply, socket}
  end


  defp validate(socket, params) do
    changeset =
        FormData.new(socket.assigns.message, socket.assigns.scroll, socket.assigns.count)
        |> FormData.change(params)
        |> to_form(as: "form")

    assign(socket, changeset: changeset)

  end


  defp save(socket, params) do
    changeset =
      FormData.new(socket.assigns.message, socket.assigns.scroll, socket.assigns.count)
      |> FormData.change(params)

    apply_changes(socket, changeset.changes, changeset.valid?)
  end

  defp apply_changes(socket, changes, true) do
    assign(socket, Map.to_list(changes))
  end

  defp apply_changes(socket, _changes, _valid), do: socket


  attr :direction, :string, required: true, values: ~w[increment decrement]
  def arrow_link(assigns) do
    ~H"""
      <span
        phx-click="change"
        phx-value-direction={@direction}
      >
      &#<%=unicode(@direction)%>;
      </span>
     """
  end

  defp unicode("decrement"), do: 9668
  defp unicode("increment"), do: 9658

  defp inc(socket) do
    count = compute_deg(socket.assigns.count + 1)
    assign(socket, count: count)
    |> validate(FormData.new(socket.assigns.message, socket.assigns.scroll, count))
  end

  defp dec(socket) do
    count = compute_deg(socket.assigns.count + 1)
    assign(socket, count: count)
    |> validate(FormData.new(socket.assigns.message, socket.assigns.scroll, count))
  end

  defp compute_deg(number) do
    rem(number, 360)
  end

  attr :count, :integer, required: true
  attr :message, :string
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
