class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :first_name, :last_name, :username, :email, :image, :image_url
end
