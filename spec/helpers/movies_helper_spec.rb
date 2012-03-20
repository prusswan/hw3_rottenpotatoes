require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the MoviesHelper. For example:
#
# describe MoviesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe MoviesHelper do

  before do
    @odd_num = 325 * 2 + 1
    @even_num = 324 * 2
  end

  describe "oddness count" do
    it "should identify an odd number" do
      oddness(@odd_num).should == 'odd'
    end

    it "should identify an even number" do
      oddness(@even_num).should == 'even'
    end
  end

end

