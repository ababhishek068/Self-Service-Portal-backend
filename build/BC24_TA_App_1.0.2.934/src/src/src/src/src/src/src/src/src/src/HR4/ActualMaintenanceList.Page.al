Page 50375 "Actual Maintenance List"
{
    CardPageID = "Actual Maintenance Card";
    Editable = false;
    PageType = List;
    SourceTable = "Actual Maintenance ";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MaintenanceNo; Rec."Maintenance No.")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Maintenance No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(PlannedDate; Rec."Planned Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Planned Date field.';
                }
                field(Dimension1Code; Rec."Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 1 Code field.';
                }
                field(Dimension2Code; Rec."Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension 2 Code field.';
                }
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Plan No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Style = Attention;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }
}

