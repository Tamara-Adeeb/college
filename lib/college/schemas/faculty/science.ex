defmodule College.Schemas.Faculty.Science do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :branches, Ecto.Enum , values: [:physics, :biology, :chemistry, :math, :anatomy, :statistics]
  end

  def changeset(first, params) do
    first
    |> cast(params, ~w(branches)a)
    |> validate_required(~w(branches)a)
  end


end
