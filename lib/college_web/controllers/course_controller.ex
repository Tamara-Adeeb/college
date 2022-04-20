defmodule CollegeWeb.CourseController do
  use CollegeWeb, :controller
  alias College.App
  alias College.Repo

  def index(conn, params) do
    %{entries: entries, metadata: metadata} = App.all_courses(params)
    courses = Enum.map(entries, fn course -> update_metadate(course) end)
    render(conn, "index.json", infinite_cursor: %{entries: courses, metadata: metadata})
  end

  def show(conn, %{"id" => id}) do
    case App.get_course(id) do
      nil ->
        json(conn, %{error: "not found"})

      course ->
        course = update_metadate(course)
        render(conn, "show.json", course: course)
    end
  end

  def create(conn, params) do
    params = Map.put(params, "branch", String.downcase(params["branch"]))

    case App.create_course(params) do
      {:ok, course} ->
        course = update_metadate(course)
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

  def create_teaacher_with_course(conn, params) do
    case App.create_course_teacher(params) do
      {:ok, %{course: course, teacher: teacher}} ->
        course = update_metadate(course)
        render(conn, "create.json", course_teacher: [course, teacher])

      {:error, :teacher, reason, _} ->
        render(conn, "error.json", error: reason.errors)

      {:error, :course, reason, _} ->
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
        course = update_metadate(course)
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

  defp update_metadate(course) do
    metadata = Map.from_struct(course.metadata)
    Map.replace(course, :metadata, metadata)
  end
end
