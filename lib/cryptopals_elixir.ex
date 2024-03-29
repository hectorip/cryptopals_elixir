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
  use Bitwise
  def hex_to_base64(input) do
    bytes = Base.decode16!(input, case: :lower)
    Base.encode64(bytes)
  end

  @doc """
  XOR de tamaño fijo

  ## Examples

      iex> CryptopalsElixir.fixed_xor("1c0111001f010100061a024b53535009181c", "686974207468652062756c6c277320657965")
      "746865206b696420646f6e277420706c6179"
  """
  def fixed_xor(input1, input2) do
    bytes1 = Base.decode16!(input2, case: :lower)
    bytes2 = Base.decode16!(input1, case: :lower)
    _xor(bytes1, bytes2) |> Base.encode16(case: :lower)
  end

  defp _xor(<<a::size(8), rest1::binary()>>, <<b::size(8), rest2::binary()>>) do
    <<bxor(a, b)>> <> _xor(rest1, rest2)
  end
  defp _xor(<<>>, <<>>), do: <<>>

  def single_xor(<<a, rest1::binary()>>, <<b>>) do
    <<bxor(a,b)>> <> single_xor(rest1, <<b>>)
  end
  def single_xor(<<>>, _), do: <<>>
  @spec decrypt(binary, any) :: binary
  def decrypt(input, key) do
    bytes = Base.decode16!(input, case: :lower)
    single_xor(bytes, key)
  end
  def test(input) do
    0..127
    |> Enum.map(fn k ->
      kb = k |> Integer.to_string(16)
      |> String.pad_leading(2, "0")
      |> Base.decode16!()
      result = decrypt(input, kb)
      s = score(result)
      ratio = s.letters / s.symbols
      {k, result, ratio}
    end)
    |> Enum.sort(fn {_, _, a_ratio}, {_,_,b_ratio}->
      a_ratio > b_ratio
    end)
    |> Enum.take(3)
    |> IO.inspect
  end

  def score(input) do
    input
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.reduce(%{symbols: 0, letters: 0}, fn c, acc ->
      t = if c >= ?a and c <= ?z, do: :letters, else: :symbols
      Map.update(acc, t, 0, fn x -> x + 1 end)
    end)
  end
end
