defmodule ReqrecipeWeb.RecipeLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
      <h1>Recipe.Me</h1>
      <button phx-click="req">Hit it</button>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def handle_event("req", _, socket) do
    initial = Req.simple_request("http://localhost:4000/api/random")
    max = Req.post_request("http://localhost:4000/api/max")
    min = Req.post_request("http://localhost:4000/api/min")
    digits = Req.post_request("http://localhost:4000/api/digits")


    g = Graph.new()
    g = Graph.add_vertex(g, initial)
    g = Graph.add_vertex(g, max)
#    g = Graph.add_vertex(g, min)
    g = Graph.add_vertex(g, digits)

    g = Graph.add_edge(g, initial, max)
#    g = Graph.add_edge(g, initial, min)
    g = Graph.add_edge(g, max, digits)
#    g = Graph.add_edge(g, min, digits)



    WalkPath.run_graph(g, initial)

    {:noreply, socket}
  end


end
