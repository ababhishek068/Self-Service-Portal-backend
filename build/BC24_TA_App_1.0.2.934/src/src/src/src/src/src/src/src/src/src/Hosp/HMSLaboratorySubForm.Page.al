Page 51052 "HMS Laboratory SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HMS Laboratory Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(LaboratoryNo; Rec."Laboratory No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(LaboratoryDate; Rec."Laboratory Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Date field.';
                }
                field(LaboratoryTime; Rec."Laboratory Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Laboratory Time field.';
                }
                field(ScheduledDate; Rec."Scheduled Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheduled Date field.';
                }
                field(ScheduledTime; Rec."Scheduled Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheduled Time field.';
                }
                field(SupervisorID; Rec."Supervisor ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Supervisor ID field.';
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

    actions { }
}

