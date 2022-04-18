defmodule College.Schemas.Student do
  use Ecto.Schema
  import Ecto.Changeset
  alias College.App
  alias College.Repo
  alias __MODULE__

  defimpl College.Person do
    def get(student) do
      student |> Student.fill_virtual_fields()
    end
  end

  @derive {Jason.Encoder, only: [:first_name, :last_name, :email, :date_of_birth, :courses]}
  schema "students" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :date_of_birth, :date
    field :gender, Ecto.Enum, values: [:female, :male]
    field :number_of_courses, :integer, virtual: true
    field :address, :string

    many_to_many :courses, College.Schemas.Course,
      join_through: College.Schemas.StudentsCourses,
      on_replace: :delete

    timestamps()
  end

  def fill_virtual_fields(%Student{} = student) do
    student = student |> Repo.preload(:courses)

    num =
      student.courses
      |> Enum.filter(fn course -> course.semester == :first end)
      |> length()

    Map.put(student, :number_of_courses, num)
  end

  def changeset(student, params \\ %{}) do
    student
    |> cast(params, [:first_name, :last_name, :email, :date_of_birth, :gender, :address])
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
