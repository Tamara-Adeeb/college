defmodule CollegeWeb.TeacherController do
  use CollegeWeb, :controller
  alias College.{Teacher , Course}
  alias College.Repo

  def index(conn, params) do
    infinite_cursor = Teacher.all_teachers(params)
    render(conn, "index.json", infinite_cursor: infinite_cursor)
  end

  def show(conn, %{"id" => id}) do
    case Teacher.get_teacher(id) do
      nil -> json(conn, %{error: "not found"})
      teacher -> render(conn, "show.json", teacher: teacher)
    end
  end

  def create(conn, params) do
    case Teacher.create_teacher(params) do
      {:ok, teacher} ->
        render(conn, "create.json", teacher: teacher |> Repo.preload(:courses))

      {:error, reason} ->
        render(conn, "error.json", error: reason.errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Teacher.delete_teacher(String.to_integer(id)) do
      {:ok, _teacher} -> json(conn, %{status: "ok"})
      _ -> json(conn, %{error: "not found"})
    end
  end

  def update(conn, params) do
    case Teacher.update_teacher(params) do
      {:ok, teacher} -> render(conn, "update.json", teacher: teacher |> Repo.preload(:courses))
      {:error, "not found"} -> json(conn, %{error: "not found"})
      {:error, reason} -> render(conn, "error.json", error: reason.errors)
    end
  end

  def all_courses_for_teacher(conn, %{"id" => id}) do
    case Teacher.get_courses_for_teacher(id) do
      {:ok, courses} ->
        courses = Enum.map(courses, fn course -> Course.update_metadate(course) end)
        render(conn, "list_of_courses.json", courses: courses)
      {:error, _} -> json(conn, %{error: "Teacher not found"})
    end
  end

  def all_students_for_teacher(conn, %{"id" => id}) do
    case Teacher.get_students_for_teacher(id) do
      {:error, "not found"} -> json(conn, %{error: "Teacher not found"})
      students -> render(conn, "list_of_students.json", students: students)
    end
  end


end
