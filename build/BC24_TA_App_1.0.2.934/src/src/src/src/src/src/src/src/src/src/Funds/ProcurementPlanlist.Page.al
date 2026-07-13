Page 50858 "Procurement Plan list"
{
    CardPageID = "Procurement Plan";
    PageType = List;
    SourceTable = "Procurement Plan Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(BudgetName; Rec."Budget Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Name field.';
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.';
                }
                field(CampusCode; Rec."Global Dimension 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.';
                }
                field(ProcurementPlanPeriod; Rec."Procurement Plan Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Procurement Plan Period field.';
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

