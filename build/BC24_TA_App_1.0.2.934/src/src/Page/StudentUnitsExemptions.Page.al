Page 51128 "Student Units Exemptions"
{
    PageType = List;
    SourceTable = "Student Units Exemptions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Registerfor; Rec."Register for")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Register for field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(Unit; Rec.Unit)
                {

                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(CF; Rec.CF)
                {
                    caption = 'No Of Credits';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No Of Credits field.';
                }
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
                field(ApplicationDate; Rec."Application Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Application Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(ApprovalDate; Rec."Approval Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Date field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(PostUnits)
            {
                ApplicationArea = basic;
                image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the PostUnits action.';
                trigger OnAction()
                var
                    StudUnits: Record "Student Units";
                    StudExempt: record "Student Units Exemptions";
                    Billing: codeunit "Student Billing";
                    GenSetup: Record "General Set-Up";
                begin
                    GenSetup.get;
                    GenSetup.TestField("Exemption Grade");
                    GenSetup.TestField("Exemption Semester");
                    StudExempt.reset;
                    StudExempt.setrange("Student No.", Rec."Student No.");
                    StudExempt.setrange(Status, Rec.Status::Approved);
                    if StudExempt.find('-') then begin
                        repeat
                            StudUnits.reset;
                            StudUnits.setrange(Unit, StudExempt.Unit);
                            StudUnits.setrange("Student No.", StudExempt."Student No.");
                            StudUnits.setrange(Programme, StudExempt.Programme);
                            if not StudUnits.find('-') then begin
                                StudUnits.init;
                                StudUnits."Student No." := Rec."Student No.";
                                StudUnits.unit := StudExempt.Unit;
                                StudUnits."Unit Description" := StudExempt.Description;
                                StudUnits.Description := StudExempt.Description;
                                StudUnits."No. Of Units" := StudExempt.CF;
                                StudUnits.Semester := GenSetup."Exemption Semester";
                                StudUnits.Programme := StudExempt.Programme;
                                StudUnits.Stage := StudExempt.Stage;
                                StudUnits.Grade := GenSetup."Exemption Grade";
                                StudUnits."Grade Prefix" := GenSetup."Exemption Grade";
                                StudUnits.insert;
                            end;

                        until StudExempt.next = 0;
                    end;
                    Billing.GenerateStudentAuditUnits(Rec."Student No.");
                    message('Posted Successfully');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Units.Reset;
        Units.SetRange(Units."Programme Code", Rec.Programme);
        Units.SetRange(Units."Stage Code", Rec.Stage);
        Units.SetRange(Units.Code, Rec.Unit);
        if Units.Find('-') then
            Desc := Units.Desription
        else
            Desc := '';
    end;

    trigger OnOpenPage()
    begin
        Desc := '';
    end;

    var
        Units: Record "Units/Subjects";
        Desc: Text[250];
}

