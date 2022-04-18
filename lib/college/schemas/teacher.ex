defmodule College.Schemas.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  alias College.App
  alias College.Repo
  alias __MODULE__

  defimpl College.Person, for: Teacher do
    def get(teacher) do
      teacher |> Teacher.number_virtual_field()
    end
  end

  @derive {Jason.Encoder, only: [:first_name, :last_name, :email, :courses]}
  schema "teachers" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :date_of_birth, :date
    field :gender, Ecto.Enum, values: [:female, :male]
    field :number_of_courses, :integer, virtual: true
    field :address, :string
    has_many :courses, College.Schemas.Course, on_delete: :nilify_all
    timestamps()
  end

  def number_virtual_field(%Teacher{} = teacher) do
    teacher = teacher |> Repo.preload(:courses)
    num = length(teacher.courses)
    Map.put(teacher, :number_of_courses, num)
  end

  def changeset(teacher, params \\ %{}) do
    teacher
    |> cast(params, [:first_name, :last_name, :email, :date_of_birth, :gender, :address])
    |> cast_assoc(:courses)
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "this email has already been taken")
  end
end
