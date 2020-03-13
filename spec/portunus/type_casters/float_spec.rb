require "spec_helper"

describe ::Portunus::TypeCasters::Float do
  describe ".cast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Float
      expect(type_caster.cast(value: 3.40)).to eql("3.4")
      expect(type_caster.cast(value: 20939.390949)).to eql("20939.390949")
    end
  end

  describe ".uncast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Float
      expect(type_caster.uncast(value: "20939.390949")).to eql(20939.390949)
      expect(type_caster.uncast(value: "1")).to eql(1.0)
    end
  end
end
