Page 51197 "Conference Lines"
{
    PageType = ListPart;
    SourceTable = "Conference Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(ExpenseType; Rec."Expense Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expense Type field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total field.';
                }
            }
        }
    }

    actions { }
}

