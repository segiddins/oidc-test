# frozen_string_literal: true

require "rubygems/commands/push_command"

Gem::Commands::PushCommand.prepend(Module.new do
  def send_push_request(name, args)
    return super unless ENV["gem_attestation_path"]

    rubygems_api_request(*args, scope: get_push_scope) do |request|
      request.set_form([
                         ["gem", Gem.read_binary(name), { filename: name, content_type: "application/octet-stream" }],
                         ["attestations", "[#{Gem.read_binary(ENV["gem_attestation_path"])}]",
                          { content_type: "application/json" }]
                       ], "multipart/form-data")
      request.add_field "Authorization", api_key
    end
  end
end)
