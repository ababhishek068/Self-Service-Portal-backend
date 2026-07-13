Page 51095 "HR Lookup Values Factbox"
{
    Caption = 'HR Lookup Values Factbox';
    PageType = CardPart;
    SourceTable = "HR Lookup Values";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Type field.';
            }
            field("Code"; Rec.Code)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Code field.';
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Description field.';
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Remarks field.';
            }
            field("Notice Period"; Rec."Notice Period")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Notice Period field.';
            }
            field(Closed; Rec.Closed)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Closed field.';
            }
            field("Contract Length"; Rec."Contract Length")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Contract Length field.';
            }
            field("Current Appraisal Period"; Rec."Current Appraisal Period")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Current Appraisal Period field.';
            }
            field("Disciplinary Case Rating"; Rec."Disciplinary Case Rating")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Disciplinary Case Rating field.';
            }
            field("Disciplinary Action"; Rec."Disciplinary Action")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Disciplinary Action field.';
            }
            field(From; Rec.From)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the From field.';
            }
            field("To"; Rec."To")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the To field.';
            }
            field(Score; Rec.Score)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Score field.';
            }
            field("Basic Salary"; Rec."Basic Salary")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Basic Salary field.';
            }
            field("To be cleared by"; Rec."To be cleared by")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the To be cleared by field.';
            }
        }
    }

    actions { }
}

