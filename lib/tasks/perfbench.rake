#require 'statsample'

module StopWatch 

  def self.stop_time arr, &block 
    start_time = Time.now
    res = block.call
    end_time = Time.now
    if arr.respond_to? '<<'
      arr << (end_time - start_time) * 1000
    else
      puts "elapsed: #{(end_time - start_time) * 1000} milliseconds"
    end
    res
  end

end


namespace :perfbench do


  desc "Cleans and recreates all data"
  task :recreate_dataset => :environment do
    DatasetFactory.clear 
    #DatasetFactory.create :num_users => 150, :num_mediaresources =>  6000
    DatasetFactory.create num_users => 10000, :num_groups => 500, num_mediaresources =>  1000000
  end


  desc "Run peformance test that stresses the db and verifies efficiency of queries"
  task :queries => :environment do

    arr = []
    (1..100).each do 
      user = User.find_random
      mr = Mediaresource.find_random
      StopWatch.stop_time(arr) {Permissions.can_view? mr, user}
    end


    v = arr.to_scale
    puts "Permissions.can_view? in milliseconds"
    puts "median #{v.median}"
    puts "mean #{v.mean}"
    puts "sdp #{v.sdp}"
    puts "min #{v.min}"
    puts "max #{v.max}"

    rb=ReportBuilder.new
    rb.add(Statsample::Graph::Boxplot.new(:vectors=>[v], :minimum =>0, :maximum => 4, :height => 600))
    rb.save_html('boxplot.html')

  end

end
