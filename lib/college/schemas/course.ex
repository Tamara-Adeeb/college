defmodule College.Schemas.Course do
  alias College.Schemas.Semester.{First, Second, Third, Fourth}
  use Ecto.Schema
  import Ecto.Changeset
  import PolymorphicEmbed, only: [cast_polymorphic_embed: 3]

  @derive {Jason.Encoder, only: [:name, :code, :semester, :description, :teacher, :students]}
  schema "courses" do
    field :name, :string
    field :code, :string
    field :semester,PolymorphicEmbed,
      types: [
        first: [module: First, identify_by_fields: [:period, :is_optional]],
        second: [module: Second, identify_by_fields: [:period, :is_optional]],
        third: [module: Third, identify_by_fields:  [:period, :is_honor, :is_research]],
        fourth: [module: Fourth, identify_by_fields: [:period, :is_honor, :is_research]]
      ],
      on_type_not_found: :raise,
      on_replace: :update

    field :description, :string
    belongs_to :teacher, College.Schemas.Teacher

    many_to_many :students, College.Schemas.Student,
      join_through: College.Schemas.StudentsCourses,
      on_replace: :delete

    timestamps()
  end

  def changeset(courses, params \\ %{}) do
    IO.inspect(params)
    # first = Map.delete(%First{period: "1", is_optional: true}, :__meta__) |> Map.delete(:__struct__) |> IO.inspect()
    # {_ , params }= Map.get_and_update(params, "semester",fn current_value -> {current_value,%{is_optional: true, period: "1"}} end)
    courses
    |> cast(params, [:name, :code, :description, :teacher_id])
    |> validate_required([:name, :code, :teacher_id])
    |> foreign_key_constraint(:teacher)
    |> unique_constraint(:code, message: "this code has already been taken") |> IO.inspect()
    # |> cast_polymorphic_embed(:semester, required: false)
    |> cast_polymorphic_embed(:semester,
      with: [
        first: &First.changeset/2,
        second: &Second.changeset/2,
        third: &Third.changeset/2,
        fourth: &Fourth.changeset/2
      ]
    )
    |> unique_constraint(:code, message: "this code has already been taken") |> IO.inspect()
  end

  def validate_semester(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, value ->
      case value in ["first", "second", "third", "fourth"] do
        true -> []
        false -> [{field, options[:message] || "Invalid semester"}]
      end
    end)
  end
end
