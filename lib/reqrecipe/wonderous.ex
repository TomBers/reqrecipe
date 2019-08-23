defmodule Wonderous do
  require Integer


  def find_unwonderous() do
    unwonderous(1000, 0)
  end

  def unwonderous(n, len) do
    IO.inspect(n)
    case calc(n) == "Unwonderous" do
      true -> IO.inspect(len)
      false -> unwonderous(n + 1, len + 1)
    end
  end

  def calc(n) do
    calc(n, 0)
  end

  def calc(1, len) do
    len
  end

  def calc(n, len) when len > 10000 do
    "Unwonderous"
  end

  def calc(n, len) when Integer.is_even(n) do
#    IO.inspect("#{n} is Even")
    calc(div(n, 2), len + 1)
  end

  def calc(n, len) when Integer.is_odd(n) do
#    IO.inspect("#{n} is Odd")
    calc((3 * n) + 1, len + 1)
  end

end
