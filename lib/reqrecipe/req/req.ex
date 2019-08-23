defmodule Req do
  import Ecto

  defstruct uuid: Ecto.UUID.generate, url: "", verb: :GET, headers: %{}, body: %{}, res: nil, error: nil, output_key: "", output_node: false

  verbs = [:GET, :POST, :DELETE, :PUT, :PATCH]

  def new() do
    %Req{}
  end

  def simple_request(url, output_key \\ "data", output_node \\ false) do
    %Req{url: url, output_key: output_key, output_node: output_node}
  end

  def post_request(url, output_key \\ "data", output_node \\ false) do
    %Req{url: url, output_key: output_key, verb: :POST, output_node: output_node}
  end

  def set_body(req, body) do
    Map.put(req, :body, body)
  end

  def run_request(req) do
    case run(req) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Map.put(req, :res, get_data_from_response(body))
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Map.put(req, :error, "404")
      {:error, %HTTPoison.Error{reason: reason}} ->
        Map.put(req, :error, reason)
    end
  end

  def get_data_from_response(body) do
    Jason.decode!(body) |> get_dat
  end

  def get_dat(%{"data" => dat}) do
    dat
  end

  def run(req) do
    case req.verb do
      :GET -> HTTPoison.get(req.url)
      :POST -> HTTPoison.post(req.url, Jason.encode!(req.body), %{"Content-Type" => "application/json"})
    end

  end

  def pr() do
    req_body = Jason.encode!(%{"name" => "who am i", "pass" => "$3cret"})
    HTTPoison.post(
      "http://localhost:4000/api/max",
      req_body,
      %{"Content-Type" => "application/json"}
    )
  end

end
