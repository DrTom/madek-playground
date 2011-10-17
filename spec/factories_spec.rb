require 'spec_helper'

TRIALS = 10000
LIMIT = 1000

def sum_truth_values_for_rand_bool_series *opts
  (1..TRIALS).map{FactoryHelper.rand_bool (opts and opts[0]) }.reduce(0) do |acc,value| 
  (value ? 1 : 0) + acc
  end
end


describe FactoryHelper  do

  context "(THE FOLLOWING ARE PROBABILISTIC TESTS AND THUS MAY RARELY RESULT IN FALSE NEGATIVES)" do

    context "the function rand_bool" do

      context "should create uniformely random true/false values w.o. argument" do
          sum = sum_truth_values_for_rand_bool_series
          upper_limit = TRIALS.to_f/2 + LIMIT
          lower_limit = TRIALS.to_f/2 - LIMIT
          it "the number of true values should be below the upper_limit" do
            (sum < upper_limit).should == true
          end
          it "the number of true values should be above the upper_limit" do
           (sum > lower_limit).should == true
        end
      end

      context "should create biased random true/false values" do
        sum = sum_truth_values_for_rand_bool_series 1.0/3
        upper_limit = TRIALS.to_f/3 + LIMIT 
        lower_limit = TRIALS.to_f/3 - LIMIT
        it "the number of true values should be below the upper_limit" do
          (sum < upper_limit).should == true
        end
        it "the number of true values should be above the upper_limit" do
         (sum > lower_limit).should == true
       end
      end
    end
  end
end

