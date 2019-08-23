defmodule SimpleStruct do
  defstruct name: "", inputs: %{}, outputs: %{}

  def new(name) do
      %SimpleStruct{name: name}
  end

  def run(node, inputs) do
    node
    |> Map.put(:outputs, %{data: "#{node.name}"})
    |> Map.put(:inputs, inputs)
  end

end
