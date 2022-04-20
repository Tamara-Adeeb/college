defmodule College.Schemas.Faculty.Engineering do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :branches, Ecto.Enum , values: [:civil, :chemical, :mechanical, :electrical, :industrial, :computer]
  end

  def changeset(first, params) do
    first
    |> cast(params, ~w(branches)a)
    |> validate_required(~w(branches)a)
  end


end
