defmodule ApigatewayWeb.UploadServiceController do
  use ApigatewayWeb, :controller

  action_fallback(ApigatewayWeb.FallbackController)

  def awsv4(conn, params) do
    key = "AWS4" <> "aDYZ3vj1f+b0kYHcxIB2f5kI9MHY9lZLn0LJKu4c"
    to_sign = params["to_sign"]
    [part1, part2, signKeyInfo, part3] = String.split(to_sign, ~s(\n))

    [date, region, service, request] =
      signKeyInfo
      |> String.split("/")

    # reconstruct string to_sign because Elixir cant figure out new lines in the string
    sts = part1 <> "\n" <> part2 <> "\n" <> signKeyInfo <> "\n" <> part3

    resp =
      key
      |> encrypt(date)
      |> encrypt(region)
      |> encrypt(service)
      |> encrypt(request)
      |> encrypt(sts)
      |> Base.encode16(case: :lower)

    text(conn, resp)
  end

  def encrypt(key, data) do
    :crypto.hmac(:sha256, key, data)
  end

  def getfile(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
  end

  def gettorrent(conn, params) do
    IO.inspect(conn)
    IO.inspect(params)
  end
end
