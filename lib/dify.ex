defmodule Dify do
  @moduledoc """
  Documentation for `Dify`.
  """

  @api "app-NlGpxKmJ8NFhWRWSDbWk8IRW"
  @host "10.1.1.3:8001"

  def spawn_link_llm(str, pid) do
    spawn_link(fn -> llm(str, pid) end)
  end

  # Dify.llm("車は速い")
  # Dify.llm("車は速い", self())
  def llm(str, pid) do
    headers = [
      "Content-Type": "application/json",
      Authorization: "Bearer #{@api}"
    ]

    json = """
    {
      "inputs": {"in": "#{str}"},
      "response_mode": "streaming",
      "user": "abc-123"
    }
    """

    "http://#{@host}/v1/workflows/run"
    |> Req.post!(headers: headers, body: json, connect_options: [timeout: 1_000_000], into: :self)
    |> then(fn x -> x.body end)
    |> Stream.map(fn x -> text(x, pid) end)
    |> Stream.run()
  end

  defp text(x, pid) do
    text =
      Regex.replace(~r/^data: /, x, "")
      |> Jason.decode!()
      |> Map.get("data")
      |> Map.get("text")

    # def handle_info({:text, text}, socket) do
    Process.send(pid, {:text, text}, [:noconnect])
  end
end
