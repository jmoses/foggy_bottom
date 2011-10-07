class FoggyBottom::Status
  include FoggyBottom::Columns::Status

  include ActiveModel::AttributeMethods
  include ActiveModel::Dirty
  include ActiveModel::Serialization

  define_attribute_methods ALL_COLUMNS

  attr_accessor :api

  delegate :logger, :to => :api

  class << self
    def all(api)
      api.exec(:listStatuses).css("status").collect do |details|
        create_from_xml(details, api)
      end
    end

    def create_from_xml(xml, api)
      new( {}.tap do |attributes|
        (FoggyBottom::Columns::Status::ALL_COLUMNS ).each do |col|
          attributes[col] = xml.at_css(col).content
        end
      end).tap do |instance|
        instance.api = api
      end
    end
  end

  def initialize(attributes = {})
    @attributes = attributes.stringify_keys
  end
end

