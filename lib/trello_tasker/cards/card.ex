defmodule TrelloTasker.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(card \\ %__MODULE__{}, attrs \\ %{}) do
    card
    |> cast(attrs, [:path])
    |> unique_constraint(:path, message: "Card já existe!")
    |> validate_required([:path])
  end
end
