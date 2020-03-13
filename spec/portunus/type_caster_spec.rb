require "spec_helper"

describe ::Portunus::TypeCaster do
  describe ".cast" do
    it "should call new and the cast method" do
      type_caster = ::Portunus::TypeCaster.new(value: "Pascal Fluffy")
      expect(::Portunus::TypeCaster).to receive(:new).and_return(type_caster)
      expect(type_caster).to receive(:cast)

      ::Portunus::TypeCaster.cast(value: "Pascal Fluffy")
    end
  end

  describe ".uncast" do
    it "should call new and the uncast method" do
      type_caster = ::Portunus::TypeCaster.new(value: "Pascal Fluffy")
      expect(::Portunus::TypeCaster).to receive(:new).and_return(type_caster)
      expect(type_caster).to receive(:uncast)

      ::Portunus::TypeCaster.uncast(value: "Pascal Fluffy")
    end
  end

  describe "#cast" do
    context "with the type of string" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::String).
          to receive(:cast).
          with(value: "Pascal")

        ::Portunus::TypeCaster.cast(value: "Pascal", type: :string)
      end
    end

    context "with the type of integer" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::Integer).
          to receive(:cast).
          with(value: 1)

        ::Portunus::TypeCaster.cast(value: 1, type: :integer)
      end
    end

    context "with the type of float" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::Float).
          to receive(:cast).
          with(value: 3.42)

        ::Portunus::TypeCaster.cast(value: 3.42, type: :float)
      end
    end

    context "with the type of date" do
      it "should call the appropriate casting class" do
        date = Date.today
        expect(::Portunus::TypeCasters::Date).
          to receive(:cast).
          with(value: date)

        ::Portunus::TypeCaster.cast(value: date, type: :date)
      end
    end

    context "with the type of DateTime" do
      it "should call the appropriate casting class" do
        datetime = DateTime.now

        expect(::Portunus::TypeCasters::DateTime).
          to receive(:cast).
          with(value: datetime)

        ::Portunus::TypeCaster.cast(value: datetime, type: :datetime)
      end
    end

    context "with the type of boolean" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::Boolean).
          to receive(:cast).
          with(value: true)

        ::Portunus::TypeCaster.cast(value: true, type: :boolean)
      end
    end
  end

  describe "#uncast" do
    context "with the type of string" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::String).
          to receive(:uncast).
          with(value: "Pascal")

        ::Portunus::TypeCaster.uncast(value: "Pascal", type: :string)
      end
    end

    context "with the type of integer" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::Integer).
          to receive(:uncast).
          with(value: "1")

        ::Portunus::TypeCaster.uncast(value: "1", type: :integer)
      end
    end

    context "with the type of float" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::Float).
          to receive(:uncast).
          with(value: "3.42")

        ::Portunus::TypeCaster.uncast(value: "3.42", type: :float)
      end
    end

    context "with the type of date" do
      it "should call the appropriate casting class" do
        date = Date.today
        expect(::Portunus::TypeCasters::Date).
          to receive(:uncast).
          with(value: date.to_s)

        ::Portunus::TypeCaster.uncast(value: date.to_s, type: :date)
      end
    end

    context "with the type of DateTime" do
      it "should call the appropriate casting class" do
        datetime = DateTime.now

        expect(::Portunus::TypeCasters::DateTime).
          to receive(:uncast).
          with(value: datetime.to_s)

        ::Portunus::TypeCaster.uncast(value: datetime.to_s, type: :datetime)
      end
    end

    context "with the type of boolean" do
      it "should call the appropriate casting class" do
        expect(::Portunus::TypeCasters::Boolean).
          to receive(:uncast).
          with(value: "true")

        ::Portunus::TypeCaster.uncast(value: "true", type: :boolean)
      end
    end
  end
end
