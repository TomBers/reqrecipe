defmodule Disjoint do

  def run() do
    g = get_graph()
  end

  def get_graph() do
    a = Req.simple_request("http://localhost:4000/api/random")


    b = Req.post_request("http://localhost:4000/api/filter")

    d = Req.post_request("http://localhost:4000/api/min")


    c = Req.simple_request("http://localhost:4000/api/number")


    g = Graph.new()
    g = Graph.add_vertex(g, a)
    g = Graph.add_vertex(g, b)
    g = Graph.add_vertex(g, c)
    g = Graph.add_vertex(g, d)

    g = Graph.add_edge(g, a, b)
    g = Graph.add_edge(g, c, b)
    g = Graph.add_edge(g, b, d)

    WalkPath.run_graph(g, a)
  end

end
