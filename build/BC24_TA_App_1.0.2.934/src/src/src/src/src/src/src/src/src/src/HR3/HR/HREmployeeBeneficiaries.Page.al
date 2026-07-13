page 50329 "HR Employee Beneficiaries"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = "HR-Employee";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Employee Details")
            {
                Caption = 'Employee Details';
                field("No."; Rec."No.")
                {
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Full Name"; Rec."Full Name")
                {
                    Caption = 'Name';
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    Editable = false;
                    Enabled = false;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Postal Address field.';
                }
                field(Gender; Rec.Gender)
                {
                    Editable = false;
                    Enabled = false;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    Editable = false;
                    Enabled = false;
                    StyleExpr = TRUE;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field("Cellular Phone Number"; Rec."Cellular Phone Number")
                {
                    Editable = false;
                    Enabled = false;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Cellular Phone Number field.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
            }
            part(Control1102755008; "HR Employee Beneficiary")
            {
                ApplicationArea = basic;
                SubPageLink = "Employee Code" = FIELD("No."),
                               Type = CONST(Beneficiary);
            }
        }
        area(factboxes)
        {

            systempart(Control1102755002; Outlook) { }
        }
    }

    actions { }
}

