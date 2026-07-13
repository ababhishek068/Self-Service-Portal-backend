Page 51183 "Applicant Register Card"
{
    PageType = Document;
    SourceTable = "Applicant Register";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field("Employee ID";"Employee ID"){}

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
                field(IDNumber; Rec."ID Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }
                field(PassportNumber; Rec."Passport Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Passport Number field.';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Password field.';
                }

                field("Email Verified?"; Rec."Email Verified?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email Verified? field.';
                }
                field("Verification Token"; Rec."Verification Token")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Verification Token field.';
                }
                field(PostalAddress; Rec."Postal Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }
                field("Phone Number"; Rec."Phone Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone Number field.';
                }
                field(MaritalStatus; Rec."Marital Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field(DateofBirth; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }



                field("Living with Disability?"; Rec."Living with Disability?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Living with Disability? field.';
                }
                field(Nationality; Rec.Nationality)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Nationality field.';
                }
                field(Ethnicity; Rec.Ethnicity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ethnicity field.';
                }

                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }

                field(Region; Rec.Region)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Region field.';
                }

                field("Disability Details"; Rec."Disability Details")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disability Details field.';
                }

            }
        }
        area(factboxes)
        {
            part(Control149; "HR Applicant Picture")
            {
                Caption = 'Applicant Picture';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Account No" = FIELD("Account No");
                Visible = true;
            }
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Applicant Attachments';
                SubPageLink = "Table ID" = CONST(52505),
                              "No." = FIELD("Account No");
            }

        }
    }

    actions { }
}

