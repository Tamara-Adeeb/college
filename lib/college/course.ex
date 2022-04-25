defmodule College.Course do
  alias College.Repo
  import Ecto.Query
  alias College.Schemas.{Course, Teacher}

  def all_courses(params) do
    query =
      from(c in Course,
        order_by: [asc: c.inserted_at, asc: c.id]
      )

    Repo.paginate(query,
      before: params["before"],
      after: params["after"],
      cursor_fields: [:inserted_at, :id],
      include_total_count: true,
      limit: 3
    )
  end

  def get_course(id) do
    Repo.get(Course, id)
  end

  def create_course(params) do
    %Course{}
    |> Course.changeset(params)
    |> Repo.insert()
  end

  def create_course_teacher(params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:teacher, %Teacher{} |> Teacher.changeset(params))
    |> Ecto.Multi.insert(:course, fn %{teacher: teacher} ->
      params = Map.put(params, "teacher_id", teacher.id)
      %Course{} |> Course.changeset(params)
    end)
    |> Repo.transaction()
  end

  def delete_course(id) do
    case Repo.get(Course, id) do
      nil -> {:error, "not found"}
      course -> Repo.delete(course)
    end
  end

  def update_course(params) do
    case Repo.get(Course, params["id"]) do
      nil ->
        {:error, "not found"}

      course ->
        course
        |> Course.changeset(params)
        |> Repo.update()
    end
  end

  def update_metadate(course) do
    metadata = Map.from_struct(course.metadata)
    Map.replace(course, :metadata, metadata)
  end
end
