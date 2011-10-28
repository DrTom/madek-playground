require 'spec_helper'

describe "collections_mediaresources_jointable" do

  context "data integrity" do

    it "should raise an not-null constraint error if collection_id and mediaresource_id is set to null " do
      expect { FactoryHelper.execute_sql "insert into collections_mediaresources (collection_id, mediaresource_id) values (null,null);" 
        }.to raise_error(ActiveRecord::StatementInvalid, /violates not-null constraint/)
    end

    it "should raise an InvalidForeignKey error if collection_id and mediaresource_id are not referencing rows" do
      expect { FactoryHelper.execute_sql "insert into collections_mediaresources (collection_id, mediaresource_id) values (-1,-1);" 
        }.to raise_error(ActiveRecord::InvalidForeignKey)
    end



  end

end


