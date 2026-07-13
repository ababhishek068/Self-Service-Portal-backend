Page 50355 "Project Support"
{
    PageType = List;
    SourceTable = "Project Support";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reported Date"; Rec."Reported Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reported Date field.';
                }
                field("Report Source"; Rec."Report Source")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Report Source field.';
                }
                field("Project Module"; Rec."Project Module")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Module field.';
                }
                field("Urgency Level"; Rec."Urgency Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Urgency Level field.';
                }
                field("Client Remarks"; Rec."Client Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client Remarks field.';
                }
                field("Issue Description"; Rec."Issue Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issue Description field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Assigned Staff No"; Rec."Assigned Staff No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned Staff No field.';
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closing Date field.';
                }
                field("Client Closing Remarks"; Rec."Client Closing Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client Closing Remarks field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AssignConsultant)
            {
                Caption = 'Assign Consultant';
                ApplicationArea = All;
                RunObject = page "Support Allocation";
                RunPageLink = "Project No" = FIELD("Project No"), "Support Entry No" = FIELD("Entry No");
                ToolTip = 'Executes the Assign Consultant action.';
            }
        }
    }
}


