Page 51223 "Applicants Qualification"
{
    PageType = ListPart;
    SourceTable = "Applicants Qualification";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(QualificationType; Rec."Qualification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Type field.';
                }
                field(QualificationCode; Rec."Qualification Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification Code field.';
                }
                field(Qualification; Rec.Qualification)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification field.';
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(InstitutionCompany; Rec."Institution/Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution/Company field.';
                }
                field(ScoreID; Rec."Score ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score ID field.';
                }
            }
        }
    }

    actions { }
}

