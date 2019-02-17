defmodule XxxxXxxxWeb.TodoController do
  use XxxxXxxxWeb, :controller
  import Texas.Controller

  def index(conn, _params) do
    texas_render conn, "index.html", XxxxXxxxWeb.TodoView.data(conn)
  end

  def update(conn, params) do
    update_some_persistence_layer(params)
    notify_our_app_said_layer_has_changes()
    # this is necessary for http requests - we want to be able to serve sockets and http reqs
    texas_redirect conn, to: "/"
  end

  def update_some_persistence_layer(%{"new_todo" => data} = params) do
    list_item = %{state: :active, label: data, id: UUID.uuid4()}
    Agent.update(SomePersistenceLayer, & Enum.take([list_item|&1], 25))
  end
  def update_some_persistence_layer(%{"toggle_all" => _}) do
    toggle_all = fn list -> toggle_all(list) end
    Agent.update(SomePersistenceLayer, & toggle_all.(&1))
  end
  def update_some_persistence_layer(%{"todo_mark" => id}) do
    toggle_one = fn list, id -> toggle_one(list, id) end
    Agent.update(SomePersistenceLayer, & toggle_one.(&1, id))
  end
  def update_some_persistence_layer(%{"list_state" => state}) do
    Agent.update(TodoListState, fn _ -> String.to_existing_atom(state) end)
  end
  def update_some_persistence_layer(%{"clear_done" => _}) do
    Agent.update(SomePersistenceLayer, fn list -> Enum.reject(list, & &1.state == :done) end)
  end
  def update_some_persistence_layer(%{"destroy_todo" => id}) do
    Agent.update(SomePersistenceLayer, fn list -> Enum.reject(list, & &1.id == id) end)
  end

  defp toggle_one(list, id) do
    toggled = &(if &1.state == :done, do: :active, else: :done)
    Enum.map(list, &(if &1.id == id, do: %{&1 | state: toggled.(&1)}, else: &1))
  end

  defp toggle_all(list) do
    case Enum.any?(list, & &1.state == :active) do
      true ->
        toggle_done = fn list -> Enum.map(list, fn item -> Map.update!(item, :state, fn x -> :done end) end) end
        toggle_done.(list)
      _ ->
        toggle_active = fn list -> Enum.map(list, fn item -> Map.update!(item, :state, fn x -> :active end) end) end
        toggle_active.(list)
    end
  end

  defp notify_our_app_said_layer_has_changes() do
    # key info here is "todo_list" is the view fun that knows how to
    # render our example_list
    XxxxXxxxWeb.Endpoint.broadcast("texas:diff:todo_list", "", %{})
    XxxxXxxxWeb.Endpoint.broadcast("texas:diff:list_count", "", %{})
    XxxxXxxxWeb.Endpoint.broadcast("texas:diff:filters", "", %{})
  end
end
