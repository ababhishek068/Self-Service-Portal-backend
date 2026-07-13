page 51260 "HR Exit Interview List"
{
    CardPageID = "HR Employee Exit Requisition";
    Editable = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "HR Employee Exit Interviews";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Exit Clearance No"; Rec."Exit Clearance No")
                {
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Exit Clearance No field.';
                }
                field("Date Of Clearance"; Rec."Date Of Clearance")
                {
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Of Clearance field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Interview Done By"; Rec."Clearer Name")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Clearer Name field.';
                }
                field("Nature Of Separation"; Rec."Nature Of Separation")
                {
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Nature Of Separation field.';
                }
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date Of Leaving field.';
                }
                field("Re Employ In Future"; Rec."Re Employ In Future")
                {
                    Importance = Promoted;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Re Employ In Future field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755004; Outlook) { }
            systempart(Control1102755006; Notes) { }
        }
    }

    actions { }
}

