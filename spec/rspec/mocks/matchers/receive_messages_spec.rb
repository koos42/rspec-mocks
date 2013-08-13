require 'spec_helper'

module RSpec
  module Mocks
    describe "allow(...).to receive_messages(:a => 1, :b => 2)" do
      let(:obj) { double "Object" }

      it "allows the object to respond to multiple messages" do
        allow(obj).to receive_messages(:a => 1, :b => 2)
        expect(obj.a).to eq 1
        expect(obj.b).to eq 2
      end

      it "complains if a block is given" do
        expect {
          allow(obj).to receive_messages(:a => 1) { "implementation" }
        }.to raise_error "Implementation blocks aren't supported with `receive_messages`"
      end
    end

    describe "allow_any_instance_of(...).to receive_messages(:a => 1, :b => 2)" do
      let(:obj) { Object.new }

      it "allows the object to respond to multiple messages" do
        allow_any_instance_of(Object).to receive_messages(:a => 1, :b => 2)
        expect(obj.a).to eq 1
        expect(obj.b).to eq 2
      end

      it "complains if a block is given" do
        expect {
          allow_any_instance_of(Object).to receive_messages(:a => 1) { "implementation" }
        }.to raise_error "Implementation blocks aren't supported with `receive_messages`"
      end
    end

    describe "expect(...).to receive_messages(:a => 1, :b => 2)" do
      let(:obj) { double "Object" }

      let(:expectation_error) do
        failure = nil
        begin
          RSpec::Mocks.space.verify_all
        rescue RSpec::Mocks::MockExpectationError => error
          failure = error
        end
        failure
      end


      it "sets up multiple expectations" do
        expect(obj).to receive_messages(:a => 1, :b => 2)
        obj.a
        expect { RSpec::Mocks.space.verify_all }.to raise_error RSpec::Mocks::MockExpectationError
      end

      it 'fails with a sensible message' do
        expect(obj).to receive_messages(:a => 1, :b => 2)
        obj.b
        expect(expectation_error.to_s).to eq %Q{(Double "Object").a(no args)\n    expected: 1 time with any arguments\n    received: 0 times}
      end

      it 'fails with the correct location' do
        expect(obj).to receive_messages(:a => 1, :b => 2); line = __LINE__
        expect(expectation_error.backtrace[0]).to match /#{__FILE__}:#{line}/
      end

      it "complains if a block is given" do
        expect {
          expect(double).to receive_messages(:a => 1) { "implementation" }
        }.to raise_error "Implementation blocks aren't supported with `receive_messages`"
      end
    end

    describe "expect_any_instance_of(...).to receive_messages(:a => 1, :b => 2)" do
      let(:obj) { Object.new }

      it "sets up multiple expectations" do
        expect_any_instance_of(Object).to receive_messages(:a => 1, :b => 2)
        obj.a
        expect { RSpec::Mocks.space.verify_all }.to raise_error RSpec::Mocks::MockExpectationError
      end

      it "complains if a block is given" do
        expect {
          expect_any_instance_of(Object).to receive_messages(:a => 1) { "implementation" }
        }.to raise_error "Implementation blocks aren't supported with `receive_messages`"
      end
    end
  end
end