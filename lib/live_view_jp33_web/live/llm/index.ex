defmodule LiveViewJp33Web.Llm.Index do
  use LiveViewJp33Web, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Process.send_after(self(), :gpu_check, 10)

    socket =
      socket
      |> assign(text: "Elixirについて教えて")
      |> assign(llm_text: ">")
      |> assign(is_run: false)
      |> assign(gpu_info: "")

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
  def handle_info(:llm_end, socket) do
    socket =
      socket
      |> assign(is_run: false)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:gpu_check, socket) do
    Process.send_after(self(), :gpu_check, 500)

    socket =
      socket
      |> assign(gpu_info: gpu())

    {:noreply, socket}
  end

  @impl true
  def handle_event("llm", _value, socket) do
    Dify.spawn_link_llm(socket.assigns.text, self())

    socket =
      socket
      |> assign(text: "")
      |> assign(llm_text: socket.assigns.text <> "\n\n")
      |> assign(is_run: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("change_text", %{"text" => text}, socket) do
    socket =
      socket
      |> assign(text: text)

    {:noreply, socket}
  end

  def gpu() do
    System.cmd("nvidia-smi", [])
    |> then(&elem(&1, 0))
    |> String.split("\n", trim: true)
    |> Enum.at(9)
    |> String.slice(20, 60)
    |> String.split("|", trim: true)
    |> Enum.map(fn x -> String.trim(x) end)
    |> then(fn [w, m, gpu] -> "消費電力 #{w} | GPUメモリ #{m} | GPU使用率 #{gpu}" end)
  end
end
