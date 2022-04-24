defmodule College.Schemas.Course do
  alias College.Schemas.Semester.{First, Second, Third, Fourth}
  use Ecto.Schema
  import Ecto.Changeset
  import PolymorphicEmbed, only: [cast_polymorphic_embed: 3]

  schema "courses" do
    field :name, :string
    field :code, :string
    field :faculty, Ecto.Enum, values: [:history, :engineering, :art, :science, :law]

    field :branch, :string

    field :semester, Ecto.Enum, values: [:first, :second, :third, :fourth], null: false

    field :metadata, PolymorphicEmbed,
      types: [
        first: First,
        second: Second,
        third: Third,
        fourth: Fourth
      ],
      on_type_not_found: :changeset_error,
      on_replace: :update

    field :description, :string
    belongs_to :teacher, College.Schemas.Teacher

    many_to_many :students, College.Schemas.Student,
      join_through: College.Schemas.StudentsCourses,
      on_replace: :delete

    timestamps()
  end

  def changeset(courses, params \\ %{}) do
    params =
      case params["semester"] do
        nil -> params
        _ -> put_polymorphic_type(params)
      end

    courses
    |> cast(params, [:name, :code, :description, :teacher_id, :semester, :faculty])
    |> cast_polymorphic_embed(:metadata,
      required: true,
      message: "metatdata should be of type map"
    )
    |> validate_required([:name, :code, :teacher_id, :faculty])
    |> changeset_branch(params)
    |> foreign_key_constraint(:teacher)
    |> unique_constraint(:code, message: "this code has already been taken")
  end

  defp put_polymorphic_type(%{"semester" => semester, "metadata" => metadata} = params)
       when is_map(metadata) do
    metadata = Map.put(metadata, "__type__", semester)
    Map.put(params, "metadata", metadata)
  end

  defp changeset_branch(changeset, params) do
    case get_field(changeset, :faculty) do
      :engineering ->
        validate_inclusion(changeset, :branch, [
          "civil",
          "chemical",
          "mechanical",
          "electrical",
          "industrial",
          "computer"
        ])
        |> cast(params, [:branch])
        |> validate_required(:branch, message: "branch field is required for engineering faculty")

      :history ->
        changeset

      :law ->
        changeset

      :art ->
        validate_inclusion(changeset, :branch, [
          "creative",
          "arts",
          "writing",
          "philosophy",
          "humanities"
        ])
        |> cast(params, [:branch])
        |> validate_required(:branch, message: "branch field is required for art faculty")

      :science ->
        validate_inclusion(changeset, :branch, [
          "physics",
          "biology",
          "chemistry",
          "math",
          "anatomy",
          "statistics"
        ])
        |> cast(params, [:branch])
        |> validate_required(:branch, message: "branch field is required for science faculty")
    end
  end
end
