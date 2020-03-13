require "spec_helper"

describe ::Portunus::TypeCasters::Date do
  describe ".cast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Date
      date = Date.parse("2020-03-01")
      expect(type_caster.cast(value: date)).to eql("2020-03-01")
    end
  end

  describe ".uncast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Date
      date = Date.parse("2020-03-01")
      expect(type_caster.uncast(value: "2020-03-01")).to eql(date)
    end
  end
end
