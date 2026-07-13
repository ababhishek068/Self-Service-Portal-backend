Page 50096 "Lecturers Units/Subjects"
{
    PageType = ListPart;
    SourceTable = "Lecturers Units";
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
                    ToolTip = 'Specifies the value of the Programme field.';
                }
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field(Semester; Rec.Semester)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Semester field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field("Unit School"; Rec."Unit School")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit School field.';
                }
                field("Unit Department"; Rec."Unit Department")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Department field.';
                }
                field("Units Section Type"; Rec."Units Section Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Units Section Type field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Rate; Rec.Rate)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rate field.';
                }
                field(NoOfHours; Rec."No. Of Hours")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Of Hours field.';
                }
                field(StudentType; Rec."Student Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student Type field.';
                }
                field(AvailableFrom; Rec."Available From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Available From field.';
                }
                field(AvailableTo; Rec."Available To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Available To field.';
                }
                field("Parttime Allocation"; Rec."Parttime Allocation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Parttime Allocation field.';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic;
                    Caption = 'Class ';
                    ToolTip = 'Specifies the value of the Class  field.';
                }
                field(ContractedHours; Rec."No. Of Hours Contracted")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contracted Hours ';
                    ToolTip = 'Specifies the value of the Contracted Hours  field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("PSSP Class Students"; Rec."PSSP Class Students")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PSSP Class Students field.';

                }
                field("GSSP Class Students"; Rec."GSSP Class Students")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the GSSP Class Students field.';

                }
                field("Programme Category"; Rec."Programme Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Programme Category field.';
                }
                field(Claimed; Rec.Claimed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Claimed field.';
                }
            }
        }
    }

    actions
    {
        area(Processing) { }
    }

    trigger OnAfterGetRecord()
    begin
        Units.Reset;
        //IF Units.GET(Programme,Stage,Unit) THEN
    end;

    var
        Units: Record "Units/Subjects";
}

