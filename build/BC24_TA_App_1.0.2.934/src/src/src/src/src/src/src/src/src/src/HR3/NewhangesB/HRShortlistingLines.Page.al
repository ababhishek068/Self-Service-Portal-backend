Page 51105 "HR Shortlisting Lines"
{
    Caption = 'Shorlisted Candidates';

    PageType = Listpart;
    SourceTable = "HR Shortlisted Applicants";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Qualified; Rec.Qualified)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualified';
                    ToolTip = 'Specifies the value of the Qualified field.';

                    trigger OnValidate()
                    begin
                        Rec."Manual Change" := true;
                        Rec.Modify;
                    end;
                }
                field(JobApplicationNo; Rec."Job Application No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Application No field.';
                }
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(MiddleName; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(IDNo; Rec."ID No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID No field.';
                }
                field(StageScore; Rec."Stage Score")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stage Score field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field(Employ; Rec.Employ)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employed';
                    ToolTip = 'Specifies the value of the Employed field.';
                }
                field(ReportingDate; Rec."Reporting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reporting Date field.';
                }
                field(ManualChange; Rec."Manual Change")
                {
                    ApplicationArea = Basic;
                    Caption = 'Manual Change';
                    ToolTip = 'Specifies the value of the Manual Change field.';
                }
            }
        }
    }

    actions { }

    procedure GetApplicantNo() AppicantNo: Code[20]
    begin
        //AppicantNo:=Applicant;
    end;
}

