defmodule CollegeWeb.Request do
  @behaviour CollegeWeb.ClientBehaviour

  @body %{
    address: "Ramallah",
    date_of_birth: "2000-01-01",
    first_name: "Tena",
    gender: "female",
    last_name: "Adeeb"
  }

  @impl CollegeWeb.ClientBehaviour
  def get_http(url) do
    HTTPoison.get(url)
  end

  @impl CollegeWeb.ClientBehaviour
  def post_http(url, body, headers) do
    HTTPoison.post(url, body, headers)
  end
end
