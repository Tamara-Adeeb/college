defmodule CollegeWeb.TeacherView do
  use CollegeWeb, :view
  alias CollegeWeb.CourseView
  alias CollegeWeb.StudentView
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

  def render("create.json", %{teacher: teacher}) do
    %{data: render_one(teacher, __MODULE__, "show.json")}
  end

  def render("update.json", %{teacher: teacher}) do
    %{data: render_one(teacher, __MODULE__, "show.json")}
  end

  def render("list_of_courses.json", %{courses: courses}) do
    %{
      data: %{
        courses: render_many(courses, CourseView, "show.json")
      }
    }
  end

  def render("list_of_students.json", %{students: students}) do
    %{
      data: %{
        students: render_many(students, StudentView, "show.json")
      }
    }
  end

  @fields [:id, :first_name, :last_name, :email, :date_of_birth, :gender, :address]
  def render("show.json", %{teacher: teacher}) do
    %{
      id: teacher.id,
      first_name: teacher.first_name,
      last_name: teacher.last_name,
      email: teacher.email,
      date_of_birth: teacher.date_of_birth,
      gender: teacher.gender,
      address: teacher.address
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
    } = error.teacher

    "field #{field}: #{text} #{inspect(validation)}"
  end
end
