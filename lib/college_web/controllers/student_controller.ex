defmodule CollegeWeb.StudentController do
  use CollegeWeb, :controller
  alias College.App
  alias College.Repo

  def index(conn,params) do
    infinite_cursor = App.all_students(params)
    render(conn, "index.json", infinite_cursor: infinite_cursor)
  end

  def create(conn, params) do
    case App.create_student(params) do
      {:ok, student} ->
        render(conn, "create.json", student: student |> Repo.preload(:courses))
      {:error, reason} -> render(conn, "error.json",error: reason.errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    case App.delete_student(String.to_integer(id)) do
      {:error, "not found"} -> json(conn, %{error: "not found"})
      {:ok, student} -> render(conn, "delete.json", student: student)
    end
  end

  def update(conn, params) do
    case App.update_student(params) do
      {:ok, student} -> render(conn, "update.json", student: student )
      {:error , "not found"} -> json(conn, %{error: "not found"})
      {:error, reason} -> render(conn, "error.json",error: reason.errors)
    end
  end

  def register_course(conn, params) do
    case App.student_register_course(params) do
      {:ok, student_course} ->
        student_course = student_course |> Repo.preload([:course,:student])
        student = student_course.student |> Repo.preload(:courses)
        render(conn, "register_course.json", student: student)
      {:error, reason} -> render(conn, "error.json",error: reason.errors)
    end
  end

  def cancel_register_course(conn, params) do
    case App.cancel_register_course(params["ids"], params["idc"]) do
      {:ok, _} -> json(conn, %{status: "ok"})
      {:error, _} -> json(conn, %{error: "not found"})
    end
  end
end
