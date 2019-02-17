defmodule XxxxXxxxWeb.TodoView do
  use XxxxXxxxWeb, :view
  import HtmlSanitizeEx

  def data(conn) do
    [texas: %{
      todo_list: todo_list(conn),
      list_count: list_count(conn),
      filters: filters(conn)
    }]
  end

  def filters(_conn) do
    filters = [:done, :active, :all]
    state = Agent.get(TodoListState, & &1)
    parsed = Enum.reduce(filters, "", & &2 <> build_filter(&1, state))
      |> Floki.parse
      |> List.wrap

    {:list, [], parsed}
  end

  def build_filter(state, selected) do
    selected_class = if selected == state, do: "selected", else: nil

    ~s(
      <li class="filter #{selected_class}">
        <form action="/update" method="post">
          <button type="submit" name="list_state" value="#{state}">#{state}</button>
        </form>
      </li>
    )
  end

  def list_count(_conn) do
    count = Agent.get(SomePersistenceLayer, & Enum.count(&1))
    parsed = " <strong>#{count}</strong> items "
      |> Floki.parse
      |> List.wrap

    {:list, [], parsed}
  end

  def todo_list(_conn) do
    parsed = list_items()
      |> Enum.reduce("", & &2 <> build_html(&1))
      |> Floki.parse
      |> List.wrap

    {:list, [], parsed}
  end

  defp list_items do
    viewing = Agent.get(TodoListState, & &1)

    Agent.get(SomePersistenceLayer,
              fn list ->
                if    ( viewing == :all ),
                do:   list,
                else: Enum.filter(list, & &1.state == viewing)
              end)
  end

  defp build_html(item) do
    class = if item.state == :done, do: "completed"
    checked = if item.state == :done, do: "checked"

   ~s(
     <li class="#{class}" id="#{item.id}">
       <div class="view">
         <form method="post" action="/update">
           <button type="submit" class="toggle #{checked}" name="todo_mark" value="#{item.id}"></button>
           <label>#{strip_tags(item.label)}</label>
         </form>
         <form method="post" action="/update">
           <button type="submit" name="destroy_todo" value="#{item.id}" class="destroy"></button>
         </form>
       </div>
     </li>
   )
  end
end
