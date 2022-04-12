defmodule College.Schemas.Student do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:first_name, :last_name, :email, :date_of_birth, :courses]}
  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :date_of_birth, :date

    many_to_many :courses, College.Schemas.Course,
      join_through: College.Schemas.StudentsCourses,
      on_replace: :delete

    timestamps()
  end

  def changeset(student, params \\ %{}) do
    student
    |> cast(params, [:first_name, :last_name, :email, :date_of_birth])
    |> validate_required([:first_name, :email, :date_of_birth])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "this email has already been taken")
  end

  def changeset_register_course(%__MODULE__{} = student, course) do
    student
    |> cast(%{}, [:first_name, :last_name, :email, :date_of_birth])
    |> put_assoc(:courses, [course | student.courses])
  end
end
