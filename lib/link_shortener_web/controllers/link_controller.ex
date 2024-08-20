defmodule LinkShortenerWeb.LinkController do
  use LinkShortenerWeb, :controller

  def create(conn, _params) do
    hash = LinkShortener.Link.generate_hash()

    updated_params =
      conn.body_params
      |> Map.put("hash", hash)
      |> Map.put("clicks", 0)
      |> Map.put("created_at", DateTime.utc_now())
      |> Map.put("updated_at", DateTime.utc_now())

    conn = Map.put(conn, :body_params, updated_params)

    case LinkShortener.Link.insert(updated_params) do
      {:ok, link} ->
        conn
        |> put_status(:created)
        |> render("link.json", link: link)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(LinkShortenerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"hash" => hash}) do
    case LinkShortener.Link.get_by_hash(hash) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(LinkShortenerWeb.ErrorView)
        |> render("error.json", %{error: "Link not found"})

      link ->
         redirect(conn, external: link.url)
    end
  end
end
