defmodule ReqrecipeWeb.ApiController do
  use ReqrecipeWeb, :controller

  def random(conn, _params) do

    json(conn, %{data: get_data()})
  end

  def max(conn, %{"data" => data}) do
    json(conn, %{data: Enum.max(data)})
  end

  def min(conn, %{"data" => data}) do
    json(conn, %{data: Enum.min(data)})
  end

  def number(conn, _params) do
    json conn, %{data: Enum.random(0..30)}
  end

  def filter(conn, %{"data" => data, "greater_than" => lim} = params) do
    json(conn, %{data: Enum.to_list(Enum.filter(data, fn(val) -> val >= lim end))})
  end


  def digits(conn, %{"data" => data}) do
    out =
      data
#      |> String.to_integer
      |> Integer.digits()
      |> Enum.map(fn(digit) -> to_text(digit) end)

      json(conn, %{data: out})
  end

  def to_text(num) do
    case num do
      0 -> "Zero"
      1 -> "One"
      2 -> "Two"
      3 -> "Three"
      4 -> "Four"
      5 -> "Five"
      6 -> "Six"
      7 -> "Seven"
      8 -> "Eight"
      9 -> "Nine"
    end
  end


  def get_data() do
    1..10 |> Enum.map(fn(x) -> Enum.random(0..100) end)
  end
end
