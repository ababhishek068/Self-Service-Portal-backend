Page 51225 "Applicants Document Link"
{
    PageType = ListPart;
    SourceTable = "Applicants Document Link";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(DocumentDescription; Rec."Document Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Description field.';
                }
                field(DocumentLink; Rec."Document Link")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Link field.';
                }
                field("Applicant No"; Rec."Applicant No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Applicant No field.';
                }
                field(LineNo; Rec."Line No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field(UserName; Rec."User Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email Address field.';
                }
            }
        }
    }

    actions { }
}

