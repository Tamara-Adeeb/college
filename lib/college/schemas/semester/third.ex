defmodule College.Schemas.Semester.Third do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :period, :string
    field :is_honor, :boolean
    field :is_research, :boolean
  end

  def changeset(third, params) do
    third
    |> cast(params, ~w(period is_honor is_research)a)
    |> validate_required(~w(period is_honor is_research)a)
  end
end
