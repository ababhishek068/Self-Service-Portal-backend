Page 51046 "Disposal Header List"
{
    CardPageID = "Disposal Header";
    Editable = false;
    PageType = List;
    SourceTable = "Disposal Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Desciption; Rec.Desciption)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Desciption field.';
                }
                field(DisposalMethod; Rec."Disposal Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Method field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(DisposalStatus; Rec."Disposal Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Status field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Noseries; Rec."No series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No series field.';
                }
                field(RefNo; Rec."Ref No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ref No field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Disposed; Rec.Disposed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposed field.';
                }
                field(RegionCode; Rec."Shortcut dimension 2 code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Region Code';
                    ToolTip = 'Specifies the value of the Region Code field.';
                }
                field(DepartmentCode; Rec."Shortcut dimension 1 code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Department Code';
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(DisposalPeriod; Rec."Disposal Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Period field.';
                }
            }
        }
    }

    actions { }
}

