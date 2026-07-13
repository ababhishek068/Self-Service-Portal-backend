Page 51329 "Employment History Lines"
{
    PageType = ListPart;
    SourceTable = "HR Employment History";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(CompanyName; Rec."Company Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field(From; Rec.From)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(JobTitle; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field(KeyExperience; Rec."Key Experience")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Key Experience field.';
                }
                field(SalaryOnLeaving; Rec."Salary On Leaving")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Salary On Leaving field.';
                }
                field(PostalAddress; Rec."Postal Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(ReasonForLeaving; Rec."Reason For Leaving")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reason For Leaving field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
            }
        }
    }

    actions { }
}

