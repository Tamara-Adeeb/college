defmodule College.Pagination do
  import Ecto.Query
  alias College.Repo

  def query(query, page, pre_page) when is_binary(page) do
    query(query, String.to_integer(page), pre_page)
  end

  def query(query, page, per_page) do
    query
    |> limit(^(per_page + 1))
    |> offset(^(per_page * (page - 1)))
    |> Repo.all()
  end

  def page(query, page, per_page) when is_binary(page) do
    page(query, String.to_integer(page), per_page)
  end

  def page(query, page, per_page) do
    result = query(query, page, per_page)
    has_next = length(result) > per_page
    has_prev = page > 1
    prev_page = if has_prev, do: page - 1
    next_page = if has_next, do: page + 1

    %{
      has_next: has_next,
      has_prev: has_prev,
      prev_page: prev_page,
      page: page,
      next_page: next_page,
      list: Enum.slice(result, 0, per_page)
    }
  end
end
