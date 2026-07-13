page 51464 "Internal Employee History"
{
    PageType = Document;
    SourceTable = "HR-Employee";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Genera)
            {
                Caption = 'Genera';
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the No. field.';
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
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Date Of Joining the Company"; Rec."Date Of Joining the Company")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Of Joining the Company field.';
                }
            }
            part(KPA1; "Internal Emp History Lines")
            {
                ApplicationArea = basic;
                SubPageLink = "Employee No." = FIELD("No.");
            }
            field(Control1000000030; '')
            {
                CaptionClass = Text19034996;
                ShowCaption = false;
                Style = Standard;
                StyleExpr = TRUE;
            }
        }
    }

    actions { }

    var
        Text19034996: Label 'Employment History';
}

