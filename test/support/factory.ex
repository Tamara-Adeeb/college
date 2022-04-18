defmodule CollegeWeb.Factory do
  use ExMachina.Ecto, repo: College.Repo
  alias College.Schemas.Student
  alias College.Repo
  alias Faker.Date
  alias CollegeWeb.Clinet



  # without Ecto
  # def build(:student) do
  #   %Student{
  #     first_name: "Ali",
  #     last_name: "Adeeb",
  #     email: "test@gmail.com",
  #     date_of_birth: ~D[1955-04-02]
  #   }
  # end

  def student_factory do
    %Student{
      first_name: "Ali",
      last_name: "Adeeb",
      email: "test@gmail.com",
      date_of_birth: Date.date_of_birth()
    }
  end

  def get_response do
    CollegeWeb.Clinet.get_pokemon(10, 0)
  end

  # def build(factory_name, attributes) do
  #   factory_name |> build() |> struct!(attributes)
  # end

  # def insert!(factory_name, attributes \\ []) do
  #   factory_name |> build(attributes) |> Repo.insert!()
  # end
end
