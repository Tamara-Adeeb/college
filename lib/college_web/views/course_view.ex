defmodule CollegeWeb.CourseView do
  use CollegeWeb, :view
  alias CollegeWeb.StudentView
  alias CollegeWeb.TeacherView
  alias CollegeWeb.JsonViewHelper
  @fields [:id, :name, :code, :semester, :description, :teacher_id]
  @relationships [{:students, StudentView, "show.json"}, {:teacher, TeacherView, "show.json"}]

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

  def render("create.json", %{course: course}) do
    %{
      status: "ok",
      data: render_one(course, __MODULE__, "show.json")
    }
  end

  def render("delete.json", %{course: _course}) do
    %{status: "ok"}
  end

  def render("update.json", %{course: course}) do
    %{status: "ok", data: render_one(course, __MODULE__, "show_relation.json")}
  end

  def render("show.json", %{course: course}) do
    JsonViewHelper.render_json(course, __MODULE__, @fields)
  end

  def render("show_relation.json", %{course: course}) do
    JsonViewHelper.render_json(course, __MODULE__, @fields, @relationships)
  end

  def render("error.json", %{error: error}) do
    %{
      error: render_many(error, __MODULE__, "show_error.json")
    }
  end

  def render("show_error.json", error) do
    IO.inspect(error)

    {
      field,
      {text, validation}
    } = error.course

    "field #{field}: #{text} #{inspect(validation)}"
  end
end
