class Testing < Flake
  attr_accessor :input

  def execute
    with_valid_params do
      success(input)
    end
  end
end

describe Flake do
  it "retuns success input" do
    expect(Testing.execute(input: "success")).to eql("success")
  end
end
