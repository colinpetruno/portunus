require "spec_helper"

describe ::Portunus::TypeCasters::String do
  describe ".cast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::String

      date = Date.parse("2020-03-01")
      datetime = DateTime.parse("2020-03-01") + 4.hours + 3.minutes

      expect(type_caster.cast(value: 3.4)).to eql("3.4")
      expect(type_caster.cast(value: date)).to eql("2020-03-01")
      expect(type_caster.cast(value: datetime)).to eql("2020-03-01T04:03:00+00:00")
    end
  end

  describe ".uncast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::String
      expect(type_caster.uncast(value: "asdf")).to eql("asdf")
    end
  end
end
