Page 50332 "HR Employee Cue"
{
    PageType = CardPart;
    SourceTable = "Hr Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup(CurrentEmployees)
            {
                Caption = 'Current Employees';
                field(EmployeeActive; Rec."Employee-Active")
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Employees';
                    DrillDownPageID = "HR Employee List";
                    ToolTip = 'Specifies the value of the Current Employees field.';
                }
                field(MalePerc; MalePerc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Percentage - Male';
                    DrillDownPageID = "HR Employee List";
                    ToolTip = 'Specifies the value of the Percentage - Male field.';
                }
                field(FemalePerc; FemalePerc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Percentage - Female';
                    DrillDownPageID = "HR Employee List";
                    ToolTip = 'Specifies the value of the Percentage - Female field.';
                }
                field(EmployeesMale; Rec."Employee-Male")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees - Male';
                    DrillDownPageID = "HR Employee List";
                    ToolTip = 'Specifies the value of the Employees - Male field.';
                }
                field(EmployeesFemale; Rec."Employee-Female")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employees - Female';
                    DrillDownPageID = "HR Employee List";
                    ToolTip = 'Specifies the value of the Employees - Female field.';
                }
            }
            // cuegroup(GenderGroup)
            // {
            //     Caption = 'Gender Group';
            //     field(TeachingStaff; "Teaching Staff")
            //     {
            //         ApplicationArea = Basic;
            //     }

            // }
            cuegroup(ContractType)
            {
                Caption = 'Contract Type';
                field(ActivePermanentPR; Rec."Active Permanent (PR)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Active Permanent (PR) field.';
                }
                field(ContractEmployees; Rec."Contract Employees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Employees field.';
                }
                field("Seconded Employees"; Rec."Seconded Employees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Seconded Employees field.';
                }
                field("Interns Employees"; Rec."Interns Employees")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interns Employees field.';
                }
            }
            cuegroup(OtherCues)
            {
                Caption = 'Other Cues';

                field(InactiveEmp; Rec."Employee-InActive")
                {
                    ApplicationArea = Basic;
                    Caption = 'In-Active Employees';
                    ToolTip = 'Specifies the value of the In-Active Employees field.';
                }
            }

        }

    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Employee-Male");
        Rec.CalcFields("Employee-Female");
        if Rec."Employee-Male" > 0 then
            MalePerc := (Rec."Employee-Male" / Rec."Employee-Active") * 100;
        if Rec."Employee-FeMale" > 0 then
            FeMalePerc := (Rec."Employee-FeMale" / Rec."Employee-Active") * 100;

    end;

    var
        MalePerc: Decimal;
        FemalePerc: Decimal;
}

