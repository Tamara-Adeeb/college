defmodule College.Schemas.Course do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :code, :semester, :description, :teacher, :students]}
  schema "courses" do
    field :name, :string
    field :code, :string
    field :semester, :string
    field :description, :string
    belongs_to :teacher, College.Schemas.Teacher

    many_to_many :students, College.Schemas.Student,
      join_through: College.Schemas.StudentsCourses,
      on_replace: :delete

    timestamps()
  end

  def changeset(courses, params \\ %{}) do
    courses
    |> cast(params, [:name, :code, :semester, :description, :teacher_id])
    |> validate_required([:name, :code, :semester, :teacher_id])
    |> foreign_key_constraint(:teacher)
    |> unique_constraint(:code, message: "this code has already been taken")
  end
end
