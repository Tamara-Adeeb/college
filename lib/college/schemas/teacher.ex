defmodule College.Schemas.Teacher do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:first_name, :last_name, :email, :courses]}
  schema "teachers" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    has_many :courses, College.Schemas.Course, on_delete: :nilify_all
    timestamps()
  end

  def changeset(teacher, params \\ %{}) do
    teacher
    |> cast(params, [:first_name, :last_name, :email])
    |> cast_assoc(:courses)
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "this email has already been taken")
  end
end
