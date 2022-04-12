defmodule CollegeWeb.TeacherController do
  use CollegeWeb, :controller
  alias College.App
  alias College.Repo

  def index(conn, params) do
    infinite_cursor = App.all_teachers(params)
    render(conn, "index.json", infinite_cursor: infinite_cursor)
  end

  def create(conn, params) do
    case App.create_teacher(params) do
      {:ok, teacher} ->
        render(conn, "create.json", teacher: teacher |> Repo.preload(:courses))

      {:error, reason} ->
        render(conn, "error.json", error: reason.errors)
    end
  end

  def create_teaacher_with_course(conn, params) do
    case App.create_course_teacher(params) do
      {:ok, [course, teacher]} ->
        render(conn, "create.json", course_teacher: [course, teacher])

      {:ok, {:error, reason}} ->
        render(conn, "error.json", error: reason.errors)

      {:error, changeset} ->
        render(conn, "error.json", error: changeset.errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    case App.delete_teacher(String.to_integer(id)) do
      {:ok, _teacher} -> json(conn, %{status: "ok"})
      _ -> json(conn, %{error: "not found"})
    end
  end

  def update(conn, params) do
    case App.update_teacher(params) do
      {:ok, teacher} -> render(conn, "update.json", teacher: teacher |> Repo.preload(:courses))
      {:error, "not found"} -> json(conn, %{error: "not found"})
      {:error, reason} -> render(conn, "error.json", error: reason.errors)
    end
  end

  def all_courses_for_teacher(conn, %{"id" => id}) do
    case App.get_courses_for_teacher(id) do
      {:ok, teacher} -> render(conn, "list_of_courses.json", teacher: teacher)
      {:error, _} -> json(conn, %{error: "Teacher not found"})
    end
  end

  def all_students_for_teacher(conn, %{"id" => id}) do
    case App.get_students_for_teacher(id) do
      {:error, "not found"} -> json(conn, %{error: "Teacher not found"})
      {teacher, students} -> render(conn, "list_of_students.json", data: {teacher, students})
    end
  end
end
