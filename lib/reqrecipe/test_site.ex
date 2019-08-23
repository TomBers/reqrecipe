defmodule TestSite do

  def run(0) do
    nil
  end

  def run(n) do
    1..15
    |> Enum.map(fn(_a) -> spawn  fn -> get_site() end end )
    run(n - 1)
  end

  def get_site() do
    HTTPoison.get("https://frozen-spire-20719.herokuapp.com/products/")
  end


end
