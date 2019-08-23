defmodule ReqGraph do

  def run() do
    Graph.to_dot(get_graph())
  end

  def get_sibling(node) do
    g = get_graph()
    IO.inspect(Graph.neighbors(g, node))
  end

  def get_graph() do
    g = Graph.new()
    g = Graph.add_vertex(g, :a)
    g = Graph.add_vertex(g, :b)
    g = Graph.add_vertex(g, :c)
    g = Graph.add_vertex(g, :d)
    g = Graph.add_edge(g, :a, :b)
    g = Graph.add_edge(g, :b, :c)
    g = Graph.add_edge(g, :b, :d)
  end

  def print_graph(g) do
    IO.inspect(Graph.info(g))
  end

  def traverse_graph() do
    g = get_graph()
    execute_node(g, :a, [])
  end

  def execute_node(g, [], seen) do
    IO.inspect("done")
  end

  def execute_node(g, nodes, seen) when is_list(nodes) do
    new_nodes =
      nodes |> Enum.filter(fn(node) -> node not in seen end)

    node = List.first(new_nodes)
    case is_nil(node) do
      true -> execute_node(g, [], seen)
      false -> IO.inspect(node); execute_node(g, Graph.neighbors(g, node), seen ++ [node])
    end
  end

  def execute_node(g, node, seen) do
    IO.inspect(node)
    execute_node(g, Graph.neighbors(g, node), seen ++ [node])
  end


end
