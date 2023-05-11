class Item < ApplicationRecord
    num status: { inactive: 0, active: 1 }
end
