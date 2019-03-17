defmodule ReservaWeb.Plugs.CasAuthentication do
  import Plug.Conn
  alias Reserva.Repo
  alias Reserva.User
  alias ReservaWeb.Router.Helpers, as: Routes

  def init(options) do
    options
  end

  def call(%Plug.Conn{params: %{"ticket" => ticket}} = conn, _options) do
    response = HTTPoison.get!("https://secure.dst.usb.ve/serviceValidate?service=#{req_full_url(conn)}&ticket=#{ticket}", [], hackney: [:insecure])

    case Regex.match?(~r/authenticationSuccess/, response.body) do
      true ->
        {xml, _} =
          response.body
          |> :binary.bin_to_list
          |> :xmerl_scan.string()

        [{_,_,_,_,cas_user,_}] = :xmerl_xpath.string('//cas:user/text()', xml)

        put_session(conn, :cas_user, List.to_string(cas_user))
        |> Phoenix.Controller.redirect(to: req_short_url(conn))
        |> halt
      false ->
        Phoenix.Controller.put_flash(conn, :error, "Error en la autenticación con CAS")
        |> Phoenix.Controller.redirect(to: req_short_url(conn))
        |> halt
    end
  end

  def call(conn, _options) do
    case get_session(conn, :cas_user) do
      nil ->
       Phoenix.Controller.redirect(conn, external: "https://secure.dst.usb.ve/login?service=#{req_full_url(conn)}")
       |> halt
      usbid ->
        case Repo.get_by(User, usbid: usbid) do
          nil ->
            Phoenix.Controller.redirect(conn, to: Routes.user_path(conn, :new))
            |> halt
          current_user ->
            assign(conn, :current_user, current_user)
        end
    end
  end

  defp req_full_url(%Plug.Conn{req_headers: req_headers, request_path: request_path}) do
      "http://" <> :proplists.get_value("host", req_headers) <> request_path
  end

  defp req_short_url(%Plug.Conn{request_path: request_path}) do
    request_path
  end
end
