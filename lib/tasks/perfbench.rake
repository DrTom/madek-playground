#require 'statsample'

require 'pry'

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
    #DatasetFactory.create :num_users => 150, :num_mediaresources =>  1000
    #DatasetFactory.create :num_users => 1000, :num_mediaresources =>  10000
    DatasetFactory.create :num_users => 10000, :num_groups => 500, :num_mediaresources =>  1000000
  end


  desc "Run peformance test that stresses the db and verifies efficiency of queries"
  task :queries => :environment do

    num_heatups = 10;
    arr = []
    (1.. 1000 + num_heatups).each do |i| 
      user = User.find_random
      mr = Mediaresource.find_random
      StopWatch.stop_time(i > num_heatups ? arr : nil) {Permissions.can_view? mr, user}
    end


    v = arr.to_scale
    puts "Permissions.can_view? in milliseconds"
    puts "median #{v.median}"
    puts "mean #{v.mean}"
    puts "sdp #{v.sdp}"
    puts "min #{v.min}"
    puts "max #{v.max}"
    puts v.summary

    #binding.pry
  
    rb=ReportBuilder.new do
      section :name => "Dataset"  do
        table :name => "Number of Objects in Dataset", :header => %w{Object Items} do
          row ["Users", User.count]
          row ["Mediaresources", Mediaresource.count]
          row ["Groups", Usergroup.count]
          row ["User-Group Relations", (FactoryHelper.count_by_sql "select count(*) from usergroups_users;") ]
          row ["Mediaresource-Userpermissions", Mediaresourceuserpermission.count ]
          row ["Mediaresource-Grouppermissions", Mediaresourcegrouppermission.count ]
        end
      end
      section :name => "Querytimes" do
        table :name => "can_viwe?, samples in milliseconds", :header => %w{property value} do
          row ["number of samples", v.size]
          row ["median", v.median]
          row ["mean", v.mean]
          row ["std. deviation", v.sdp]
          row ["min",v.min]
          row ["max", v.max]
        end
      end
    end
    #rb.add(Statsample::Graph::Boxplot.new(:vectors=>[v]))
    rb.save_html('doc/perfbench/queries.html')

  end

end
