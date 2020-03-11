require "spec_helper"

describe ::Portunus::Encrypters::OpenSslAes do
  it "should work end to end" do
    # This seems a bit weird but should run through the bulk of the portunus
    # code with the default setup

    user = User.new
    user.email = "testemail@example.com"
    user.firstname = "Pascal"
    user.lastname = "Fluffy"

    expect(user.email).to eql("testemail@example.com")
    expect(user.firstname).to eql("Pascal")
    expect(user.lastname).to eql("Fluffy")
  end

  describe "after a validation error" do
    it "should still read the field correctly" do
      user = User.new
      user.email = "testemail@example.com"
      user.firstname = "Pascal"

      expect(user.valid?).to eql(false)
      expect(user.email).to eql("testemail@example.com")
      expect(user.firstname).to eql("Pascal")
    end
  end
end
