defmodule Utils do

  def draw_graph(g) do
    {:ok, data} = Graph.to_dot(g)
    IO.inspect(data)
    {:ok, file} = File.open("tmp.dot", [:write])
    IO.binwrite(file, data)
    File.close(file)
    :timer.sleep(100)

#    System.cmd("sh", ["-c", "pwd"])
    System.cmd("sh", ["-c", "cd  /Users/tomberman/Development/reqrecipe/; dot -Tpng tmp.dot > output.png"])
    System.cmd("open", ["output.png"])
  end

end
