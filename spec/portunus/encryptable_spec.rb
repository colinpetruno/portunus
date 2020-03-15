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

  it "should work if no value is defined in the field" do
    user = User.new

    expect(user.firstname).to eql(nil)
  end

  describe "after a validation error" do
    it "should still read the field correctly" do
      user = User.new
      user.firstname = "pascal"
      user.email = "testemail@example.com"

      expect(user.valid?).to eql(false)
      expect(user.email).to eql("testemail@example.com")
      expect(user.firstname).to eql("pascal")
    end
  end

  describe ".%{field}_before_type_cast" do
    it "should return something legible to the user..." do
      user = User.new
      user.firstname = 1

      # this is behavior that may screw up post submit form errors. This method
      # is intended to get the original input before AR casts it to the input
      # type. IE entering "asdf1234" for a number field, and having a number
      # only validation will cause a fail. However if it was typecasted the
      # input on the form after validation would be "1234" instead of "asdf1234".
      # Thus this method is called to respond with the original "asdf1234" to
      # insert into the form. The behavior is hard to pin point and test however
      # as it seems to be one of those "sometimes" things.
      expect(user.firstname_before_type_cast).to eql("1")
    end
  end
end
