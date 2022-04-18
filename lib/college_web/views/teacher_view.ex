defmodule CollegeWeb.TeacherView do
  use CollegeWeb, :view
  alias CollegeWeb.CourseView
  alias CollegeWeb.StudentView
  alias CollegeWeb.JsonViewHelper
  @fields [:id, :first_name, :last_name, :email, :date_of_birth, :gender, :address]
  @relationships [{:courses, CourseView, "show.json"}]

  def render("index.json", %{infinite_cursor: data}) do
    %{entries: entries, metadata: metadata} = data

    %{
      data: render_many(entries, __MODULE__, "show.json"),
      metadata: %{
        before: metadata.before,
        after: metadata.after,
        total_count: metadata.total_count
      }
    }
  end

  def render("create.json", %{teacher: teacher}) do
    %{status: "ok", data: render_one(teacher, __MODULE__, "show_relation.json")}
  end

  def render("update.json", %{teacher: teacher}) do
    %{status: "ok", data: render_one(teacher, __MODULE__, "show_relation.json")}
  end

  def render("list_of_courses.json", %{teacher: teacher}) do
    %{
      status: "ok",
      data: %{
        teacher: render_one(teacher, __MODULE__, "show_relation.json")
      }
    }
  end

  def render("list_of_students.json", %{data: {teacher, students}}) do
    %{
      status: "ok",
      data: %{
        teacher: render_one(teacher, __MODULE__, "show.json"),
        students: render_many(students, StudentView, "show.json")
      }
    }
  end

  def render("show.json", %{teacher: teacher}) do
    JsonViewHelper.render_json(teacher, __MODULE__, @fields)
  end

  def render("show_relation.json", %{teacher: teacher}) do
    JsonViewHelper.render_json(teacher, __MODULE__, @fields, @relationships)
  end

  def render("error.json", %{error: error}) do
    %{
      error: render_many(error, __MODULE__, "show_error.json")
    }
  end

  def render("show_error.json", error) do
    {
      field,
      {text, validation}
    } = error.teacher

    "field #{field}: #{text} #{inspect(validation)}"
  end
end
