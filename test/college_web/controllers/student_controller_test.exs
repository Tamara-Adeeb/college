defmodule College.StudentControllerTest do
  use CollegeWeb.ConnCase
  import CollegeWeb.Factory
  alias College.App
  # alias CollegeWeb.Router
  alias Faker.Date

  @date Date.date_of_birth()

  @create_attrs %{
    first_name: "Ali",
    last_name: "Adeeb",
    email: "test@gmail.com",
    date_of_birth: @date
  }
  @update_attrs %{first_name: "Reem"}
  @invalid_email_attrs %{
    first_name: "Ali",
    last_name: "Adeeb",
    email: "testgmail.com",
    date_of_birth: @date
  }
  @invalid_required_attrs %{}


#   describe "create" do
#     test "render student when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.student_path(conn, :create), @create_attrs)
#       assert  %{
#         "courses" => [],
#         "email" => "test@gmail.com",
#         "first_name" => "Ali",
#         "last_name" => "Adeeb"
#       } ==  json_response(conn, 200)["data"]

#   end
# end


end
