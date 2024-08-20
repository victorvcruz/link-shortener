defmodule LinkShortener.Link do
  use Ecto.Schema

  import Ecto.Changeset

  schema "links" do
    field :hash, :string
    field :url, :string
    field :clicks, :integer, default: 0
    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

  def changeset(link, attrs) do
    link
    |> cast(attrs, [:hash, :url, :clicks, :created_at, :updated_at])
    |> validate_required([:hash, :url])
    |> unique_constraint(:hash)
  end

  def get_by_hash(hash) do
    LinkShortener.Repo.get_by(LinkShortener.Link, hash: hash)
  end

  def insert(links) do
    %LinkShortener.Link{}
    |> changeset(links)
    |> LinkShortener.Repo.insert()
  end

  def generate_hash() do
    :crypto.strong_rand_bytes(4)
    |> Base.encode16()
    |> String.downcase()
  end

end
