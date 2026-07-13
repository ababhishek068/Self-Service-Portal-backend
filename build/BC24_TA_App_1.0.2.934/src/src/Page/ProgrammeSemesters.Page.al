Page 50445 "Programme Semesters"
{
    PageType = List;
    SourceTable = "Programme Semesters";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(Desc; Desc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Current; Rec.Current)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(IntakeSemester; Rec."Intake Semester")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Intake Semester field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        if Sem.Get(Rec.Semester) then
            Desc := Sem.Description
        else
            Desc := '';
    end;

    var
        Sem: Record Semesters;
        Desc: Text[200];
}

