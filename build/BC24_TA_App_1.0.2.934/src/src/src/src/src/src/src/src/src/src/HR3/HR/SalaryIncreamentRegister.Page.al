Page 50518 "Salary Increament Register"
{
    Editable = false;
    PageType = List;
    SourceTable = "Salary Increament Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(names; names)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Name';
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(IncreamentMonth; Rec."Increament Month")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Increament Month field.';
                }
                field(IncreamentYear; Rec."Increament Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Increament Year field.';
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(PrevSalary; Rec."Prev. Salary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prev. Salary field.';
                }
                field(CurrentSalary; Rec."Current Salary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Salary field.';
                }
                field(JobGrade; Rec."Job Grade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Grade field.';
                }
                field(JobCategory; Rec."Job Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Category field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reversed field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetCurrRecord()
    begin
        Clear(names);
        if emps.Get(Rec."Employee No.") then
            names := emps."First Name" + ' ' + emps."Middle Name" + ' ' + emps."Last Name";
    end;

    var
        names: Text[250];
        emps: Record "HR-Employee";
}

