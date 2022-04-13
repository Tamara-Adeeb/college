defmodule CollegeWeb.CourseController do
  use CollegeWeb, :controller
  alias College.App
  alias College.Repo

  def index(conn, params) do
    %{entries: entries, metadata: metadata} = App.all_courses(params)
    courses = Enum.map(entries, fn course -> App.update_semester(course) end)
    render(conn, "index.json", infinite_cursor: %{entries: courses, metadata: metadata})
  end

  def create(conn, params) do
    case App.create_course(params) do
      {:ok, course} ->
        course = App.update_semester(course)
        render(conn, "create.json", course: course |> Repo.preload([:teacher, :students]))

      {:error, reason} ->
        with true <- Map.has_key?(reason.changes, :metadata),
             true <- Map.has_key?(reason.changes.metadata, :errors) do
          render(conn, "error.json", error: reason.changes.metadata.errors)
        else
          false -> render(conn, "error.json", error: reason.errors)
        end
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
        course = App.update_semester(course)
        render(conn, "update.json", course: course |> Repo.preload([:teacher, :students]))

      {:error, "not found"} ->
        json(conn, %{error: "not found"})

      {:error, reason} ->
        with true <- Map.has_key?(reason.changes, :metadata),
             true <- Map.has_key?(reason.changes.metadata, :errors) do
          render(conn, "error.json", error: reason.changes.metadata.errors)
        else
          false -> render(conn, "error.json", error: reason.errors)
        end
    end
  end
end
