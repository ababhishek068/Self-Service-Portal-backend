Page 51051 "HMS Observation SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HMS Observation Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field(ObservationNo; Rec."Observation No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation No. field.';
                }
                field(ObservationType; Rec."Observation Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Type field.';
                }
                field(ObservationDate; Rec."Observation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Date field.';
                }
                field(ObservationTime; Rec."Observation Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Time field.';
                }
                field(ObservationRemarks; Rec."Observation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Observation Remarks field.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Closed field.';
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

