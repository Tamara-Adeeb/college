defmodule College.Schemas.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  alias College.Repo
  alias College.Teacher

  @field [:first_name, :last_name, :email, :date_of_birth, :gender, :address]
  @required_field [:first_name, :email, :date_of_birth, :gender, :address]

  defimpl College.Person do
    def get(teacher, id) do
      case Teacher.get_teacher(id) do
        nil ->
          {:error, "not found"}

        teacher ->
          {:ok, number_virtual_field(teacher)}
      end
    end

    defp number_virtual_field(teacher) do
      teacher = teacher |> Repo.preload(:courses)
      num = length(teacher.courses)

      Map.put(teacher, :number_of_courses, num)
      |> Map.take([:gender, :date_of_birth, :address, :number_of_courses])
    end
  end

  @derive {Jason.Encoder, only: [:first_name, :last_name, :email, :courses]}
  schema "teachers" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:date_of_birth, :date)
    field(:gender, Ecto.Enum, values: [:female, :male])
    field(:number_of_courses, :integer, virtual: true)
    field(:address, :string)
    has_many(:courses, College.Schemas.Course, on_delete: :nilify_all)
    timestamps()
  end

  def changeset(teacher, params \\ %{}) do
    teacher
    |> cast(params, @field)
    |> cast_assoc(:courses)
    |> validate_required(@required_field)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "this email has already been taken")
  end
end
