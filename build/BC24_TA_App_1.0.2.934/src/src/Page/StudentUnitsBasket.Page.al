Page 51129 "Student Units Basket"
{
    PageType = List;
    SourceTable = "Student Unit Basket";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RegTransactonID; Rec."Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    visible = false;
                    ToolTip = 'Specifies the value of the Reg. Transacton ID field.';
                }
                field(StudentNo; Rec."Student No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    visible = false;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field("Register for"; Rec."Register for")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Register for field.';
                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }

                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Name field.';
                }
                field(Campus; Rec.Campus)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus field.';
                }
                field("Class Code"; Rec."Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Class Code field.';
                }
                field("Day Code"; Rec."Day Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Day Code field.';
                }
                field("Period Code"; Rec."Period Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period Code field.';
                }
                field(Audit; Rec.Audit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Audit field.';
                }
                field("CF Count"; Rec."CF Count")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CF Count field.';
                }
                field(UnitStage; Rec."Unit Stage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Stage field.';
                }
                field(DateSubmitted; Rec."Date Submitted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Submitted field.';
                }
                field("Reg. Transacton ID"; Rec."Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reg. Transacton ID field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DropUnit)
            {
                ApplicationArea = Basic;
                Caption = 'Drop Selected Unit';
                Image = "Invoicing-Delete";
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Drop Selected Unit action.';

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to drop this unit for this student?', true) = true then begin
                        if Rec.Unit = '' then Error('No Unit selected to drop');
                        //webportal.DropStudentUnits("Student No.", Semester, '', Programme, Unit,true);
                        Message('Unit dropped successfully');
                    end;
                end;
            }
        }
    }
    var
    // webportal: Codeunit Webportal;
}



