defmodule OrganizationWeb.WordComponent do
  use Phoenix.Component

  alias Organization.Word
  alias OrganizationWeb.Notebook

  attr :word, :string, required: true
  def wordbook(assigns) do
    word = Word.new(assigns.word)
    ~H"""
      <.live_component
        module={Notebook}
        id={:word}
        expanded="Word"
        tabs={~w[Word First Size Histogram]}
        word={@word}
      >
        <:page tab="Word">
          <.word_page word={word}/>
        </:page>
        <:page tab="First">
          <.first_page word={word}/>
        </:page>
        <:page tab="Size">
          <.size_page word={word}/>
        </:page>
        <:page tab="Histogram">
          <.histogram_page word={word}/>
        </:page>
      </.live_component>
    """
  end

  attr :word, :any, required: true
  def word_page(assigns) do
    ~H"""
      <p class="text-3xl"><%=@word.word%></p>
    """
  end

  attr :word, :any, required: true
  def first_page(assigns) do
    ~H"""
      <p class="text-3xl"><%=@word.first_letter%></p>
    """
  end

  attr :word, :any, required: true
  def size_page(assigns) do
    ~H"""
      <p class="text-3xl"><%=@word.size%></p>
    """
  end

  attr :word, :any, required: true
  def histogram_page(assigns) do
    #max = assigns.word.histogram |> Map.values() |> Enum.max()
    ~H"""
      <%= for {letter, size} <- @word.histogram do %>
        <p><%=letter%> <%= String.duplicate("■", size) %></p>
      <%end%>
    """
  end


end
