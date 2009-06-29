class Item < ActiveRecord::Base
  set_inheritance_column 'object_type'
end
