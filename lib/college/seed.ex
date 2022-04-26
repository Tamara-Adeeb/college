defmodule College.Seed do
  @engineering_branches [
    "civil",
    "chemical",
    "mechanical",
    "electrical",
    "industrial",
    "computer"
  ]

  @art_branches ["creative", "arts", "writing", "philosophy", "humanities"]

  @science_branches ["physics", "biology", "chemistry", "math", "anatomy", "statistics"]

  def branch(faculty) do
    case faculty do
      "engineering" -> Enum.random(@engineering_branches)
      "science" -> Enum.random(@science_branches)
      "art" -> Enum.random(@art_branches)
      _ -> nil
    end
  end

  def metadata(semester) do
    cond do
      semester == "first" or semester == "second" ->
        %{
          "period" => Enum.random(1..10),
          "is_optional" => Enum.random(["true", "false"])
        }

      true ->
        %{
          "period" => Enum.random(1..10),
          "is_honor" => Enum.random(["true", "false"]),
          "is_research" => Enum.random(["true", "false"])
        }
    end
  end
end
