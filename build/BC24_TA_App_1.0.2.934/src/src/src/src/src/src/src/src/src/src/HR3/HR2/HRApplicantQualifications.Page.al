Page 51265 "HR Applicant Qualifications"
{

    Caption = 'Applicant Qualifications';
    PageType = ListPart;
    SaveValues = true;
    ShowFilter = true;
    SourceTable = "HR Applicant Qualifications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control18)
            {
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field("Qualification Category"; Rec."Qualification Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Category field.';
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                }
                field(QualificationDescription; Rec."Qualification Description")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Qualification Description field.';
                }

                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }

                field(InstitutionCompany; Rec."Institution/Company")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Institution/Company field.';
                }
                field(Award; Rec.Award)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Award field.';
                }
                field("Score ID"; Rec."Score ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score ID field.';
                }

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No. field.';
                }

                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }



            }
        }
    }

    actions { }
}

