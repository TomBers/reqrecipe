defmodule WalkPath do

  def run_graph(g, start) do
    Graph.vertices(g)
    |> Enum.filter(fn(node) -> Graph.out_degree(g, node) == 0 end)
    |> Enum.flat_map(fn(node) -> Graph.get_paths(g, start, node) end)
#    |> Enum.map(fn(path) -> execute_path(g, path) end)
#    |> IO.inspect
  end

  def execute_path(g, []) do
    IO.puts("DONE")
#    IO.inspect(Graph.transpose(g))
  end


  def execute_path(g, [h| t] = path) do
    case can_node_execute?(g, h) do
      true -> execute_path(run_node(g, h), t)
      false -> execute_path(g, un_run_parents(g, h) ++ path)
    end
  end

  def run_node(g, h) do
    inputs = Graph.in_neighbors(g, h) |> Enum.reduce(%{}, fn(node, acc) -> Map.put(acc, node.output_key, node.res) end)
    new_node = Req.run_request(h |> Req.set_body(inputs))
    if new_node.output_node do
      IO.inspect(new_node.res)
    end
    Graph.replace_vertex(g, h, new_node)
  end


  def can_node_execute?(g, node) do
    Graph.in_degree(g, node) == 0 or length(un_run_parents(g, node)) == 0
  end

  def un_run_parents(g, node) do
    Graph.in_neighbors(g, node) |> Enum.filter(fn(nd) -> is_nil(nd.res) end)
  end


end
