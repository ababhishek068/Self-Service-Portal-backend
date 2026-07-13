Page 51127 "Student Units Audit"
{
    PageType = List;
    SourceTable = "Student Units Audit";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {

                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Programme field.';
                }

                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(UnitType; Rec."Unit Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Unit Type field.';
                }
                field(NoOfUnits; Rec."No. Of Units")
                {
                    ApplicationArea = Basic;
                    Caption = 'No of Credits';
                    Editable = false;
                    ToolTip = 'Specifies the value of the No of Credits field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Concentration; Rec.Concentration)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Concentration field.';
                }
                field("Date Registered"; Rec."Date Registered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Date Registered field.';
                }
                field("Semester Registered"; Rec."Semester Registered")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Semester Registered field.';
                }
                field("Progress Status"; Rec."Progress Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Progress Status field.';
                }
                field("Final Score"; Rec."Final Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Final Score field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field(GPA; Rec.GPA)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the GPA field.';
                }
                field(ClassAtt; ClassAtt)
                {
                    Caption = 'Class Attendance %';
                    Editable = false;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Attendance % field.';
                }

                field("Waived Credits"; Rec."Waived Credits")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Waived Credits field.';

                }
                field("Substitution Unit"; Rec."Substitution Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Substitution Unit field.';

                }
                field(Substituted; Rec.Substituted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Substituted field.';

                }
                field("Exam Remarks"; Rec."Exam Remarks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Exam Remarks field.';
                }
            }


        }


    }
    actions
    {
        area(Processing)
        {
            action("Re-Generate Courses")
            {
                ApplicationArea = basic;
                Image = GetLines;
                ToolTip = 'Executes the Re-Generate Courses action.';
                trigger OnAction()
                var
                    Billing: codeunit "Student Billing";
                begin
                    if Confirm('Do you really want to Re-generate units?') then
                        Billing.GenerateStudentAuditUnits(Rec."Student No.");
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.calcfields("Attendance Present Count");
        Rec.calcfields("Attendance Total Count");
        ClassAtt := 0;
        if (Rec."Attendance Total Count" > 0) and (Rec."Attendance Present Count" > 0) then
            ClassAtt := (Rec."Attendance Present Count" / Rec."Attendance Total Count") * 100;



        /* if (Grade <>'') and (Failed = false) then
            "Progress Status" := "Progress Status"::Completed
        else
            "Progress Status" := "Progress Status"::Registered;

        if ("Final Score" > 0) and (Failed = true) then
            "Progress Status" := "Progress Status"::Failed; */



    end;

    var
        ClassAtt: decimal;

}

