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

  @hours_10 60 * 60 * 10

  def getfile(conn, %{"file_name" => file_name}) do
    location = Base.decode64!(file_name)
    [bucket | _rest] = String.split(location, "/")
    key = String.trim(location, bucket <> "/")
    IO.inspect(bucket)
    IO.inspect(key)

    config =
      ExAws.Config.new(:s3)
      |> Map.put(:host, "s3-accelerate.amazonaws.com")

    ExAws.S3.head_object(bucket, key)
    |> ExAws.request()
    |> case do
      {:ok, _} ->
        ExAws.S3.presigned_url(config, :get, bucket, key,
          expires_in: @hours_10,
          virtual_host: true
        )
        |> case do
          {:ok, url} ->
            redirect(conn, external: url)

          _ ->
            text(conn, "File not found. Might have expired")
        end

      _ ->
        text(conn, "File not found. Might have expired")
    end
  end
end
