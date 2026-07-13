Page 50675 "HR Policies"
{
    PageType = List;
    SourceTable = "HR Policies";
    CardPageId = "HR Policies Card";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
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

    }
    trigger OnDeleteRecord(): Boolean
    begin
        if Code <> '' then
            Error('You cannot delete the record');
    end;
}



