page 50006 "Logical Framework Outcome"
{
    PageType = ListPart;
    SourceTable = "Logical Framework Outcome";
    Caption = 'Outcome';
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(OVI; Rec.OVI)
                {
                    Caption = 'OVIs';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the OVIs field.';
                }
                field(MoV; Rec.MoV)
                {
                    Caption = 'MoVs';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the MoVs field.';
                }
                field(Risks; Rec.Risks)
                {
                    Caption = 'Assumptions/Risks';
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Assumptions/Risks field.';
                }

            }
        }
    }
}