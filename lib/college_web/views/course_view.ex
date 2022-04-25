defmodule CollegeWeb.CourseView do
  use CollegeWeb, :view
  alias CollegeWeb.StudentView
  alias CollegeWeb.TeacherView
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

  def render("create.json", %{course: course}) do
    %{
      data: render_one(course, __MODULE__, "show.json")
    }
  end

  def render("create.json", %{course_teacher: data}) do
    [course, teacher] = data

    %{
      data: %{
        teacher: render_one(teacher, TeacherView, "show.json"),
        course: render_one(course, __MODULE__, "show.json")
      }
    }
  end

  def render("delete.json", %{course: _course}) do
    %{status: "ok"}
  end

  def render("update.json", %{course: course}) do
    %{data: render_one(course, __MODULE__, "show.json")}
  end

  def render("show.json", %{course: course}) do
    %{
      id: course.id,
      name: course.name,
      code: course.code,
      semester: course.semester,
      description: course.description,
      teacher_id: course.teacher_id,
      metadata: course.metadata
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
    } = error.course

    "field #{field}: #{text} #{inspect(validation)}"
  end
end
