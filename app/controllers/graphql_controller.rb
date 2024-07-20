# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = variables["searchPerson_v2_searchTerm"] ? params[:query]&.sub(/^\nquery/, '') : params[:query]
    operation_name = params[:operationName]
    # binding.pry
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    # HACK version
    if variables["searchPerson_v2_searchTerm"]
      # binding.pry``
      query = "{ \n  searchpersonV2(searchTerm: \"#{variables["searchPerson_v2_searchTerm"]}\") {\n    id\n    firstName\n    lastName\n    contacts {\n      id\n      isPrimary\n      contactType\n      contactValue\n    }\n    company {\n      id\n      name\n      type\n    }\n  }\n}"
    end

    result = ThriveApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)

    # HACK to convert camelcase to snakecase for demo
    result['data']&.deep_transform_keys! { |key| key.to_s.underscore } if variables["searchPerson_v2_searchTerm"]

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
