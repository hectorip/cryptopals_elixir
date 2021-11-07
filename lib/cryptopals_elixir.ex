defmodule CryptopalsElixir do
  @moduledoc """
  Documentation for `CryptopalsElixir`.
  """

  @doc """
  Convirtiendo de Hexadecimal a Base64

  ## Examples

      iex> CryptopalsElixir.hex_to_base64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d")
      "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

  """
  def hex_to_base64(input) do
    bytes = Base.decode16!(input, case: :lower)
    Base.encode64(bytes)
  end
end
