defmodule TestReq do

  def run do
    initial = Req.simple_request("http://localhost:4000/api/random")
    g = graph(initial)

#    Utils.draw_graph(g)
    new_g = WalkPath.run_graph(g, initial)
  end

  def graph(a) do

    c = Req.simple_request("http://localhost:4000/api/number", "greater_than")
    b = Req.post_request("http://localhost:4000/api/filter")


    d = Req.post_request("http://localhost:4000/api/max", "data", true)

    g = Graph.new()
    g = Graph.add_vertex(g, a)
    g = Graph.add_vertex(g, b)
    g = Graph.add_vertex(g, c)
    g = Graph.add_vertex(g, d)

    g = Graph.add_edge(g, a, b)
    g = Graph.add_edge(g, b, d)
    g = Graph.add_edge(g, c, b)
  end
end
