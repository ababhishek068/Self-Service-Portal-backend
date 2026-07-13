Page 51374 "HMS Radiology SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HMS Radiology Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(RadiologyNo; Rec."Radiology No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Radiology No. field.';
                }
                field(RadiologyDate; Rec."Radiology Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Radiology Date field.';
                }
                field(RadiologyTime; Rec."Radiology Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Radiology Time field.';
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
            }
        }
    }

    actions { }
}

