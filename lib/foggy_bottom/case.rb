class FoggyBottom::Case
  include FoggyBottom::Columns::Case

  include ActiveModel::AttributeMethods
  include ActiveModel::Dirty
  include ActiveModel::Serialization

  define_attribute_methods ALL_COLUMNS

  attr_accessor :api

  delegate :logger, :to => :api

  class << self
    def find( case_id, api )
      details = api.exec(:search, :q => case_id, :cols => FoggyBottom::Columns::Case::ALL_COLUMNS.join(',') ).at_css("case")

      create_from_xml(details, api) if details
    end

    def search( terms, api )
      api.exec(:search, :q => terms, :cols => FoggyBottom::Columns::Case::ALL_COLUMNS.join(',')).css('case').collect do |details|
        create_from_xml(details, api)
      end
    end

    def create_from_xml(xml, api)
      new( {}.tap do |attributes|
        (FoggyBottom::Columns::Case::ALL_COLUMNS - %w(tags)).each do |col|
          attributes[col] = xml.at_css(col).content
        end

        attributes['tags'] = [].tap do |tags|
          xml.css("tag").each {|t| tags << t.content }
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
    
    save!(comment)
  end

  def resolve( comment = nil )
    save!(comment, :resolve)
  end

  def to_s
    "#{ixBug} - #{sTitle}"
  end

  protected
    def attributes
      @attributes
    end

    def save!(comment, action = :edit)
      @previously_changed = changes

      logger.debug("Saving changes for #{ixBug} columns #{changed.join(', ')} with action #{action}")
      api.exec(action, parameters('sEvent' => comment))
      logger.debug(" done")

      @changed_attributes.clear
    end

    def parameters( extra = {} )
      changed.inject({}) {|memo, key| memo.merge(key => send(key))}.merge(extra).merge('ixBug' => ixBug)
    end
end
