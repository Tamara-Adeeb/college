defmodule CollegeWeb.PersonView do
  use CollegeWeb, :view
  alias CollegeWeb.StudentView
  alias CollegeWeb.TeacherView
  alias CollegeWeb.JsonViewHelper

  @fields [
    :id,
    :first_name,
    :last_name,
    :email,
    :date_of_birth,
    :gender,
    :address,
    :number_of_courses
  ]

  def render("show.json",%{data: data}) do
    JsonViewHelper.render_json(data, StudentView, @fields)
  end
end
