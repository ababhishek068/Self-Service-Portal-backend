Page 50806 "Disposal Plan List"
{
    CardPageID = "Disposal Plan";
    Editable = false;
    PageType = List;
    SourceTable = "Disposal Plan Table Header";
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
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(DisposalYear; Rec."Disposal Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Year field.';
                }
                field(DisposalDescription; Rec."Disposal Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Description field.';
                }
                field(DisposalMethod; Rec."Disposal Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disposal Method field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(PlannedDate; Rec."Planned Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Planned Date field.';
                }
                field(DepartmentCode; Rec."Shortcut dimension 1 code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                }
                field(RegionCode; Rec."Shortcut dimension 2 code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
            }
        }
    }

    actions { }
}

