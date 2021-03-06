defmodule Typi.Phone do
  use Typi.Web, :model

  schema "phones" do
    field :country_code, :string
    field :number, :string
    field :region, :string
    belongs_to :user, Typi.User

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:country_code, :number, :region, :user_id])
    |> validate_required([:country_code, :number, :region, :user_id])
    |> validate_phone
    |> unique_constraint(:number, name: :phones_country_code_number_index)
    |> assoc_constraint(:user)
  end

  def validate_phone(changeset) do
    changeset
    |> validate_length(:region, min: 2, max: 3)
    |> validate_country_code_and_number
  end

  defp validate_country_code_and_number(changeset) do
    # TODO change to with else when elixir 1.3 is out
    # TODO improve error messaging, i.e. invalid country code, invalid number etc
    with %Ecto.Changeset{valid?: true, changes:
          %{country_code: country_code, number: number, region: region}} <- changeset,
        {:ok, phone_number} <- ExPhoneNumber.parse("#{country_code}#{number}", region) do
      ExPhoneNumber.is_valid_number?(phone_number)
    end
    |> case do
      true -> changeset
      %Ecto.Changeset{valid?: false} -> changeset
      _ -> add_error(changeset, :number, "invalid phone number")
    end
  end
end
