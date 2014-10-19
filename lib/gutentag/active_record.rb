require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_tags
      has_many :taggings, :class_name => 'Gutentag::Tagging', :as => :taggable,
        :dependent => :destroy
      has_many :tags,     :class_name => 'Gutentag::Tag',
        :through => :taggings

      after_save { |instance| Gutentag::Persistence.new(instance).persist  }
    end
  end

  def reset_tag_names
    @tag_names = nil
  end

  def tag_names
    @tag_names ||= tags.collect(&:name)
  end

  def tag_names=(names, delimiter='|')
    names_array = Array( names.split(delimiter) ).flatten
    Gutentag::Dirty.call self, names_array

    @tag_names = names_array
  end
end
