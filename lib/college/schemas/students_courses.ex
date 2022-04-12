defmodule College.Schemas.StudentsCourses do
  use Ecto.Schema
  import Ecto.Changeset

  schema "students_courses" do
    belongs_to :student, College.Schemas.Student
    belongs_to :course, College.Schemas.Course

    timestamps()
  end

  def changeset(students_courses, params \\ %{}) do
    students_courses
    |> cast(params, [])
    |> cast_assoc(:student, required: true)
    |> cast_assoc(:course, required: true)
    |> unique_constraint([:student_id, :course_id], name: :unique)
  end

  def changeset_foreign(students_courses, params \\ %{}) do
    students_courses
    |> cast(params, [:student_id, :course_id])
    |> validate_required([:student_id, :course_id])
    |> foreign_key_constraint(:student_id)
    |> foreign_key_constraint(:course_id)
  end
end
