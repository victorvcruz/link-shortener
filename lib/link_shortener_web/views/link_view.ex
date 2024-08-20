defmodule LinkShortenerWeb.LinkJSON do
  def link(%{link: link}) do
    %{
      hash: link.hash,
      url: link.url,
      clicks: link.clicks,
      created_at: link.created_at,
      updated_at: link.updated_at
    }
  end
end
