defmodule College.Schemas.Semester.Second do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field(:period, :string)
    field(:is_optional, :boolean)
  end

  def changeset(second, params) do
    second
    |> cast(params, ~w(period is_optional)a)
    |> validate_required(~w(period is_optional)a)
  end
end
