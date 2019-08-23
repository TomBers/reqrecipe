defmodule Walk do

  def run() do
    start = SimpleStruct.new(:a)
    g = get_graph(start)
    run_graph(g, start)
  end

  def run_graph(g, start) do
    Graph.vertices(g)
    |> Enum.filter(fn(node) -> Graph.out_degree(g, node) == 0 end)
    |> Enum.flat_map(fn(node) -> Graph.get_paths(g, start, node) end)
    |> Enum.map(fn(path) -> execute_path(g, path) end)
  end

  def execute_path(g, []) do
    IO.inspect(Graph.transpose(g))
  end


  def execute_path(g, [h| t] = path) do
    case can_node_execute?(g, h) do
      true -> execute_path(run_node(g, h), t)
      false -> execute_path(g, un_run_parents(g, h) ++ path)
    end
  end

  def run_node(g, h) do
    inputs = Graph.in_neighbors(g, h) |> Enum.reduce(%{}, fn(node, acc) -> Map.put(acc, node.name, "#{node.name} outputs") end)
    new_node = SimpleStruct.run(h, inputs)
    Graph.replace_vertex(g, h, new_node)
  end


  def can_node_execute?(g, node) do
    Graph.in_degree(g, node) == 0 or length(un_run_parents(g, node)) == 0
  end

  def un_run_parents(g, node) do
    Graph.in_neighbors(g, node) |> Enum.filter(fn(nd) -> length(Map.keys(nd.outputs)) == 0 end)
  end

  def get_graph(a) do
    b = SimpleStruct.new(:b)

    pre_c = SimpleStruct.new(:pre_c)
    c = SimpleStruct.new(:c)
    d = SimpleStruct.new(:d)

    g = Graph.new()
    g = Graph.add_vertex(g, a)
    g = Graph.add_vertex(g, b)

    g = Graph.add_vertex(g, pre_c)
    g = Graph.add_vertex(g, c)

    g = Graph.add_vertex(g, d)

    g = Graph.add_edge(g, a, b)
    g = Graph.add_edge(g, b, d)
    g = Graph.add_edge(g, pre_c, c)
    g = Graph.add_edge(g, c, b)
  end

end
