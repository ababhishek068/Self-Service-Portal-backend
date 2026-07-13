page 51322 "HMS Pharmacy History List"
{
    CardPageID = "HMS Pharmacy Header History";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HMS Pharmacy Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                ShowCaption = false;
                field("Pharmacy No."; Rec."Pharmacy No.")
                {
                    ToolTip = 'Specifies the value of the Pharmacy No. field.';
                }
                field("Pharmacy Date"; Rec."Pharmacy Date")
                {
                    ToolTip = 'Specifies the value of the Pharmacy Date field.';
                }
                field("Pharmacy Time"; Rec."Pharmacy Time")
                {
                    ToolTip = 'Specifies the value of the Pharmacy Time field.';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field("Student No."; Rec."Student No.")
                {
                    ToolTip = 'Specifies the value of the Student No. field.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field("ADM No"; Rec."ADM No")
                {
                    ToolTip = 'Specifies the value of the ADM No field.';
                }
                field(Surname; Rec.Surname)
                {
                    ToolTip = 'Specifies the value of the Surname field.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field("Issued By"; Rec."Issued By")
                {
                    ToolTip = 'Specifies the value of the Issued By field.';
                }
                field("Link Type"; Rec."Link Type")
                {
                    ToolTip = 'Specifies the value of the Link Type field.';
                }
                field("Cash Sale"; Rec."Cash Sale")
                {
                    ToolTip = 'Specifies the value of the Cash Sale field.';
                }
                field("Receipt Count"; Rec."Receipt Count")
                {
                    ToolTip = 'Specifies the value of the Receipt Count field.';
                }
                field("Link No."; Rec."Link No.")
                {
                    ToolTip = 'Specifies the value of the Link No. field.';
                }
                field("Insurance No"; Rec."Insurance No")
                {
                    ToolTip = 'Specifies the value of the Insurance No field.';
                }
                field("Patient Type"; Rec."Patient Type")
                {
                    ToolTip = 'Specifies the value of the Patient Type field.';
                }
            }
        }
    }

    actions { }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

