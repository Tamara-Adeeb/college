defmodule CollegeWeb.CourseController do
  use CollegeWeb, :controller
  alias College.App
  alias College.Repo

  def index(conn, params) do
    infinite_cursor = App.all_courses(params)
    render(conn, "index.json", infinite_cursor: infinite_cursor)
  end

  def create(conn, params) do
    case App.create_course(params) do
      {:ok, course} ->
        render(conn, "create.json", course: course |> Repo.preload([:teacher, :students]))

      {:error, reason} ->
        IO.inspect(reason.errors)
        render(conn, "error.json", error: reason.errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    case App.delete_course(String.to_integer(id)) do
      {:error, "not found"} -> json(conn, %{error: "not found"})
      course -> render(conn, "delete.json", course: course)
    end
  end

  def update(conn, params) do
    case App.update_course(params) do
      {:ok, course} ->
        render(conn, "update.json", course: course |> Repo.preload([:teacher, :students]))

      {:error, "not found"} ->
        json(conn, %{error: "not found"})

      {:error, reason} ->
        IO.inspect(reason.errors)
        render(conn, "error.json", error: reason.errors)
    end
  end
end
