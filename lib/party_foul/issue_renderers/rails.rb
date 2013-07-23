class PartyFoul::IssueRenderers::Rails < PartyFoul::IssueRenderers::Rack
  # Rails params hash. Filtered parms are respected.
  #
  # @return [Hash]
  def params
    parameter_filter = ActionDispatch::Http::ParameterFilter.new(env["action_dispatch.parameter_filter"])
    parameter_filter.filter(env['action_dispatch.request.path_parameters'])
  end

  # Rails session hash. Filtered parms are respected.
  #
  # @return [Hash]
  def session
    if rack_session = env['rack.session']
      parameter_filter = ActionDispatch::Http::ParameterFilter.new(env['action_dispatch.parameter_filter'])
      parameter_filter.filter(rack_session.to_hash)
    else
      {}
    end
  end

  private

  def app_root
    Rails.root.to_s
  end

  def raw_title
    return super unless controller = env['action_controller.instance']

    %{#{controller.class}##{controller.action_name} (#{exception.class}) "#{exception.message}"}
  end
end
