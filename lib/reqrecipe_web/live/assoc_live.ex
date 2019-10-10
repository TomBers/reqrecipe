defmodule ReqrecipeWeb.AssocLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="grid-container">
        <div class="grid-item">
        <div>
        <svg width="400" height="400">
      <style>
    text {
      outline: 1px solid black;
    }
    </style>
          <%= for {x, y, name} <- get_nodes(@graph) do %>
            <text x="<%= x %>" y="<%= y %>">"<%= name %>"</text>
          <% end %>
          <%= for {x1, y1, x2, y2} <- get_verticies(@graph) do %>
            <line x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>" stroke="black" />
          <% end %>
        </svg>
      </div>
        </div>
    </div>
    """
  end

  def mount(_session, socket) do
    g = graph()
    {:ok, assign(socket, :graph, g)}
  end

  def get_verticies(graph) do
#    [{100,100, 300,300}]
      []
  end

  def traverse_nodes(graph, [], dat, _, _) do
    Enum.map(dat, fn({x, y, node}) -> {x, y, node } end)
  end



  def traverse_nodes(graph, nodes, dat, level, parent_offset) do
    d = Enum.map(Enum.with_index(nodes), fn({node, index}) -> {parent_offset, level, node} end)
    Enum.flat_map(Enum.with_index(nodes), fn({node, index}) -> traverse_nodes(graph, Graph.out_neighbors(graph, node), dat ++ d, level + 1, parent_offset - index ) end)
  end

  def get_nodes(graph) do
    nodes = traverse_nodes(graph, [Graph.arborescence_root(graph)], [], 0, 0)
    n = Enum.uniq(nodes)
    IO.inspect(n)
    []
  end

  def graph() do
    a = "A"
    b = "B"
    c = "C"
    d = "D"
    e = "E"
    f = "F"

    g = Graph.new()
    g = Graph.add_vertex(g, a)
    g = Graph.add_vertex(g, b)
    g = Graph.add_vertex(g, c)
    g = Graph.add_vertex(g, d)
    g = Graph.add_vertex(g, e)
#    g = Graph.add_vertex(g, f)

    g = Graph.add_edge(g, a, b)
    g = Graph.add_edge(g, a, c)
    g = Graph.add_edge(g, b, d)
    g = Graph.add_edge(g, b, e)

#    g = Graph.add_edge(g, c, f)
  end

end
