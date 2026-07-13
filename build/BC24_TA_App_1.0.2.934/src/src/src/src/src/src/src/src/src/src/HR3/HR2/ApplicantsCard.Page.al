page 51222 "Applicants Card"
{
    PageType = Card;
    SourceTable = "HR Job Applicants";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Job Application No."; Rec."Job Application No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Job Application No. field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Account No field.';

                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(Initials; Rec.Initials)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Initials field.';
                }
                field("First Language (R/W/S)"; Rec."First Language (R/W/S)")
                {
                    Caption = '1st Language (R/W/S)';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the 1st Language (R/W/S) field.';
                }
                field("First Language Read"; Rec."First Language Read")
                {
                    Caption = 'R';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the R field.';
                }
                field("First Language Write"; Rec."First Language Write")
                {
                    Caption = 'W';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the W field.';
                }
                field("Second Language (R/W/S)"; Rec."Second Language (R/W/S)")
                {
                    Caption = '2nd Language (R/W/S)';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the 2nd Language (R/W/S) field.';
                }
                field("Second Language Read"; Rec."Second Language Read")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Second Language Read field.';
                }
                field("Second Language Write"; Rec."Second Language Write")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Second Language Write field.';
                }
                field("Additional Language"; Rec."Additional Language")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Additional Language field.';
                }
                field("Applicant Type"; Rec."Applicant Type")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Applicant Type field.';
                }


                field("Employee No"; Rec."Employee No")
                {
                    Caption = 'Internal';
                    Editable = true;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Internal field.';
                }
                field("First Language Speak"; Rec."First Language Speak")
                {
                    Caption = 'S';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the S field.';
                }
                field("Second Language Speak"; Rec."Second Language Speak")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Second Language Speak field.';
                }
                field("ID Number"; Rec."ID Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the ID Number field.';
                }

                field(Gender; Rec.Gender)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(Citizenship; Rec.Citizenship)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Citizenship field.';
                }
                field("Employee Requisition No"; Rec."Employee Requisition No")
                {
                    Caption = 'Position Application Reff No.';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Position Application Reff No. field.';

                }
                field("Job Applied For"; Rec."Job Applied For")
                {
                    Caption = 'Position Applied For';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Position Applied For field.';
                }

                field(Qualified; Rec.Qualified)
                {

                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Qualified field.';
                }
                field(Uploaded; Rec.Uploaded)
                {
                    Caption = 'Employed';
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employed field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }

                field("Qualified Stages Count"; Rec."Qualified Stages Count")
                {

                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Qualified Stages Count field.';
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field(Status; Rec.Status)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Marital Status field.';
                }
                field("Ethnic Origin"; Rec."Ethnic Origin")
                {
                    ApplicationArea = basic;
                    Visible=false;
                    ToolTip = 'Specifies the value of the Ethnic Origin field.';
                }
                field(Disabled; Rec.Disabled)
                {
                    ApplicationArea = basic;
                    Caption = 'Physically Challenged';
                    ToolTip = 'Specifies the value of the Physically Challenged field.';
                }
                field("Health Assesment?"; Rec."Health Assesment?")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Health Assesment? field.';
                }
                field("Health Assesment Date"; Rec."Health Assesment Date")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Health Assesment Date field.';
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Age field.';
                }
                field("Place of Birth";"Place of Birth"){}
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Home Phone Number"; Rec."Home Phone Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Home Phone Number field.';
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }
                field("Postal Address2"; Rec."Postal Address2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Postal Address2 field.';
                }
                field("Postal Address3"; Rec."Postal Address3")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Postal Address3 field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("Residential Address"; Rec."Residential Address")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Residential Address field.';
                }
                field("Residential Address2"; Rec."Residential Address2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Residential Address2 field.';
                }
                field("Residential Address3"; Rec."Residential Address3")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Residential Address3 field.';
                }
                field("Post Code2"; Rec."Post Code2")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Post Code2 field.';
                }
                field("Cellular Phone Number"; Rec."Cell Phone Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Cell Phone Number field.';
                }
                field("Work Phone Number"; Rec."Work Phone Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Work Phone Number field.';
                }
                field("Ext."; Rec."Ext.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Ext. field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field("Fax Number"; Rec."Fax Number")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Fax Number field.';
                }
            }
            group(Qualifications)
            {
                Caption = 'Qualifications';
                part(Control1000000020; "HR Applicant Qualifications")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Account No" = FIELD("Account No");
                }
            }
            group(EmplomentH)
            {
                Caption = 'Employment History';
                part(Control10000000221; "Applicants Employment History")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Account No" = FIELD("Account No");
                }
            }
            group(CurrEmp)
            {
                Caption = 'Current Employment';
                part(Control10000000223; "Applicant Employment Details")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Account No" = FIELD("Account No");
                }
            }
            group(Referees)
            {
                Caption = 'Referees';
                part(Control1000000085; "HR Applicant Referees")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Account No" = FIELD("Account No");
                }
            }
            group(Hobbies)
            {
                Caption = 'Hobbies';
                part(Control1000000089; Hobbies)
                {
                    ApplicationArea = basic;
                    SubPageLink = "Account No" = FIELD("Account No");
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                part(Control1000000093; "Applicants Document Link")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Applicant No" = FIELD("Job Application No.");
                }
            }
            group("Medical Info")
            {
                Caption = 'Medical Info';
                part(Control1000000094; "Applicants Medical Info")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Applicant No" = FIELD("Job Application No.");
                }
            }
            group("View/Comments")
            {
                Caption = 'View/Comments';
                part(Control1000000095; "Applicants Comments/Views")
                {
                    ApplicationArea = basic;
                    SubPageLink = "Applicant No" = FIELD("Job Application No.");
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

