Page 50758 "Sec-Visitor Manager (Cleared)"
{
    CardPageID = "Cleared-Visitor Card";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Sec-Visitor Management";
    SourceTableView = where(Status = filter(Cleared), "Incident Reported" = filter(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Visitor Name"; Rec."Visitor Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Visitor Name';
                    ToolTip = 'Specifies the value of the Visitor Name field.';
                }
                field(PurposeofVisit; Rec."Purpose of Visit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose of Visit field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(PhoneNumber; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field("Person To See"; Rec."Person To See")
                {
                    ApplicationArea = Basic;
                    Caption = 'Person To See';
                    ToolTip = 'Specifies the value of the Person To See field.';
                }
                field("Person To See Name"; Rec."Person To See Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Person To See Name';
                    ToolTip = 'Specifies the value of the Person To See Name field.';
                }
                field(CarRegNumber; Rec."Car Reg. Number")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Car Reg. Number field.';
                }
                field(VisitorPassNo; Rec."Visitor Pass No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visitor Pass No. field.';
                }
                field(VisitorCarRegNumber; Rec."Visitor Car Reg Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visitor Car Reg Number field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(InitiatedBy; Rec."Initiated By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Initiated By field.';
                }
                field("Initiated Date"; Rec."Initiated Date")
                {
                    Caption = 'Visit Date';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visit Date field.';
                }
                field(InitiatedByTime; Rec."Initiated By Time")
                {
                    Caption = 'Visit Time';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Visit Time field.';
                }
                field(ClearedBy; Rec."Cleared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared By field.';
                }
                field("Cleared Date"; Rec."Cleared Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared Date field.';
                }
                field(ClearedByTime; Rec."Cleared By Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cleared By Time field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
            }
        }
    }

    actions { }
    trigger OnOpenPage()
    var
        HREmp: Record "HR-Employee";
    begin
        HREmp.Reset();
        HREmp.SetRange("User ID", UserId);
        if HREmp.Find('-') then
            Rec.SETFILTER(Station, HREmp."Global Dimension 1 Code")
        else
            Error('Your Station has not been set. Contact HR');
    end;
}

