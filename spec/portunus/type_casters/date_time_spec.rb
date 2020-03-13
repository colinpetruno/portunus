require "spec_helper"

describe ::Portunus::TypeCasters::DateTime do
  describe ".cast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::DateTime
      date = DateTime.parse("2020-03-01") + 2.hours + 2.minutes
      expect(type_caster.cast(value: date)).to eql("2020-03-01T02:02:00+00:00")
    end
  end

  describe ".uncast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::DateTime
      date = DateTime.parse("2020-03-01") + 2.hours + 2.minutes
      expect(type_caster.uncast(value: "2020-03-01T02:02:00+00:00")).
        to eql(date)
    end
  end
end
