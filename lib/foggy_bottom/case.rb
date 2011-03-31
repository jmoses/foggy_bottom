class FoggyBottom::Case < OpenStruct
  DEFAULT_COLUMNS = %w(
    ixBug
    ixBugParent
    ixBugChildren
    tags
    fOpen
    sTitle
    sOriginalTitle
    sLatestTextSummary
    ixBugEventLatestText
    ixProject
    sProject
    ixArea
    sArea
    ixGroup
    ixPersonAssignedTo
    sPersonAssignedTo
    sEmailAssignedTo
    ixPersonOpenedBy
    ixPersonResolvedBy
    ixPersonClosedBy
    ixPersonLastEditedBy
    ixStatus
    sStatus
    ixPriority
    sPriority
    ixFixFor
    sFixFor
    dtFixFor
    sVersion
    sComputer
    hrsOrigEst
    hrsCurrEst
    hrsElapsed
    c
    sCustomerEmail
    ixMailbox
    ixCategory
    sCategory
    dtOpened
    dtResolved
    dtClosed
    ixBugEventLatest
    dtLastUpdated
    fReplied
    fForwarded
    sTicket
    ixDiscussTopic
    dtDue
    sReleaseNotes
    ixBugEventLastView
    dtLastView
    ixRelatedBugs
    sScoutDescription
    sScoutMessage
    fScoutStopReporting
    fSubscribed
  )
  attr_reader :api, :tags

  def self.find( case_id, api )
    details = api.exec(:search, :q => case_id, :cols => DEFAULT_COLUMNS.join(',') ).at_css("case")

    if details
      new(api).tap do |instance|
        (DEFAULT_COLUMNS - %w(tags)).each do |col|
          instance.send("#{col}=".to_sym, details.at_css(col).content )
        end

        instance.tags = [].tap do |tags|
          details.css("tag").each {|t| tags << t.content }
        end
      end
    end
  end

  def initialize(api)
    super()
    @api = api
  end
end
