Page 50532 "Salary Grades List"
{
    Editable = true;
    PageType = List;
    SourceTable = "Sal Grades";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Job Group"; "Job Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the job grade.';
                }
                field(SalaryGrade; Rec."Salary Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                }
                field(Managerial; Managerial) { }

                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Global Dimension 2 Name"; "Global Dimension 2 Name")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(SalaryAmount; Rec."Salary Gross Amount")
                {
                    Caption = 'Gross Amount';
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Gross Amount field.';
                }
                field(Basicsalary; Rec.Basic_salary)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Basic_salary field.';
                }
                field(HouseAllowance; Rec."House Allowance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the House Allowance field.';
                }
                field("Hardship Allowance"; Rec."Hardship Allowance")
                {
                    ApplicationArea = Basic;
                    visible = false;
                    ToolTip = 'Specifies the value of the Leave Allowance field.';
                }
                field("Travel Allowance"; Rec."Travel Allowance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Travel Allowance field.';
                    Visible = false;
                }
                field("Transport Allowance"; "Transport Allowance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mobicard Allowance field.';
                }
                field("Position Allowance"; "Position Allowance") { }


            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Notches)
            {
                Caption = 'Grade Notches';

                RunObject = page "PR Employee Salary Rates List";
                RunPageLink = "Job Group" = field("Job Group");
                ToolTip = 'Executes the Grade Notches action.';
            }
        }

    }
}

