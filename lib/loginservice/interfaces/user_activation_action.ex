defmodule Loginservice.Interfaces.UserActivationAction do
  def user_activation_action(submission) do
    provider = Application.get_env(:loginservice, Loginservice.Interfaces.UserActivationAction)[:action_provider]
    apply(Loginservice.Interfaces.UserActivationAction, provider, [submission])
  end

  def do_nothing(_submission) do
    #IO.inspect("do nothing provider called")
  end
end