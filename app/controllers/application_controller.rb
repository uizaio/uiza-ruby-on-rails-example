require "uiza"
require "aws-sdk-s3"
require "json"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  Uiza.authorization = "key"

  def hello
    entities = Uiza::Entity.list
    puts entities.first.id
    puts entities.first.name
    render html: "hello, world!"
  end

  def uploadToAws
    appId = "9ee4c164e3944ad781ddcafbfad91a0d"
    uploadLink = "upload_temp/"
    params = request.POST
    # params = JSON.parse raw_params
    response = Uiza::Entity.get_aws_upload_key
    puts response
    s3 = Aws::S3::Resource.new(
      :access_key_id => response.temp_access_id,
      :secret_access_key => response.temp_access_secret,
      :region => response.region_name,
      :session_token => response.temp_session_token
    )
    path = response.bucket_name
    paths = path.split("/")
    obj = s3.bucket(paths[0]).object(paths[1] + "/" + appId + "/s3+uiza+" + params["entityId"] + ".mp4")
    obj.upload_file(uploadLink + params["filename"])
    msg = {:res => "ok"}
    render :json => msg
  end

  def stopLive
    response = Uiza::Live.stop_feed "955b35b1-e20f-4e46-8dd6-e1c0f5aed0b8"
    puts response.message
    render :json => response

  end
end
