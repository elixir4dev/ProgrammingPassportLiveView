defmodule OrganizationWeb.Notebook do
  use OrganizationWeb, :live_component

  attr :expanded, :any
  slot :page do
     attr :tab, :string
  end
  def render(assigns) do
    ~H"""
      <div>
        <.tabs tabs={@tabs} expanded={@expanded} target={@myself}/>
        <.page
          :for={page <- @page}
          tab={page[:tab]}
          expanded={@expanded}
          inner_block={page}
        />
      </div>
    """
  end

  @spec update(maybe_improper_list() | map(), any()) :: {:ok, any()}
  def update(assings, socket) do
    {:ok, assign(socket, assings)}
  end


  def handle_event("expand", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :expanded, tab)}
  end

  defp button_class(expanded) do
    "bg-slate-#{bshade(expanded)} hover:bg-slate-50 text-slate-700 font-bold p-2"
  end

  defp bshade(true), do: 100
  defp bshade(false), do: 300

  attr :target, :any
  attr :tabs, :list, default: []
  attr :expanded, :string, default: nil
  defp tabs(assigns) do
    ~H"""
       <ul class="flex flex-wrap">
          <li class="mr-8" :for={tab <- @tabs}>
            <button
               class={button_class(@expanded==tab)}
               phx-click="expand"
               phx-value-tab={tab}
               phx-target={@target}
               >
              <%=tab%>
            </button>
          </li>
       </ul>
    """
  end

  attr :expanded, :boolean
  attr :tab, :string
  slot :inner_block
  defp page(assigns) do
    ~H"""
    <div
      :if={@expanded==@tab}
      class="bg-slate-100 p-6">
      <%= render_slot(@inner_block)%>
    </div>
    """
  end
end
