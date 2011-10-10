class ActiveRecord::Base
    
  def self.find_random *args
    # this is efficient for PostgreSQL: 
    res = find_by_sql "SELECT * FROM #{table_name} ORDER BY random() LIMIT #{(args[0] or 1)};"
    args[0] ? res : res.first
  end

  def self.find_nth num
    # should work with most RDMBSes
    (find_by_sql "SELECT * from #{table_name} LIMIT 1 OFFSET #{num};").first
  end
 
end
