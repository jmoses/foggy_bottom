module FoggyBottom
  module Columns
    module Case
      def self.included(base)
        base.class_eval do
          ALL_COLUMNS.each do |column|
            define_method(column) do
              @attributes[column]
            end

            define_method("#{column}=") do |arg|
              send("#{column}_will_change!") unless send(column) == arg

              @attributes[column] = arg
            end
          end
        end
      end

      ALL_COLUMNS = %w(
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
    end
  end
end
