Page 50808 "Disposal Period"
{
    PageType = List;
    SourceTable = "Disposal Period";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(FinancialYear; Rec."Financial Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Financial Year field.';
                }
                field(PreviousYear; Rec."Previous Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Previous Year field.';
                }
            }
        }
    }

    actions { }
}

