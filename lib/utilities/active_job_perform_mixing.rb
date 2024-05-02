# This is a common class to send slack notification
module ActiveJobPerformMixing
  def perform_method_name
    is_async = %w[production staging].include?(Rails.env)
    is_async ? 'perform_later' : 'perform_now'
  end

  def active_job_perform(module_name, job_name, *params)
    Object
      .const_get(module_name)
      .const_get(job_name)
      .send(perform_method_name, *params)
  end

  def active_job_perform_with_service_name(module_name, job_name, service_name, *params)
    Object
      .const_get(module_name)
      .const_get(job_name)
      .send(perform_method_name, service_name, *params)
  end

  # Use this method if your don't want the jobs to retry when ever it fails or interrupted.
  def active_job_perform_with_service_name_no_retry(module_name, job_name, service_name, *params)
    Object
      .const_get(module_name)
      .const_get(job_name)
      .set(retry: false)
      .send(perform_method_name, service_name, *params)
  end

  def active_job_perform_with_delay(delay, module_name, job_name, *params)
    Object
      .const_get(module_name)
      .const_get(job_name)
      .set(wait: delay)
      .send(perform_method_name, *params)
  end

  def setup_job_query_conditions(raw_params)
    # INFO: the parameters are being changed after some manipulations in the init
    raw_params['query_condition']['conditions'] =
       JSON.parse(raw_params['query_condition']['conditions']) rescue {}
    raw_params
  end
end
