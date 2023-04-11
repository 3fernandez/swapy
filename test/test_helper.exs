ExUnit.start()

Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)

Application.put_env(:swapy, :http_client, HTTPoison.BaseMock)
