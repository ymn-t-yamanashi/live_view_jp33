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
  def handle_info({:text, text}, socket) do
    llm_text = "#{socket.assigns.llm_text}#{text}"

    socket =
      socket
      |> assign(llm_text: llm_text)

    {:noreply, socket}
  end

  @impl true
  def handle_event("llm", _value, socket) do
    Dify.spawn_link_llm(socket.assigns.text, self())

    socket =
      socket
      |> assign(text: "")
      |> assign(llm_text: socket.assigns.text <> "\n\n")

    {:noreply, socket}
  end

  @impl true
  def handle_event("change_text", %{"text" => text}, socket) do
    socket =
      socket
      |> assign(text: text)

    {:noreply, socket}
  end
end
