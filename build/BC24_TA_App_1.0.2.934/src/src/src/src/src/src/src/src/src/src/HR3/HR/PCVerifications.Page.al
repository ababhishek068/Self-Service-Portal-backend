page 50669 "PC Verifications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Verifications";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Strategic Plan"; Rec."Strategic Plan")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
                field("Key Result Areas"; Rec."Key Result Areas")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Key Result Areas field.';
                }
                field(Objective; Rec.Objective)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Objective field.';
                }
                field("Annual Plan"; Rec."Annual Plan")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Annual Plan field.';
                }
                field(Impact; Rec.Impact)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Impact field.';

                }
                field(Outcome; Rec.Outcome)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Outcome field.';
                }
                field(Output; Rec.Output)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Output field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';

                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
            }


        }
    }
}