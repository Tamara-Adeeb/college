defmodule College.StudentTest do
  use ExUnit.Case
  import Mox

  setup :verify_on_exit!

  @valied_attr %{
    "address" => "Ramallah",
    "date_of_birth" => "2000-01-01",
    "email" => "testing@test",
    "first_name" => "Tena",
    "gender" => "female",
    "last_name" => "Adeeb"
  }
  @header [{"Content-type", "application/json"}]
  @invalid_attr %{
    "address" => "Ramallah",
    "date_of_birth" => "2000-01-01",
    "first_name" => "Tena",
    "gender" => "female",
    "last_name" => "Adeeb"
  }

  describe "post_http/1" do
    test ":ok on 200" do
      expect(ClientBehaviourMock, :post_http, fn _url, _body, _headers ->
        {:ok, %HTTPoison.Response{body: "created student", status_code: 200}}
      end)

      assert {:ok, %HTTPoison.Response{status_code: 200}} =
               Bound.post_http("http://localhost:4000/api/students/", @valid_attr, @header)
    end

    test ":error invalid attr" do
      expect(ClientBehaviourMock, :post_http, fn url, body, headers ->
        assert url == "http://localhost:4000/api/students/"
        assert body == @invalid_attr

        assert headers == @header

        {:ok,
         %HTTPoison.Response{
           body: "{\"error\":[\"field email: can't be blank [validation: :required]\"]}",
           status_code: 200
         }}
      end)

      assert {:ok,
              %HTTPoison.Response{
                body: "{\"error\":[\"field email: can't be blank [validation: :required]\"]}"
              }} = Bound.post_http("http://localhost:4000/api/students/", @invalid_attr, @header)
    end
  end

  describe "create_student/1" do
    test ":ok with map of the created student" do
      expect(ClientBehaviourMock, :create_student, fn body ->
        assert body = @valied_attr

        {:ok,
         %{
           "data" => %{
             "address" => "Ramallah",
             "courses" => [],
             "date_of_birth" => "2000-01-01",
             "email" => "testing@test",
             "first_name" => "Tena",
             "gender" => "female",
             "id" => 1,
             "last_name" => "Adeeb"
           }
         }}
      end)

      assert {:ok,
              %{
                "data" => %{
                  "address" => "Ramallah",
                  "courses" => [],
                  "date_of_birth" => "2000-01-01",
                  "email" => "testing@test",
                  "first_name" => "Tena",
                  "gender" => "female",
                  "id" => 1,
                  "last_name" => "Adeeb"
                }
              }} = Bound.create_student(@valid_attr)
    end
  end
end
