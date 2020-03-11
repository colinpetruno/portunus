require "spec_helper"

describe ::Portunus::Encrypters::OpenSslAes do
  it "should be good" do
    user = User.new
    user.email = "testemail@example.com"
    user.firstname = "Pascal"
    user.lastname = "Fluffy"

    binding.pry

    expect(user.email).to eql("testemail@example.com")
  end
end
