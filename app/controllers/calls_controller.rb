class CallsController < ApplicationController
  def create
    render xml: CallResponse.new(params["FromCountry"]).to_xml
  end
end
