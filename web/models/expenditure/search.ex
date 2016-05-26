defmodule HomeAccounting.Expenditure.Search do
  import Ecto.Query, only: [from: 1, from: 2]

  def apply_filters(query, filters) when is_map(filters) do
    filters |> Enum.reduce(query, fn({name, term}, q)->
       q |> apply_filter(name, term)
    end)
  end

  defp apply_filter(query, "search", term) when term == "", do: query
  defp apply_filter(query, "search", term) do
    from e in query,
      where: fragment("? % ?", e.desc, ^term),
      order_by: fragment("SIMILARITY(?, ?) DESC", e.desc, ^term)
  end

  defp apply_filter(query, "amount_gteq" = filter, term) when is_binary(term) do
    apply_parsing_float query, filter, term
  end

  defp apply_filter(query, "amount_gteq", term) when is_number(term) do
    from e in query, where: e.amount_cents >= ^round(term * 100)
  end

  defp apply_filter(query, "amount_lteq" = filter, term) when is_binary(term) do
    apply_parsing_float query, filter, term
  end

  defp apply_filter(query, "amount_lteq", term) when is_number(term) do
    from e in query, where: e.amount_cents <= ^round(term * 100)
  end

  defp apply_filter(query, "expent_at_gteq", term) do
    from e in query, where: e.expent_at <= ^term
  end

  defp apply_filter(query, "expent_at_lteq", term) do
    from e in query, where: e.expent_at <= ^term
  end

  defp apply_filter(query, "tag_ids", term) when term == "", do: query
  defp apply_filter(query, "tag_ids", term) when is_binary(term) do
    from e in query,
      join: t in assoc(e, :tags),
      where: t.id in ^(term |> String.split(","))
  end

  defp apply_parsing_float(query, filter, term) do
    {float,_} = Float.parse(term)
    apply_filter(query, filter, float)
  end
end
