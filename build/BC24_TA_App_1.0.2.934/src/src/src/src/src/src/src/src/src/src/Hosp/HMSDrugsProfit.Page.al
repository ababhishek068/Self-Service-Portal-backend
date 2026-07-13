Page 50300 "HMS Drugs Profit"
{
    PageType = List;
    SourceTable = "HMS Patients Drugs Profit";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PatientsType; Rec."Patients Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patients Type field.';
                }
                field(DrugsProfitPerc; Rec."Drugs Profit Perc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drugs Profit Perc. field.';
                }
            }
        }
    }

    actions { }
}

