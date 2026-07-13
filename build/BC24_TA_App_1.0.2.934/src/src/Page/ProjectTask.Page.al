Page 50353 "Project Task"
{
    PageType = List;
    SourceTable = "Project Task";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Activity Code field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActivityAllocation)
            {
                Caption = 'Activity Allocation';
                ApplicationArea = All;
                RunObject = page "Task Allocation";
                RunPageLink = "Project No" = FIELD("Project No"), "Project Activity" = FIELD("Activity Code"), "Support Entry No" = FIELD("Entry No"), "Allocation Type" = FILTER(Implementation);
                ToolTip = 'Executes the Activity Allocation action.';
            }
        }
    }
}

