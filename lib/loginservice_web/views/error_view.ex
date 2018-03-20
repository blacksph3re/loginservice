defmodule LoginserviceWeb.ErrorView do
  use LoginserviceWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("error.json", %{msg: msg}) do
    %{success: false,
      msg: msg}
  end

  def render("403.json", _assigns) do
    %{success: false}
  end

  def render("404.html", _assigns) do
    "Page Not Found"
  end

  def render("500.html", _assigns) do
    "Internal Server Error"
  end
end
