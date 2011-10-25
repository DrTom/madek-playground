class ActiveRecord::Base
    
  def self.find_random *args

    # this works but is in-efficient in PostgreSQL: 
    # res = find_by_sql "SELECT * FROM #{table_name} ORDER BY random() LIMIT #{(args[0] or 1)};"
    
    # this is efficient  BUT WRONG in PostgreSQL: 
    # res = find_by_sql "SELECT * FROM #{table_name} OFFSET random() LIMIT #{(args[0] or 1)};"
    #

    count = (args[0] or 1)
    overhead = [1,(Math.log count,2).ceil].max * 3
    total = count + overhead

    query = %Q@ 
      select * from #{table_name}
         where id in
            (select floor(random() * (max_id - min_id + 1))::integer + min_id
               from generate_series(1,#{total}),
                    (select max(id) as max_id,
                            min(id) as min_id
                       from #{table_name}) sq1 limit #{total} )
         order by random() limit #{count};
        @

    res = find_by_sql query

    args[0] ? res : res.first
    
  end


  def self.find_nth num
    # should work with most RDMBSes
    (find_by_sql "SELECT * from #{table_name} LIMIT 1 OFFSET #{num};").first
  end


end
