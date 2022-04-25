defmodule CollegeWeb.StudentController do
  use CollegeWeb, :controller
  alias College.{Student, Course}
  alias College.Repo

  def index(conn, params) do
    infinite_cursor = Student.all_students(params)
    render(conn, "index.json", infinite_cursor: infinite_cursor)
  end

  def show(conn, %{"id" => id}) do
    case Student.get_student(id) do
      nil -> json(conn, %{error: "not found"})
      student -> render(conn, "show.json", student: student)
    end
  end

  def create(conn, params) do
    case Student.create_student(params) do
      {:ok, student} ->
        render(conn, "create.json", student: student |> Repo.preload(:courses))

      {:error, reason} ->
        render(conn, "error.json", error: reason.errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Student.delete_student(String.to_integer(id)) do
      {:error, "not found"} -> json(conn, %{error: "not found"})
      {:ok, student} -> render(conn, "delete.json", student: student)
    end
  end

  def update(conn, params) do
    case Student.update_student(params) do
      {:ok, student} -> render(conn, "update.json", student: student)
      {:error, "not found"} -> json(conn, %{error: "not found"})
      {:error, reason} -> render(conn, "error.json", error: reason.errors)
    end
  end

  def register_course(conn, params) do
    case Student.student_register_course(params) do
      {:ok, student_course} ->
        student_course = student_course |> Repo.preload([:course, :student])
        student = student_course.student
        course = Course.update_metadate(student_course.course)
        render(conn, "register_course.json", student_course: {student, course})

      {:error, reason} ->
        render(conn, "error.json", error: reason.errors)
    end
  end

  def cancel_register_course(conn, params) do
    case Student.cancel_register_course(params["student_id"], params["course_id"]) do
      {:ok, _} -> json(conn, %{status: "ok"})
      {:error, _} -> json(conn, %{error: "not found"})
    end
  end
end
