defmodule LiveViewJp33Web.Llm.Index do
  use LiveViewJp33Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(text: "Elixirについて教えて")
      |> assign(llm_text: "😺")
    {:ok, socket}
  end

  @impl true
  def handle_event("llm", _value, socket) do

    {:noreply, socket}
  end
end
