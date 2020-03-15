require "spec_helper"

describe ::Portunus::TypeCasters::Boolean do
  describe ".cast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Boolean
      expect(type_caster.cast(value: false)).to eql("false")
      expect(type_caster.cast(value: 0)).to eql("false")
      expect(type_caster.cast(value: nil)).to eql("false")
      expect(type_caster.cast(value: "false")).to eql("false")

      expect(type_caster.cast(value: "string")).to eql("true")
      expect(type_caster.cast(value: 1)).to eql("true")
      expect(type_caster.cast(value: 2)).to eql("true")
      expect(type_caster.cast(value: true)).to eql("true")
      expect(type_caster.cast(value: DateTime.now)).to eql("true")
    end
  end

  describe ".uncast" do
    it "should convert the right values to a string of 'false'" do
      type_caster = ::Portunus::TypeCasters::Boolean
      expect(type_caster.uncast(value: "true")).to eql(true)
      expect(type_caster.uncast(value: "false")).to eql(false)
    end

    it "should raise an error if it does not understand the decrypted value" do
      type_caster = ::Portunus::TypeCasters::Boolean

      expect{ type_caster.uncast(value: "not-valid") }.
        to raise_error(Portunus::Error)
    end
  end
end
