defmodule Play do

  def run() do
#    initial = Req.simple_request("http://localhost:4000/api/random")
    initial = :a
    WalkPath.run_graph(simple_graph(), :a)
  end

  def graph(initial) do
    g = Graph.new()
    g = Graph.add_vertex(g, initial)

    b = Req.post_request("http://localhost:4000/api/max", "BOB", true)
    g = Graph.add_vertex(g, b)

    g = Graph.add_edge(g, initial, b)
  end

  def simple_graph() do
      g = Graph.new()
      g = Graph.add_vertex(g, :a)
      g = Graph.add_vertex(g, :b)
      g = Graph.add_vertex(g, :c)
      g = Graph.add_vertex(g, :e)
      g = Graph.add_edge(g, :a, :b)
      g = Graph.add_edge(g, :b, :c)
      g = Graph.add_edge(g, :b, :e)

       Utils.draw_graph(g)

       g
  end

end
