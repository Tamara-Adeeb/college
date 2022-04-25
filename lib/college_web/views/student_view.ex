defmodule CollegeWeb.StudentView do
  use CollegeWeb, :view
  alias CollegeWeb.CourseView
  alias CollegeWeb.JsonViewHelper

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

  def render("create.json", %{student: student}) do
    %{data: render_one(student, __MODULE__, "show.json")}
  end

  def render("delete.json", %{student: _student}) do
    %{status: "ok"}
  end

  def render("update.json", %{student: student}) do
    %{data: render_one(student, __MODULE__, "show.json")}
  end

  def render("register_course.json", %{student_course: {student, course}}) do
    %{
      data: %{
        student: render_one(student, __MODULE__, "show.json"),
        courses: render_one(course, CourseView, "show.json")
      }
    }
  end

  @fields [:id, :first_name, :last_name, :email, :date_of_birth, :gender, :address]
  def render("show.json", %{student: student}) do
    %{
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      emai: student.email,
      date_of_birth: student.date_of_birth,
      gender: student.gender,
      address: student.address
    }
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
    } = error.student

    "field #{field}: #{text} #{inspect(validation)}"
  end
end
