require "spec_helper"

describe ::Portunus::TypeCasters::Integer do
  describe ".cast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Integer
      expect(type_caster.cast(value: 1)).to eql("1")
      expect(type_caster.cast(value: 1800030302)).to eql("1800030302")
    end
  end

  describe ".uncast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Integer
      expect(type_caster.uncast(value: "1800030302")).to eql(1800030302)
      expect(type_caster.uncast(value: "1")).to eql(1)
    end
  end
end
