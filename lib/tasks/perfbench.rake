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

module Report

  def self.dataset_table
    ReportBuilder::Table.new :name => "Number of Objects in Dataset", :header => %w{Object Items} do
      row ["Users", User.count]
      row ["Groups", Usergroup.count]
      row ["User-Group Relations", (FactoryHelper.count_by_sql "select count(*) from usergroups_users;") ]
      row ["Mediaresources", Mediaresource.count]
      row ["Mediaresource-Userpermissions", Mediaresourceuserpermission.count ]
      row ["Mediaresource-Grouppermissions", Mediaresourcegrouppermission.count ]
      row ["Collections", Collection.count]
      row ["Collection-Userpermissions", Collectionuserpermission.count ]
      row ["Collection-Grouppermissions", Collectiongrouppermission.count ]
    end
  end



  # TODO generalize to summary
  def self.mr_can_view_table v

    ReportBuilder::Table.new :name => "can_viwe?(mediaresource,user) [milliseconds]", :header => %w{property value} do
      row ["number of samples", v.size]
      row ["median", v.median]
      row ["mean", v.mean]
      row ["std. deviation", v.sdp]
      row ["min",v.min]
      row ["max", v.max]
    end

  end
end


module Benchmark

  NUM_HEATUPS = 10;

  def self.mr_can_view
      arr = []
      (1.. 1000 + NUM_HEATUPS).each do |i| 
        user = User.find_random
        mr = Mediaresource.find_random
        StopWatch.stop_time(i > NUM_HEATUPS ? arr : nil) {Permissions.can_view? mr, user}
      end
      arr.to_scale
  end

  def self.heatup
    execute_sql %Q@ 
      EXPLAIN ANALYZE SELECT * from mediaresources;
      EXPLAIN ANALYZE SELECT * from mediaresourcegrouppermissions;
      EXPLAIN ANALYZE SELECT * from mediaresourceuserpermissions;
      EXPLAIN ANALYZE SELECT * from users;
      EXPLAIN ANALYZE SELECT * from usergroups;
      EXPLAIN ANALYZE SELECT * from usergroups_users;
    @
  end

  def self.execute_sql query
    ActiveRecord::Base.connection.execute query 
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

    #binding.pry
  
    rb=ReportBuilder.new 
    rb.add ReportBuilder::Section.new(:name => "Size of Database") 
    rb.add Report.dataset_table
    rb.add ReportBuilder::Section.new :name => "Query Times Cold/Warm"
    rb.add Report.mr_can_view_table Benchmark.mr_can_view
    Benchmark.heatup
    rb.add ReportBuilder::Section.new :name => "Query Times Hot"
    rb.add Report.mr_can_view_table Benchmark.mr_can_view

    rb.save_html('doc/perfbench/queries.html')

  end

end

