defmodule DazzleWeb.TickerLive.FormData do

    defstruct [message: "Don't worry be happy", scroll: "scrolled", count: 20]
    @types %{message: :string, scroll: :string, count: :integer}

    def new(message, scroll, count) do
      %{message: message, scroll: scroll, count: count}
    end

    def change(form, params) do
      {form, @types}
      |> Ecto.Changeset.cast(params, Map.keys(@types))
      |> Ecto.Changeset.validate_length(:message, min: 4 , max: 12)
      |> Ecto.Changeset.validate_length(:scroll, min: 4 , max: 12)
      |> Ecto.Changeset.validate_number(:count, greater_than: 0, less_than: 361)
      |> Map.put(:action, :validate)
    end
end
