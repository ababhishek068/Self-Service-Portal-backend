page 51076 "Logical Framework List"
{
    PageType = List;
    SourceTable = "Logical Framework";
    Caption = 'Logical Framework';
    CardPageId = "Logical Framework Card";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Strategic Plan"; Rec."Strategic Plan")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Strategic Plan field.';
                }
                field("KRA Code"; Rec."KRA Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the KRA Code field.';
                }
                field("Strategic Objective"; Rec."Strategic Objective")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Strategic Objective field.';
                }
                field("Annual Plan"; Rec."Annual Plan")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Annual Plan field.';
                }

                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Created On field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
            }
        }
    }
}