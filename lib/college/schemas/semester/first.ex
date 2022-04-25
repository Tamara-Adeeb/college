defmodule College.Schemas.Semester.First do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:period, :string)
    field(:is_optional, :boolean)
  end

  def changeset(first, params) do
    first
    |> cast(params, ~w(period is_optional)a)
    |> validate_required(~w(period is_optional)a)
  end
end
