defmodule CollegeWeb.Router do
  use CollegeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug College.Authentication.Pipeline
  end

  scope "/api", CollegeWeb do
    pipe_through :api

    post "/users", UserController, :register
    post "/session/new", SessionController, :new
  end

  scope "/api", CollegeWeb do
    # [:api, :auth]
    pipe_through :api

    post "/session/refresh", SessionController, :refresh
    post "/session/delete", SessionController, :delete

    resources "/students", StudentController, only: [:create, :delete, :update, :index]
    post "/students/:student_id/courses/:course_id", StudentController, :register_course
    delete "/students/:student_id/courses/:course_id", StudentController, :cancel_register_course

    resources "/teachers", TeacherController, only: [:create, :delete, :update, :index]
    post "/teachers/courses", TeacherController, :create_teaacher_with_course
    get "/teachers/:id/courses", TeacherController, :all_courses_for_teacher
    get "/teachers/:id/students", TeacherController, :all_students_for_teacher

    resources "/courses", CourseController, only: [:create, :delete, :update, :index]
  end
end
