class FoggyBottom::Case
  include FoggyBottom::Columns::Case

  include ActiveModel::AttributeMethods
  include ActiveModel::Dirty
  include ActiveModel::Serialization

  define_attribute_methods ALL_COLUMNS

  attr_accessor :api

  delegate :logger, :to => :api

  def self.find( case_id, api )
    details = api.exec(:search, :q => case_id, :cols => ALL_COLUMNS.join(',') ).at_css("case")

    if details
      new( {}.tap do |attributes|
        (ALL_COLUMNS - %w(tags)).each do |col|
          attributes[col] = details.at_css(col).content
        end

        attributes['tags'] = [].tap do |tags|
          details.css("tag").each {|t| tags << t.content }
        end
      end).tap do |instance|
        instance.api = api
      end
    end
  end

  def initialize(attributes = {})
    @attributes = attributes.stringify_keys
  end

  def attributes=(new_attributes)
    new_attributes.each_pair {|k,v| send("#{k}=", v) }
  end

  def save( comment = nil )
    return unless changed?
    
    @previously_changed = changes

    logger.debug("Saving changes for #{ixBug} columns #{changed.join(', ')}")
    api.exec(:edit, parameters('sEvent' => comment))
    logger.debug(" done")

    @changed_attributes.clear
  end

  protected
    def attributes
      @attributes
    end

    def parameters( extra = {} )
      changed.inject({}) {|memo, key| memo.merge(key => send(key))}.merge(extra).merge('ixBug' => ixBug)
    end
end
