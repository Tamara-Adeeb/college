defmodule Bound do
  def get_http(url) do
    impl().get_http(url)
  end

  def get_pokemon(limit, offset) do
    impl().get_pokemon(limit, offset)
  end

  def post_http(url, body, headers) do
    impl().post_http(url, body, headers)
  end

  def create_student(body) do
    impl().create_student(body)
  end

  defp impl() do
    Application.get_env(:bound, :college, CollegeWeb.Clinet)
  end
end
