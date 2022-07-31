defmodule SoundAdvice.Ports.Adapters.Twitter do
  # https://dashbit.co/blog/building-a-custom-broadway-producer-for-the-twitter-stream-api
 alias Mint.HTTP2

@twitter_stream_url_v2 "https://api.twitter.com/2/tweets/sample/stream"

def start(token) do
  uri = URI.parse(@twitter_stream_url_v2)

  {:ok, conn} = HTTP2.connect(:https, uri.host, uri.port)

  {:ok, conn, request_ref} =
    HTTP2.request(
      conn,
      "GET",
      uri.path,
      [{"Authorization", "Bearer #{token}"}],
      nil
    )

  listen(conn, request_ref, token)
end

defp listen(conn, ref, token) do
  # Mint sends the last message to `self()`, so we receive here.
  last_message =
    receive do
      msg -> msg
    end

  case HTTP2.stream(conn, last_message) do
    {:ok, _conn, responses} ->
    IO.inspect(responses, label: "responses")
      # We process "responses" and loop again.
      listen(conn, ref, token)

    {:error, _conn, %Mint.HTTPError{}, _} ->
      IO.puts("starting again")

      start(token)
  end
end
end
