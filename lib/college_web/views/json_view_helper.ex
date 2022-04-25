defmodule CollegeWeb.JsonViewHelper do
  # only: [render_one: 3, render_many: 3]
  import Phoenix.View
  # use CollegeWeb, :view

  def render_json(struct, view, fields, relationships \\ []) do
    struct
    |> Map.take(fields)
    |> Map.merge(render_relationship(struct, relationships))
  end

  defp render_relationship(struct, relationships) do
    Enum.map(relationships, fn {field, view, template} ->
      {field, render_relationship(Map.get(struct, field), view, template)}
    end)
    |> Enum.into(%{})
  end

  defp render_relationship(%Ecto.Association.NotLoaded{}, _, _), do: nil

  defp render_relationship(relations, view, template) when is_list(relations) do
    render_many(relations, view, template)
  end

  defp render_relationship(relation, view, template) do
    render_one(relation, view, template)
  end

  def render("error.json", %{error: error}) do
    render_many(error, __MODULE__, "show_error.json")
  end

  def render("show_error.json", %{error: error}) do
    {
      field,
      {text, validation}
    } = error

    %{
      "#{field}": "#{text} #{inspect(validation)}"
    }
  end
end
