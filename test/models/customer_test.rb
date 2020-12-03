require "test_helper"

describe Customer do
  let (:alligator) {pets(:valid_pet)}
  it "can be created" do
    expect(alligator.valid?).must_equal true
  end

  it "requires name, age and human" do
    required_fields = [:name, :species, :age, :owner]

    required_fields.each do |field|
      alligator[field] = nil

      expect(alligator.valid?).must_equal false

      alligator.reload
    end
  end

  it "requires a numeric age" do
    alligator.age = "three"

    expect(alligator.valid?).must_equal false
  end
end

end
