require_relative '../util/pe_http'

# module Classifier. This contains the API specific code to retreive information
# from the classifier api.
class Classifier
  attr_accessor :pe_client

  def initialize(pe_console, username, password, ssl_verify: true, token_lifetime: nil)
    @pe_client = PeHttp.new(pe_console, port: 4433, username: username, password: password, ssl_verify: ssl_verify, token_lifetime: token_lifetime)
  end

  # Since we don't know exactly what we'll call these parameters yet this method
  # just fetches all parameters for a node. Eventually we plan to store job_ids,
  # pagination information, and possibly auth information for third party
  # services such as Splunk.
  def get_node_parameters(node, offset: nil, limit: nil)
    params = {
      limit:  limit,
      offset: offset,
    }
    uri = PeHttp.make_params("classifier-api/v1/classified/nodes/#{node}", params)
    response = pe_client.pe_get_request(uri)
    raise "Failed to retreive node parameters: #{response.code}, #{response.message}" if response.code.to_i > 200
    JSON.parse(response.body)['parameters']
  end
end
