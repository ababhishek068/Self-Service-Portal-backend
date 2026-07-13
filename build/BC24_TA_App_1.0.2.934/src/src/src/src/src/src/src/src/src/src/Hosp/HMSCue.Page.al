Page 51202 "HMS Cue"
{
    PageType = CardPart;
    SourceTable = "HMS Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(RegistrationStatistics)
            {
                Caption = 'Registration Statistics';
                field(Students; Rec.Students)
                {
                    ApplicationArea = Basic;
                    Caption = 'Students';
                    DrillDownPageID = "HMS Patient Student List";
                    ToolTip = 'Specifies the value of the Students field.';
                }
                field(Employees; Rec.Employees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees';
                    DrillDownPageID = "HMS Patient Employee List";
                    ToolTip = 'Specifies the value of the Employees field.';
                }
                field(Dependants; Rec.Dependants)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dependants';
                    DrillDownPageID = "HMS Patient Relative List";
                    ToolTip = 'Specifies the value of the Dependants field.';
                }
                field(InactiveEmp; Rec."Other Patients")
                {
                    ApplicationArea = Basic;
                    Caption = 'Other Patients';
                    DrillDownPageID = "HMS Patient Others List";
                    ToolTip = 'Specifies the value of the Other Patients field.';
                }
            }
        }
    }

    actions { }
}

