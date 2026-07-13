Page 50837 "HR Policies Card"
{
    PageType = Document;
    SourceTable = "HR Policies";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Active?"; "Active?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the boolean field.';
                }
                field(Version; Rec.Version)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the version field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the department it applies to field.';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field("Time Created"; Rec."Time Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Created field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of the expiry of the policy.';
                }
                field("Next review date"; Rec."Next review date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the review date.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(RulesRegulations; Rec."Rules & Regulations")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rules & Regulations field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By.';
                }
                field("Last modified By"; Rec."Last modified By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the modified by.';
                }
                field("Last Modified on"; Rec."Last Modified on")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Modified on.';
                }
            }
        }

        area(factboxes)
        {


            systempart(Control1900383207; Links)
            {
                Caption = 'Attachments';
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
}



