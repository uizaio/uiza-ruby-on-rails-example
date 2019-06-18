require "uiza"
require "aws-sdk-s3"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  Uiza.authorization = "uap-9ee4c164e3944ad781ddcafbfad91a0d-1ac7c3ff"
  appId =""
  upload_link = "upload_temp/"

  def hello
    entities = Uiza::Entity.list
    puts entities.first.id
    puts entities.first.name
    render html: "hello, world!"
  end

  def uploadToAws
    raw_params = request.post
    params = JSON.parse(raw_params)

    response = Uiza::Entity.get_aws_upload_key
    s3 = Aws::S3::Resource.new(
      :access_key_id => response.temp_access_id,
      :secret_access_key => response.temp_access_secret,
      :region => response.region_name,
      :session_token => response.temp_session_token
    )
    obj = s3.bucket(response.bucket_name).object("upload-temp/" + appId + "/s3+uiza+" + params.entityId + ".mp4")
    obj.upload_file(uploadlink + params.filename)
  end
end
