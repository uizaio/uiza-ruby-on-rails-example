require "uiza"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  Uiza.authorization = "uap-9ee4c164e3944ad781ddcafbfad91a0d-1ac7c3ff"

  def hello
    entities = Uiza::Entity.list
    puts entities.first.id
    puts entities.first.name
    render html: "hello, world!"
  end
end
