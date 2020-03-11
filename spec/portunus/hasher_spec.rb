require "spec_helper"

describe ::Portunus::Hasher do
  describe ".for" do
    it "should hash the input with SHA-512" do
      test_sha = "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d49" +
                 "40e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e" +
                 "6f57f50028a8ff"

      expect(Portunus::Hasher.for("test")).to eql(test_sha)
    end

    it "should return nil if the input is blank" do
      # this is often used with methods that may pass nil. Hashing this or
      # converting to a blank string before hashing would cause some unexpected
      # behavior and I think this is the way that is going to lead to the least
      # surprise
      expect(Portunus::Hasher.for(nil)).to eql(nil)
      expect(Portunus::Hasher.for("")).to eql(nil)
    end
  end
end
